// ============================================================
// core/widgets/super_dialog.dart
// ------------------------------------------------------------
// The GeniusLink modal dialog: a surface card lifted on the overlay (popover)
// shadow, opened by a header (section-marker bar OR a tinted icon badge) with a
// Title-Case title + optional subtitle and a close affordance, a scrollable
// content body, and a right-aligned action row built from [SuperButton]s.
//
//   SuperDialog.show(context, builder: (ctx) => SuperDialog(
//     title: 'Post Journal Entry',
//     content: const Text('This will post the entry and mark it final.'),
//     actions: [
//       SuperButton(label: 'Cancel', variant: SuperButtonVariant.secondary,
//           onPressed: () => Navigator.of(ctx).pop()),
//       SuperButton(label: 'Post Entry', onPressed: () => Navigator.of(ctx).pop()),
//     ],
//   ));
//
//   final ok = await SuperDialog.confirm(context,
//       title: 'Delete Store', message: 'This cannot be undone.', danger: true);
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_text_styles.dart';
import '../theme/super_theme.dart';
import '../theme/super_tokens.dart';
import 'super_button.dart';

/// A GeniusLink-styled modal dialog surface.
///
/// Use the static [show] to present an arbitrary dialog, or the [confirm] /
/// [alert] convenience helpers for the common two-button / one-button cases.
class SuperDialog extends StatelessWidget {
  const SuperDialog({
    super.key,
    this.title,
    this.subtitle,
    this.marker = SuperMarker.identity,
    this.icon,
    this.iconColor,
    this.content,
    this.actions = const <Widget>[],
    this.width = 440,
    this.showClose = true,
    this.onClose,
  });

  /// Title-Case dialog title (rendered in the section-heading style).
  final String? title;

  /// Optional one-line subtitle beneath the title, in the tertiary text color.
  final String? subtitle;

  /// The section-marker bar intent shown beside the title when no [icon] is
  /// provided (identity / ledger / notes).
  final SuperMarker marker;

  /// Optional leading glyph. When set, a tinted rounded-square badge replaces
  /// the section-marker bar — ideal for confirm / alert dialogs.
  final IconData? icon;

  /// Tint + glyph color for the [icon] badge. Defaults to the primary accent.
  final Color? iconColor;

  /// The dialog body. Scrolls when it exceeds the available height. Inherits
  /// the body text style in the secondary text color.
  final Widget? content;

  /// Right-aligned footer actions, typically [SuperButton]s. Empty hides the
  /// footer.
  final List<Widget> actions;

  /// Maximum dialog width. The dialog never exceeds the viewport minus its
  /// inset margin.
  final double width;

  /// Whether to show the trailing close icon button in the header.
  final bool showClose;

  /// Invoked by the close button. Defaults to `Navigator.maybePop`.
  final VoidCallback? onClose;

  /// Presents [builder]'s dialog with the GeniusLink barrier scrim. Returns the
  /// value the dialog is popped with.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: builder,
    );
  }

  /// A confirm / cancel dialog. Resolves to `true` when confirmed, `false`
  /// otherwise. Set [danger] for destructive actions — the confirm button and
  /// icon badge turn semantic red.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool danger = false,
    IconData? icon,
  }) async {
    final result = await show<bool>(
      context,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        final tone = danger ? cs.error : cs.primary;
        return SuperDialog(
          title: title,
          icon: icon ?? (danger ? Icons.error_outline : Icons.help_outline),
          iconColor: tone,
          content: message == null ? null : Text(message),
          actions: [
            SuperButton(
              label: cancelLabel,
              variant: SuperButtonVariant.secondary,
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            _tonedButton(
              ctx,
              label: confirmLabel,
              color: tone,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// A single-button informational dialog. Set [icon] / [iconColor] to signal
  /// intent (e.g. `Icons.check_circle_outline` in success green).
  static Future<void> alert(
    BuildContext context, {
    required String title,
    String? message,
    String dismissLabel = 'OK',
    IconData? icon,
    Color? iconColor,
  }) {
    return show<void>(
      context,
      builder: (ctx) => SuperDialog(
        title: title,
        icon: icon,
        iconColor: iconColor,
        content: message == null ? null : Text(message),
        actions: [
          SuperButton(
            label: dismissLabel,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  // A primary SuperButton recolored to [color] by overriding the ambient
  // ColorScheme.primary for the button subtree only — reuses every SuperButton
  // hover/press state without duplicating its logic.
  static Widget _tonedButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: color,
          onPrimary: Colors.white,
        ),
      ),
      child: SuperButton(label: label, onPressed: onPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final hasHeader = title != null || icon != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(SuperTokens.space6),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Container(
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
            border: Border.all(color: t.border),
            boxShadow: SuperThemeData.popShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasHeader)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    SuperTokens.space6,
                    SuperTokens.space6,
                    SuperTokens.space6,
                    content != null || actions.isNotEmpty
                        ? 0.0
                        : SuperTokens.space6,
                  ),
                  child: _Header(
                    title: title,
                    subtitle: subtitle,
                    marker: marker,
                    icon: icon,
                    iconColor: iconColor,
                    showClose: showClose,
                    onClose: onClose,
                  ),
                ),
              if (content != null)
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      SuperTokens.space6,
                      hasHeader ? SuperTokens.space4 : SuperTokens.space6,
                      SuperTokens.space6,
                      actions.isNotEmpty ? 0.0 : SuperTokens.space6,
                    ),
                    child: DefaultTextStyle.merge(
                      style: SuperText.body.copyWith(color: t.fg2),
                      child: content!,
                    ),
                  ),
                ),
              if (actions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(SuperTokens.space6),
                  child: _ActionRow(actions: actions),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.marker,
    required this.icon,
    required this.iconColor,
    required this.showClose,
    required this.onClose,
  });

  final String? title;
  final String? subtitle;
  final SuperMarker marker;
  final IconData? icon;
  final Color? iconColor;
  final bool showClose;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final cs = Theme.of(context).colorScheme;
    final badgeColor = iconColor ?? cs.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            margin: const EdgeInsetsDirectional.only(end: SuperTokens.space3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(SuperTokens.radiusControl),
            ),
            child: Icon(icon, size: 20, color: badgeColor),
          )
        else
          Container(
            width: SuperTokens.markerWidth,
            height: SuperTokens.markerHeight,
            margin: const EdgeInsetsDirectional.only(
              top: 2,
              end: SuperTokens.space4,
            ),
            decoration: BoxDecoration(
              color: marker.color,
              borderRadius: BorderRadius.circular(SuperTokens.radiusPill),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != null)
                Text(title!, style: SuperText.heading.copyWith(color: t.fg1)),
              if (subtitle != null) ...[
                const SizedBox(height: SuperTokens.space1),
                Text(
                  subtitle!,
                  style: SuperText.caption.copyWith(color: t.fg3),
                ),
              ],
            ],
          ),
        ),
        if (showClose) ...[
          const SizedBox(width: SuperTokens.space2),
          SuperIconButton(
            icon: Icons.close,
            tooltip: 'Close',
            onPressed: onClose ?? () => Navigator.of(context).maybePop(),
          ),
        ],
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      if (i > 0) children.add(const SizedBox(width: SuperTokens.space3));
      children.add(actions[i]);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: children);
  }
}
