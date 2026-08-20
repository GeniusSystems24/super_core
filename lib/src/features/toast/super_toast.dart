// ============================================================
// features/toast/super_toast.dart
// ------------------------------------------------------------
// Public convenience facade. Requires a SuperToastHost ancestor, mirroring the
// host-based lifecycle used by advanced toaster implementations while keeping
// Super Core's semantic tones and design-system surface.
// ============================================================

import 'package:flutter/material.dart';

import 'domain/entities/super_toast_data.dart';
import 'presentation/controllers/super_toast_controller.dart';
import 'presentation/models/super_toast_action.dart';
import 'presentation/models/super_toast_alignment.dart';
import 'presentation/models/super_toast_style.dart';
import 'presentation/views/super_toast_host.dart';
import 'presentation/views/super_toast_view.dart';

typedef SuperToastSuffixBuilder = Widget Function(
  BuildContext context,
  SuperToastHandle entry,
);

abstract final class SuperToast {
  /// Shared controller used by the default [SuperToastHost].
  static SuperToastController get controller => SuperToastController.shared;

  /// Returns the controller owned by the nearest host.
  static SuperToastController controllerOf(BuildContext context) =>
      SuperToastHost.of(context).controller;

  /// Shows the standard Super design-system toast surface.
  static SuperToastHandle show(
    BuildContext context, {
    required String title,
    String? description,
    SuperToastTone tone = SuperToastTone.neutral,
    SuperToastPosition position = SuperToastPosition.adaptive,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    Duration? duration = const Duration(seconds: 5),
    bool dismissible = false,
    bool showCloseButton = false,
    bool pauseOnHover = true,
    Widget? icon,
    SuperToastAction? action,
    SuperToastSuffixBuilder? suffixBuilder,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) {
    final host = SuperToastHost.of(context);
    final data = SuperToastData(
      title: title,
      description: description,
      tone: tone,
      position: position,
      duration: duration,
      dismissible: dismissible,
      showCloseButton: showCloseButton,
      pauseOnHover: pauseOnHover,
    );

    return host.controller.show(
      context,
      data,
      alignment: alignment,
      defaultAlignment: host.resolvedStyle.alignment,
      swipeToDismiss: swipeToDismiss,
      dismissThreshold: dismissThreshold,
      style: style,
      onDismiss: onDismiss,
      builder: (context, entry) => SuperToastView(
        data: data,
        handle: entry,
        style: style,
        icon: icon,
        action: action,
        suffix: suffixBuilder?.call(context, entry),
      ),
    );
  }

  /// Shows arbitrary toast content while retaining host positioning, stacking,
  /// timers, accessibility, animation, and swipe-to-dismiss behavior.
  static SuperToastHandle showRaw(
    BuildContext context, {
    required SuperToastData data,
    required SuperToastRawBuilder builder,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) {
    final host = SuperToastHost.of(context);
    return host.controller.show(
      context,
      data,
      builder: builder,
      alignment: alignment,
      defaultAlignment: host.resolvedStyle.alignment,
      swipeToDismiss: swipeToDismiss,
      dismissThreshold: dismissThreshold,
      style: style,
      onDismiss: onDismiss,
    );
  }

  static SuperToastHandle info(
    BuildContext context, {
    required String title,
    String? description,
    SuperToastPosition position = SuperToastPosition.adaptive,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    Duration? duration = const Duration(seconds: 5),
    bool dismissible = false,
    bool showCloseButton = false,
    bool pauseOnHover = true,
    Widget? icon,
    SuperToastAction? action,
    SuperToastSuffixBuilder? suffixBuilder,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) => _toned(
    context,
    tone: SuperToastTone.info,
    title: title,
    description: description,
    position: position,
    alignment: alignment,
    swipeToDismiss: swipeToDismiss,
    dismissThreshold: dismissThreshold,
    duration: duration,
    dismissible: dismissible,
    showCloseButton: showCloseButton,
    pauseOnHover: pauseOnHover,
    icon: icon,
    action: action,
    suffixBuilder: suffixBuilder,
    style: style,
    onDismiss: onDismiss,
  );

  static SuperToastHandle success(
    BuildContext context, {
    required String title,
    String? description,
    SuperToastPosition position = SuperToastPosition.adaptive,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    Duration? duration = const Duration(seconds: 5),
    bool dismissible = false,
    bool showCloseButton = false,
    bool pauseOnHover = true,
    Widget? icon,
    SuperToastAction? action,
    SuperToastSuffixBuilder? suffixBuilder,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) => _toned(
    context,
    tone: SuperToastTone.success,
    title: title,
    description: description,
    position: position,
    alignment: alignment,
    swipeToDismiss: swipeToDismiss,
    dismissThreshold: dismissThreshold,
    duration: duration,
    dismissible: dismissible,
    showCloseButton: showCloseButton,
    pauseOnHover: pauseOnHover,
    icon: icon,
    action: action,
    suffixBuilder: suffixBuilder,
    style: style,
    onDismiss: onDismiss,
  );

  static SuperToastHandle warning(
    BuildContext context, {
    required String title,
    String? description,
    SuperToastPosition position = SuperToastPosition.adaptive,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    Duration? duration = const Duration(seconds: 5),
    bool dismissible = false,
    bool showCloseButton = false,
    bool pauseOnHover = true,
    Widget? icon,
    SuperToastAction? action,
    SuperToastSuffixBuilder? suffixBuilder,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) => _toned(
    context,
    tone: SuperToastTone.warning,
    title: title,
    description: description,
    position: position,
    alignment: alignment,
    swipeToDismiss: swipeToDismiss,
    dismissThreshold: dismissThreshold,
    duration: duration,
    dismissible: dismissible,
    showCloseButton: showCloseButton,
    pauseOnHover: pauseOnHover,
    icon: icon,
    action: action,
    suffixBuilder: suffixBuilder,
    style: style,
    onDismiss: onDismiss,
  );

  static SuperToastHandle danger(
    BuildContext context, {
    required String title,
    String? description,
    SuperToastPosition position = SuperToastPosition.adaptive,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    Duration? duration = const Duration(seconds: 5),
    bool dismissible = false,
    bool showCloseButton = false,
    bool pauseOnHover = true,
    Widget? icon,
    SuperToastAction? action,
    SuperToastSuffixBuilder? suffixBuilder,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) => _toned(
    context,
    tone: SuperToastTone.danger,
    title: title,
    description: description,
    position: position,
    alignment: alignment,
    swipeToDismiss: swipeToDismiss,
    dismissThreshold: dismissThreshold,
    duration: duration,
    dismissible: dismissible,
    showCloseButton: showCloseButton,
    pauseOnHover: pauseOnHover,
    icon: icon,
    action: action,
    suffixBuilder: suffixBuilder,
    style: style,
    onDismiss: onDismiss,
  );

  static SuperToastHandle _toned(
    BuildContext context, {
    required SuperToastTone tone,
    required String title,
    String? description,
    required SuperToastPosition position,
    SuperToastAlignment? alignment,
    List<AxisDirection>? swipeToDismiss,
    required double dismissThreshold,
    Duration? duration,
    required bool dismissible,
    required bool showCloseButton,
    required bool pauseOnHover,
    Widget? icon,
    SuperToastAction? action,
    SuperToastSuffixBuilder? suffixBuilder,
    required SuperToastStyle style,
    VoidCallback? onDismiss,
  }) => show(
    context,
    title: title,
    description: description,
    tone: tone,
    position: position,
    alignment: alignment,
    swipeToDismiss: swipeToDismiss,
    dismissThreshold: dismissThreshold,
    duration: duration,
    dismissible: dismissible,
    showCloseButton: showCloseButton,
    pauseOnHover: pauseOnHover,
    icon: icon,
    action: action,
    suffixBuilder: suffixBuilder,
    style: style,
    onDismiss: onDismiss,
  );

  /// Dismisses all toasts in the nearest host when [context] is supplied, or
  /// all toasts in the shared controller otherwise.
  static void dismissAll([BuildContext? context]) {
    if (context == null) {
      controller.dismissAll();
    } else {
      SuperToastHost.of(context).controller.dismissAll();
    }
  }
}
