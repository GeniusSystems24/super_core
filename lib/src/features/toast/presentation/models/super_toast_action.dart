import 'package:flutter/foundation.dart';

/// Placement of the compact convenience action within the standard toast.
enum SuperToastActionPosition { leading, trailing, below }

/// Optional compact action rendered by [SuperToastView].
@immutable
class SuperToastAction {
  const SuperToastAction({
    required this.label,
    required this.onPressed,
    this.dismissAfterAction = true,
    this.position = SuperToastActionPosition.trailing,
  });

  final String label;
  final VoidCallback onPressed;
  final bool dismissAfterAction;
  final SuperToastActionPosition position;
}
