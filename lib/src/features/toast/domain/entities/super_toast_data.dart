// ============================================================
// features/toast/domain/entities/super_toast_data.dart
// ------------------------------------------------------------
// Immutable domain state for SuperToast. Presentation details such as widget
// builders, swipe gestures, animation controllers, and layout stay outside the
// domain layer.
// ============================================================

import 'package:flutter/foundation.dart';

/// Semantic intent used by the Super design system to style a toast.
enum SuperToastTone { neutral, info, success, warning, danger }

/// Named viewport positions supported by [SuperToast].
///
/// Directional positions resolve against the text direction captured when the
/// toast is shown. [adaptive] resolves to top-center on touch layouts and
/// bottom-end on desktop layouts.
enum SuperToastPosition {
  adaptive,
  topStart,
  topCenter,
  topEnd,
  topLeft,
  topRight,
  bottomStart,
  bottomCenter,
  bottomEnd,
  bottomLeft,
  bottomRight;

  /// Backwards-compatible alias for the original centered top position.
  @Deprecated('Use SuperToastPosition.topCenter instead.')
  static const SuperToastPosition top = SuperToastPosition.topCenter;

  /// Backwards-compatible alias for the original centered bottom position.
  @Deprecated('Use SuperToastPosition.bottomCenter instead.')
  static const SuperToastPosition bottom = SuperToastPosition.bottomCenter;
}

/// Immutable data model for one design-system toast.
@immutable
class SuperToastData {
  const SuperToastData({
    required this.title,
    this.description,
    this.tone = SuperToastTone.neutral,
    this.position = SuperToastPosition.adaptive,
    this.duration = const Duration(seconds: 5),
    this.dismissible = false,
    this.showCloseButton = false,
    this.pauseOnHover = true,
  });

  /// Primary label used by the standard toast surface and semantics.
  final String title;

  /// Optional supporting copy.
  final String? description;

  /// Semantic appearance.
  final SuperToastTone tone;

  /// Named viewport position. A custom presentation alignment may override it.
  final SuperToastPosition position;

  /// How long the toast stays visible before auto-dismissal.
  ///
  /// `null` disables auto-dismissal, matching the reference toaster behavior.
  /// [Duration.zero] is also accepted as a backwards-compatible persistent
  /// value. Accessible navigation always disables auto-dismissal.
  final Duration? duration;

  /// Whether tapping the standard toast body dismisses it.
  ///
  /// This is disabled by default so tapping a collapsed stack can be used to
  /// expand/collapse it on touch devices.
  final bool dismissible;

  /// Whether the standard toast surface includes a close affordance.
  final bool showCloseButton;

  /// Whether pointer/press stack interaction is allowed to suspend this
  /// toast's auto-dismiss timer.
  final bool pauseOnHover;

  SuperToastData copyWith({
    String? title,
    Object? description = _unset,
    SuperToastTone? tone,
    SuperToastPosition? position,
    Object? duration = _unset,
    bool? dismissible,
    bool? showCloseButton,
    bool? pauseOnHover,
  }) => SuperToastData(
    title: title ?? this.title,
    description: identical(description, _unset)
        ? this.description
        : description as String?,
    tone: tone ?? this.tone,
    position: position ?? this.position,
    duration: identical(duration, _unset) ? this.duration : duration as Duration?,
    dismissible: dismissible ?? this.dismissible,
    showCloseButton: showCloseButton ?? this.showCloseButton,
    pauseOnHover: pauseOnHover ?? this.pauseOnHover,
  );
}

const Object _unset = Object();
