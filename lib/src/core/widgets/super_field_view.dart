import 'package:flutter/material.dart';

import 'super_view_layout.dart';

/// Reusable layout for form fields or custom input content.
///
/// The view provides the common title, description, content, and action
/// hierarchy without imposing a modal surface. This keeps the exact same UI
/// reusable inside pages, cards, sheets, and `SuperFieldDialog`.
class SuperFieldView extends StatelessWidget {
  const SuperFieldView({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.actions = const <Widget>[],
    this.padding,
  });

  /// Form fields or any feature-specific input content.
  final Widget child;

  /// Optional heading displayed above [child].
  final String? title;

  /// Optional supporting copy displayed below [title].
  final String? description;

  /// Optional action widgets, typically [SuperButton] instances.
  final List<Widget> actions;

  /// Optional layout padding. Defaults to the active Super spacing scale.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SuperViewLayout(
      title: title,
      description: description,
      content: child,
      actions: actions,
      padding: padding,
    );
  }
}
