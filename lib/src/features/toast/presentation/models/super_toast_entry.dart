// Presentation-only state for one active toast.

import 'package:flutter/widgets.dart';

import '../../domain/entities/super_toast_data.dart';
import 'super_toast_alignment.dart';
import 'super_toast_style.dart';

typedef SuperToastEntryBuilder = Widget Function(BuildContext context);

class SuperToastEntry {
  SuperToastEntry({
    required this.id,
    required this.data,
    required this.placement,
    required this.textDirection,
    required this.swipeToDismiss,
    required this.dismissThreshold,
    required this.style,
    required this.builder,
    this.onDismiss,
  });

  final int id;
  final SuperToastData data;
  final SuperToastPlacement placement;
  final TextDirection textDirection;
  final List<AxisDirection> swipeToDismiss;
  final double dismissThreshold;
  final SuperToastStyle style;
  final SuperToastEntryBuilder builder;
  final VoidCallback? onDismiss;

  /// Programmatic dismissal request observed by the animated view.
  final ValueNotifier<bool> dismissing = ValueNotifier<bool>(false);

  /// Manual pause requested through [SuperToastHandle].
  final ValueNotifier<bool> manualPaused = ValueNotifier<bool>(false);

  /// Effective timer state reported by the animated view.
  final ValueNotifier<bool> timerPaused = ValueNotifier<bool>(false);

  bool get showing => !dismissing.value;

  void dispose() {
    dismissing.dispose();
    manualPaused.dispose();
    timerPaused.dispose();
  }
}
