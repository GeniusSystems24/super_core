import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'super_button.dart';
import 'super_view_layout.dart';

/// Reusable confirmation content for inline surfaces and dialogs.
///
/// [SuperConfirmView] owns the confirmation hierarchy and interactions. Use
/// `SuperConfirmDialog` when the same content needs modal presentation.
class SuperConfirmView extends StatelessWidget {
  const SuperConfirmView({
    super.key,
    required this.title,
    this.description,
    this.content,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.showCancel = true,
    this.icon,
    this.confirmIcon,
    this.cancelIcon,
    this.isDestructive = false,
    this.padding,
  });

  /// Primary confirmation heading.
  final String title;

  /// Supporting copy displayed beneath [title].
  final String? description;

  /// Optional summary, warning, or feature-specific content.
  final Widget? content;

  /// Label for the primary action.
  final String confirmLabel;

  /// Label for the secondary action.
  final String cancelLabel;

  /// Invoked when the primary action is pressed. Null disables the action.
  final VoidCallback? onConfirm;

  /// Invoked when the cancel action is pressed. Null disables the action when
  /// [showCancel] is true.
  final VoidCallback? onCancel;

  /// Whether the secondary cancel action is visible.
  final bool showCancel;

  /// Optional intent icon shown beside the title and description.
  final IconData? icon;

  /// Optional icon rendered inside the confirm button.
  final Widget? confirmIcon;

  /// Optional icon rendered inside the cancel button.
  final Widget? cancelIcon;

  /// Uses the theme's semantic error color for the intent icon and confirm
  /// action without changing any other design-system styling.
  final bool isDestructive;

  /// Optional layout padding. Defaults to the active Super spacing scale.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.superTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final intentColor = isDestructive ? colorScheme.error : colorScheme.primary;

    final actions = <Widget>[
      if (showCancel)
        SuperButton(
          label: cancelLabel,
          icon: cancelIcon,
          variant: SuperButtonVariant.secondary,
          onPressed: onCancel,
        ),
      _ConfirmButton(
        label: confirmLabel,
        icon: confirmIcon,
        onPressed: onConfirm,
        isDestructive: isDestructive,
      ),
    ];

    return SuperViewLayout(
      title: title,
      description: description,
      leading: icon == null
          ? null
          : Container(
              width: theme.sizing.iconButton,
              height: theme.sizing.iconButton,
              decoration: BoxDecoration(
                color: theme.tint(intentColor),
                borderRadius: BorderRadius.circular(theme.spacing.radiusMd),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: theme.sizing.icon, color: intentColor),
            ),
      content: content,
      actions: actions,
      padding: padding,
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isDestructive,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final button = SuperButton(label: label, icon: icon, onPressed: onPressed);
    if (!isDestructive) return button;

    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(primary: theme.colorScheme.error),
      ),
      child: button,
    );
  }
}
