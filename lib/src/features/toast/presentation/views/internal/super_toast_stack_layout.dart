import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../models/super_toast_style.dart';
import 'super_toast_parent_data.dart';

/// Render-object layout that morphs between a compact card deck and a fully
/// expanded vertical list while preserving each child's in-flight geometry.
class SuperToastStackLayout extends MultiChildRenderObjectWidget {
  const SuperToastStackLayout({
    required this.style,
    required this.expandedAlignTransform,
    required this.collapsedAlignTransform,
    required this.expand,
    required super.children,
    super.key,
  });

  final SuperToastResolvedHostStyle style;
  final Offset expandedAlignTransform;
  final Offset collapsedAlignTransform;
  final double expand;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderSuperToastStackLayout(
        style: style,
        expandedAlignTransform: expandedAlignTransform,
        collapsedAlignTransform: collapsedAlignTransform,
        expand: expand,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSuperToastStackLayout renderObject,
  ) {
    renderObject
      ..style = style
      ..expandedAlignTransform = expandedAlignTransform
      ..collapsedAlignTransform = collapsedAlignTransform
      ..expand = expand;
  }
}

class RenderSuperToastStackLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SuperToastParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SuperToastParentData> {
  RenderSuperToastStackLayout({
    required SuperToastResolvedHostStyle style,
    required Offset expandedAlignTransform,
    required Offset collapsedAlignTransform,
    required double expand,
  }) : _style = style,
       _expandedAlignTransform = expandedAlignTransform,
       _collapsedAlignTransform = collapsedAlignTransform,
       _expand = expand;

  SuperToastResolvedHostStyle _style;
  Offset _expandedAlignTransform;
  Offset _collapsedAlignTransform;
  double _expand;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! SuperToastParentData) {
      child.parentData = SuperToastParentData();
    }
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    var current = lastChild;
    var previousHeight = 0.0;
    var accumulated =
        collapsedAlignTransform.dy * style.expandStartSpacing;
    var visibleAccumulated = accumulated;

    while (current != null) {
      final data = current.parentData! as SuperToastParentData;
      current.layout(constraints, parentUsesSize: true);

      // Bottom-edge stacks grow upward; top-edge stacks grow downward. The
      // sign of the captured stack transform controls both cases.
      if (collapsedAlignTransform.dy < 0) {
        final iterationHeight = current == lastChild ? 0.0 : -current.size.height;
        accumulated += iterationHeight;
        if (data.visible) visibleAccumulated += iterationHeight;

        final frontNeighborHeight = current == lastChild
            ? 0.0
            : childBefore(lastChild!)!.size.height;
        final begin = data.shift.begin ??=
            accumulated + frontNeighborHeight;
        final end = data.shift.end ??= accumulated;
        data.shift.value =
            lerpDouble(begin, end, data.transition)! * expand;
        data.offset = Offset(data.offset.dx, data.shift.value!);
      } else {
        accumulated += previousHeight;
        if (data.visible) visibleAccumulated += previousHeight;

        final frontSize = current == lastChild ? Size.zero : lastChild!.size;
        final begin = data.shift.begin ??=
            accumulated -
            collapsedAlignTransform.dy * style.expandSpacing -
            frontSize.height;
        final end = data.shift.end ??= accumulated;
        data.shift.value =
            lerpDouble(begin, end, data.transition)! * expand;
        data.offset = Offset(data.offset.dx, data.shift.value!);
      }

      accumulated += collapsedAlignTransform.dy * style.expandSpacing;
      if (data.visible) {
        visibleAccumulated +=
            collapsedAlignTransform.dy * style.expandSpacing;
      }

      previousHeight = current.size.height;
      current = data.previousSibling;
    }

    final front = lastChild!;
    final frontData = front.parentData! as SuperToastParentData;

    final Size previousFrontSize;
    if (childCount >= 2) {
      final previous = childBefore(lastChild!)!;
      previousFrontSize = previous.size;
      (previous.parentData! as SuperToastParentData).previousFrontSize =
          front.size;
    } else {
      previousFrontSize = frontData.previousFrontSize ?? front.size;
    }

    final collapsedSize =
        Size.lerp(previousFrontSize, front.size, frontData.transition)!;
    final baseHeight = collapsedAlignTransform.dy < 0
        ? front.size.height
        : firstChild!.size.height;
    final expandedSize = Size(
      front.size.width,
      baseHeight + visibleAccumulated.abs(),
    );

    size = constraints.constrain(
      Size.lerp(
        collapsedSize,
        expandedSize,
        expand * frontData.transition,
      )!,
    );

    final translateY = visibleAccumulated.isNegative
        ? -visibleAccumulated * frontData.transition * expand
        : 0.0;

    var child = firstChild;
    while (child != null) {
      final data = child.parentData! as SuperToastParentData;
      final translateX =
          data.transition *
          expand *
          switch (expandedAlignTransform.dx) {
            -1 => 0.0,
            1 => size.width - child.size.width,
            _ => (size.width - child.size.width) / 2,
          };

      data.offset = Offset(translateX, data.offset.dy + translateY);
      child = data.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (childCount == 0) return;

    final frontSize = lastChild!.size;
    var child = firstChild;

    while (child != null) {
      final data = child.parentData! as SuperToastParentData;
      if (child.size.isEmpty) {
        child = data.nextSibling;
        continue;
      }

      // Never scale a toast toward the front toast's Size. Toasts can have
      // different intrinsic dimensions (title-only vs title + description,
      // suffixes, actions, raw content, etc.). Using the front Size produces
      // independent X/Y scale factors and distorts typography, icons, borders,
      // and radii whenever a differently-sized toast becomes the front card.
      //
      // Animate only the depth scalar. This guarantees scaleX == scaleY and
      // preserves every child's intrinsic aspect ratio at every frame.
      final previousDepthScale = math
          .pow(style.collapsedScale, data.index.previous)
          .toDouble();
      final currentDepthScale = math
          .pow(style.collapsedScale, data.index.current)
          .toDouble();
      final collapsedDepthScale = lerpDouble(
        previousDepthScale,
        currentDepthScale,
        data.transition,
      )!;

      // Expanded cards always render at their natural size.
      final visualScale = lerpDouble(
        collapsedDepthScale,
        1,
        expand,
      )!;

      // Align each toast's own scaled anchor to the front toast's anchor.
      // The front toast controls only deck anchor/container geometry; it never
      // controls another toast's width or height.
      final frontX =
          frontSize.width * (0.5 + collapsedAlignTransform.dx * 0.5);
      final frontY = collapsedAlignTransform.dy < 0
          ? 0.0
          : frontSize.height;

      final childX =
          child.size.width *
          visualScale *
          (0.5 + collapsedAlignTransform.dx * 0.5);
      final childY = collapsedAlignTransform.dy < 0
          ? 0.0
          : child.size.height * visualScale;

      final alignmentBegin = data.alignment.begin ??= Offset.zero;
      final alignmentEnd = Offset(frontX - childX, frontY - childY);
      final alignment = Offset.lerp(
        alignmentBegin,
        alignmentEnd,
        data.transition,
      )!;
      data.alignment.value = alignment;

      final previousDepth = data.index.previous;
      final currentDepth = data.index.current;
      final beginProtrusion = data.protrusion.begin ??=
          style.collapsedProtrusion *
          (math.log(previousDepth + 1) / math.log(2));
      final endProtrusion = data.protrusion.end ??=
          style.collapsedProtrusion *
          (math.log(currentDepth + 1) / math.log(2));
      final protrusion = lerpDouble(
        beginProtrusion,
        endProtrusion,
        data.transition,
      )!;
      data.protrusion.value = protrusion;

      final collapsedOffset =
          (alignment + collapsedAlignTransform * protrusion) * (1 - expand);

      context.pushTransform(
        needsCompositing,
        offset + data.offset + collapsedOffset,
        Matrix4.diagonal3Values(
          visualScale,
          visualScale,
          1,
        ),
        (context, transformedOffset) =>
            context.paintChild(child!, transformedOffset),
      );

      child = data.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  SuperToastResolvedHostStyle get style => _style;
  set style(SuperToastResolvedHostStyle value) {
    if (_style == value) return;
    _style = value;
    markNeedsLayout();
  }

  Offset get expandedAlignTransform => _expandedAlignTransform;
  set expandedAlignTransform(Offset value) {
    if (_expandedAlignTransform == value) return;
    _expandedAlignTransform = value;
    markNeedsLayout();
  }

  Offset get collapsedAlignTransform => _collapsedAlignTransform;
  set collapsedAlignTransform(Offset value) {
    if (_collapsedAlignTransform == value) return;
    _collapsedAlignTransform = value;
    markNeedsLayout();
  }

  double get expand => _expand;
  set expand(double value) {
    if (_expand == value) return;
    _expand = value;
    markNeedsLayout();
  }
}
