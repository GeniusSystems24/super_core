import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'super_field_view.dart';

/// Modal presentation for [SuperFieldView].
///
/// Field layout and actions remain owned by [SuperFieldView]; this component
/// only supplies the Material dialog surface, viewport constraints, and modal
/// lifecycle.
class SuperFieldDialog extends StatelessWidget {
  const SuperFieldDialog({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.actions = const <Widget>[],
    this.maxWidth,
  });

  final Widget child;
  final String? title;
  final String? description;
  final List<Widget> actions;

  /// Maximum dialog content width before viewport insets are applied.
  final double? maxWidth;

  /// Presents [SuperFieldDialog] and returns the value supplied to
  /// `Navigator.pop` by one of the provided actions or the content itself.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? description,
    List<Widget> actions = const <Widget>[],
    double? maxWidth,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => SuperFieldDialog(
        title: title,
        description: description,
        actions: actions,
        maxWidth: maxWidth,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedMaxWidth = maxWidth ?? context.superTheme.sizing.contentColumn;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: resolvedMaxWidth,
        child: SingleChildScrollView(
          child: SuperFieldView(
            title: title,
            description: description,
            actions: actions,
            child: child,
          ),
        ),
      ),
    );
  }
}
