import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Internal shared layout used by the reusable Super view surfaces.
///
/// This deliberately contains no dialog presentation. Dialog wrappers compose
/// the public View widgets so inline and modal variants always share the same
/// hierarchy, typography, spacing, and action placement.
class SuperViewLayout extends StatelessWidget {
  const SuperViewLayout({
    super.key,
    this.title,
    this.description,
    this.leading,
    this.content,
    this.actions = const <Widget>[],
    this.padding,
  });

  final String? title;
  final String? description;
  final Widget? leading;
  final Widget? content;
  final List<Widget> actions;
  final EdgeInsetsGeometry? padding;

  bool get _hasHeader => title != null || description != null || leading != null;
  bool get _hasMainContent => _hasHeader || content != null;

  @override
  Widget build(BuildContext context) {
    final theme = context.superTheme;
    final spacing = theme.spacing;
    final resolvedPadding = padding ?? EdgeInsets.all(spacing.space6);
    final resolvedDirectionalPadding = resolvedPadding.resolve(
      Directionality.of(context),
    );
    final actionsPadding = EdgeInsets.fromLTRB(
      resolvedDirectionalPadding.left,
      spacing.space4,
      resolvedDirectionalPadding.right,
      spacing.space4,
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_hasMainContent)
            Padding(
              padding: resolvedPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_hasHeader)
                    _SuperViewHeader(
                      title: title,
                      description: description,
                      leading: leading,
                    ),
                  if (content != null) ...[
                    if (_hasHeader) SizedBox(height: spacing.space5),
                    DefaultTextStyle.merge(
                      style: theme.textTheme.body.copyWith(color: theme.fg2),
                      textAlign: TextAlign.start,
                      child: content!,
                    ),
                  ],
                ],
              ),
            ),
          if (actions.isNotEmpty)
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.bg,
                border: _hasMainContent
                    ? Border(top: BorderSide(color: theme.border))
                    : null,
              ),
              child: Padding(
                padding: actionsPadding,
                child: _SuperViewActions(actions: actions),
              ),
            ),
        ],
      ),
    );
  }
}

class _SuperViewHeader extends StatelessWidget {
  const _SuperViewHeader({
    required this.title,
    required this.description,
    required this.leading,
  });

  final String? title;
  final String? description;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = context.superTheme;
    final spacing = theme.spacing;
    final copy = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            textAlign: TextAlign.start,
            style: theme.textTheme.h1.copyWith(color: theme.fg1),
          ),
        if (description != null) ...[
          if (title != null) SizedBox(height: spacing.space2),
          Text(
            description!,
            textAlign: TextAlign.start,
            style: theme.textTheme.body.copyWith(color: theme.fg3),
          ),
        ],
      ],
    );

    if (leading == null) return copy;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leading!,
        SizedBox(width: spacing.space3),
        Expanded(child: copy),
      ],
    );
  }
}

class _SuperViewActions extends StatelessWidget {
  const _SuperViewActions({required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;

    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing.space2,
      runSpacing: spacing.space2,
      children: actions,
    );
  }
}
