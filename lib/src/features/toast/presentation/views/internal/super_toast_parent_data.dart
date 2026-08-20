import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'super_toast_stack_layout.dart';

class SuperToastLayoutData extends ParentDataWidget<SuperToastParentData> {
  const SuperToastLayoutData({
    required this.index,
    required this.transition,
    required this.visible,
    required this.signal,
    required super.child,
    super.key,
  });

  final int index;
  final double transition;
  final bool visible;
  final int signal;

  @override
  void applyParentData(RenderObject renderObject) {
    final data = renderObject.parentData! as SuperToastParentData;
    var needsLayout = false;

    if (data.index.current != index) {
      data.index = (previous: data.index.current, current: index);
      needsLayout = true;
    }
    if (data.transition != transition) {
      data.transition = transition;
      needsLayout = true;
    }
    if (data.visible != visible) {
      data.visible = visible;
      needsLayout = true;
    }
    if (data.signal != signal) {
      data.signal = signal;
      needsLayout = true;
    }

    if (needsLayout) renderObject.markNeedsLayout();
  }

  @override
  Type get debugTypicalAncestorWidgetClass => SuperToastStackLayout;
}

class SuperToastParentData extends ContainerBoxParentData<RenderBox> {
  final MotionValue<Offset> alignment = MotionValue<Offset>(_sameOffset);
  final MotionValue<double> shift = MotionValue<double>(_sameDouble);
  final MotionValue<double> protrusion = MotionValue<double>(_sameDouble);

  ({int previous, int current}) index = (previous: 0, current: 0);
  Size? previousFrontSize;
  double transition = 0;
  bool visible = true;
  int _signal = 0;

  int get signal => _signal;

  set signal(int value) {
    _signal = value;
    alignment.capture();
    shift.capture();
    protrusion.capture();
  }
}

class MotionValue<T> {
  MotionValue(this._equals);

  final bool Function(T a, T b) _equals;
  T? begin;
  T? end;
  T? _value;

  T? get value => _value ??= begin;

  set value(T? next) {
    _value = next;
    if (next != null && end != null && _equals(next, end as T)) {
      begin = end;
      end = null;
    }
  }

  void capture() {
    begin = value;
    end = null;
  }
}

const double _epsilon = 1e-6;
bool _sameDouble(double a, double b) => (a - b).abs() < _epsilon;
bool _sameOffset(Offset a, Offset b) =>
    (a.dx - b.dx).abs() < _epsilon && (a.dy - b.dy).abs() < _epsilon;
