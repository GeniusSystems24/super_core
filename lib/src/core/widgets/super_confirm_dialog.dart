import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'super_confirm_view.dart';

/// Modal presentation for [SuperConfirmView].
///
/// The dialog is intentionally thin: modal presentation and navigation results
/// live here, while all confirmation UI stays in [SuperConfirmView].
class SuperConfirmDialog extends StatelessWidget {
  const SuperConfirmDialog({
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
    this.confirmEnabled = true,
    this.maxWidth,
  });

  final String title;
  final String? description;
  final Widget? content;
  final String confirmLabel;
  final String cancelLabel;

  /// Optional side effect invoked before the dialog returns `true`.
  final VoidCallback? onConfirm;

  /// Optional side effect invoked before the dialog returns `false`.
  final VoidCallback? onCancel;

  final bool showCancel;
  final IconData? icon;
  final Widget? confirmIcon;
  final Widget? cancelIcon;
  final bool isDestructive;

  /// Whether the confirm action is enabled.
  final bool confirmEnabled;

  /// Maximum dialog content width before viewport insets are applied.
  final double? maxWidth;

  /// Presents a confirmation dialog and resolves to `true` only when the user
  /// confirms. Barrier dismissal and cancel both resolve to `false`.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    String? description,
    Widget? content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
    IconData? icon,
    Widget? confirmIcon,
    Widget? cancelIcon,
    bool isDestructive = false,
    bool confirmEnabled = true,
    double? maxWidth,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => SuperConfirmDialog(
        title: title,
        description: description,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCancel: showCancel,
        icon: icon,
        confirmIcon: confirmIcon,
        cancelIcon: cancelIcon,
        isDestructive: isDestructive,
        confirmEnabled: confirmEnabled,
        maxWidth: maxWidth,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedMaxWidth = maxWidth ?? context.superTheme.sizing.contentColumn;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: resolvedMaxWidth,
        child: SingleChildScrollView(
          child: SuperConfirmView(
            title: title,
            description: description,
            content: content,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            onConfirm: confirmEnabled
                ? () {
                    onConfirm?.call();
                    Navigator.of(context).pop(true);
                  }
                : null,
            onCancel: showCancel
                ? () {
                    onCancel?.call();
                    Navigator.of(context).pop(false);
                  }
                : null,
            showCancel: showCancel,
            icon: icon,
            confirmIcon: confirmIcon,
            cancelIcon: cancelIcon,
            isDestructive: isDestructive,
          ),
        ),
      ),
    );
  }
}
