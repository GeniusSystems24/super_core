// ============================================================
// features/toast/presentation/views/super_toast_host.dart
// ------------------------------------------------------------
// App-level toaster host. Place it in MaterialApp.builder so active toasts stay
// in the live theme tree and raw content still has an Overlay ancestor.
// ============================================================

import 'package:flutter/material.dart';

import '../controllers/super_toast_controller.dart';
import '../models/super_toast_alignment.dart';
import '../models/super_toast_entry.dart';
import '../models/super_toast_style.dart';
import 'internal/super_toast_stack.dart';

class SuperToastHost extends StatefulWidget {
  const SuperToastHost({
    required this.child,
    this.controller,
    this.style = const SuperToastHostStyle(),
    super.key,
  });

  final Widget child;
  final SuperToastController? controller;
  final SuperToastHostStyle style;

  static SuperToastHostState of(BuildContext context) {
    final state = maybeOf(context);
    if (state != null) return state;
    throw FlutterError.fromParts([
      ErrorSummary(
        'SuperToast was called with a context that has no SuperToastHost.',
      ),
      ErrorDescription(
        'Place SuperToastHost near the application root, typically in '
        'MaterialApp.builder, then call SuperToast from a descendant context.',
      ),
      ErrorHint(
        'builder: (context, child) => SuperToastHost(child: child!),',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  static SuperToastHostState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<SuperToastHostState>();

  @override
  State<SuperToastHost> createState() => SuperToastHostState();
}

class SuperToastHostState extends State<SuperToastHost> {
  SuperToastController get controller =>
      widget.controller ?? SuperToastController.shared;

  SuperToastResolvedHostStyle get resolvedStyle => widget.style.resolve(context);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final style = resolvedStyle;
      final grouped = <SuperToastPlacement, List<SuperToastEntry>>{};
      for (final entry in controller.entries) {
        grouped.putIfAbsent(entry.placement, () => <SuperToastEntry>[]).add(entry);
      }

      final children = <Widget>[widget.child];
      for (final group in grouped.entries) {
        final placement = group.key;
        children.add(
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: style.padding,
                child: Align(
                  alignment: placement.alignment,
                  child: SuperToastStack(
                    key: ValueKey<SuperToastPlacement>(placement),
                    controller: controller,
                    style: style,
                    expandedAlignTransform: Offset(
                      placement.alignment.x,
                      placement.alignment.y,
                    ),
                    collapsedAlignTransform: placement.stackTransform,
                    entries: group.value,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      // Overlay.wrap supplies an Overlay ancestor even when this host lives in
      // MaterialApp.builder above Navigator's own overlay. This keeps widgets
      // such as SelectableText fully functional inside raw toasts.
      return Overlay.wrap(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: children,
        ),
      );
    },
  );
}
