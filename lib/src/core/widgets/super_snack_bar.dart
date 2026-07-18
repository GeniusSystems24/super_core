// ============================================================
// core/widgets/super_snack_bar.dart
// ------------------------------------------------------------
// GeniusLink toast helper. The design system's snackbar is a floating,
// 8px-radius dark surface with a semantic leading glyph and light text — the
// same in both themes. [SuperSnackBar] builds and shows one via the ambient
// [ScaffoldMessenger], with tone shortcuts (info / success / warning / danger).
//
//   SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');
//   SuperSnackBar.danger(context, 'Transfer failed — accounts out of balance.');
//   SuperSnackBar.show(context, 'Draft saved.',
//       actionLabel: 'View', onAction: () => open(draft));
// ============================================================

import 'package:flutter/material.dart';

import '../theme/super_text_styles.dart';
import '../theme/super_theme.dart';
import '../theme/super_tokens.dart';

/// The semantic intent of a [SuperSnackBar]. Drives the leading glyph and the
/// accent color of the icon + action label.
enum SuperSnackBarTone { info, success, warning, danger }

/// Shows and builds GeniusLink toasts. Never instantiated — call the statics.
abstract final class SuperSnackBar {
  /// Shows a toast with the given [tone] via the ambient [ScaffoldMessenger],
  /// replacing any visible toast first. Returns the messenger controller.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
    String message, {
    SuperSnackBarTone tone = SuperSnackBarTone.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    return messenger.showSnackBar(
      build(
        context,
        message,
        tone: tone,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      ),
    );
  }

  /// Shows a neutral / informational toast (primary accent).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      show(context, message,
          tone: SuperSnackBarTone.info,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Shows a success toast (ledger green).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      show(context, message,
          tone: SuperSnackBarTone.success,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Shows a warning toast (notes orange).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> warning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      show(context, message,
          tone: SuperSnackBarTone.warning,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Shows a danger toast (semantic red). Defaults to a longer 6s dwell so the
  /// error is readable.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> danger(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 6),
  }) =>
      show(context, message,
          tone: SuperSnackBarTone.danger,
          actionLabel: actionLabel,
          onAction: onAction,
          duration: duration);

  /// Builds the [SnackBar] without showing it — for passing to a custom
  /// [ScaffoldMessenger] call.
  static SnackBar build(
    BuildContext context,
    String message, {
    SuperSnackBarTone tone = SuperSnackBarTone.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final cs = Theme.of(context).colorScheme;
    final k = SuperThemeData.of(context).tokens;
    final color = _toneColor(tone, cs, k);
    // Snackbars are dark in both themes — keep the text near-white.
    const fg = Color(0xFFE2E2E9);

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(k.radiusCard),
      ),
      content: Row(
        children: [
          Icon(_toneIcon(tone), size: 20, color: color),
          SizedBox(width: k.space3),
          Expanded(
            child: Text(message, style: SuperText.body.copyWith(color: fg)),
          ),
        ],
      ),
      action: actionLabel == null
          ? null
          : SnackBarAction(
              label: actionLabel,
              textColor: color,
              onPressed: onAction ?? () {},
            ),
    );
  }

  static Color _toneColor(SuperSnackBarTone tone, ColorScheme cs, SuperTokensData k) =>
      switch (tone) {
        SuperSnackBarTone.info => cs.primary,
        SuperSnackBarTone.success => k.success,
        SuperSnackBarTone.warning => k.warning,
        SuperSnackBarTone.danger => cs.error,
      };

  static IconData _toneIcon(SuperSnackBarTone tone) => switch (tone) {
        SuperSnackBarTone.info => Icons.info_outline,
        SuperSnackBarTone.success => Icons.check_circle_outline,
        SuperSnackBarTone.warning => Icons.warning_amber_rounded,
        SuperSnackBarTone.danger => Icons.error_outline,
      };
}
