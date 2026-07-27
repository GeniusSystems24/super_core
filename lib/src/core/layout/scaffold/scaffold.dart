import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../breakpoints.dart';

/// Responsive page-frame wrapper for Super screens.
///
/// This is not a replacement for Flutter's [Scaffold]. It wraps page content
/// with GeniusLink/Super responsive horizontal margins, optional max width, and
/// optional background color.
class SuperScaffold extends StatelessWidget {
  const SuperScaffold({
    super.key,
    required this.child,
    this.maxWidth,
    this.backgroundColor,
    this.padding,
  });

  /// Page content.
  final Widget child;

  /// Optional maximum content width, centered when supplied.
  final double? maxWidth;

  /// Optional fill behind the framed content.
  final Color? backgroundColor;

  /// Explicit padding. Defaults to responsive horizontal margins and
  /// `space2` vertical padding.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final horizontalMargin = SuperBreakpoints.resolve<double>(
      context,
      mobile: t.spacing.space4,
      tablet: t.spacing.space6,
      desktop: t.spacing.space8,
      large: t.spacing.space12,
    );

    Widget content = Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: t.spacing.space2,
          ),
      child: child,
    );

    if (maxWidth != null) {
      content = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: content,
        ),
      );
    }

    final color = backgroundColor;
    if (color != null) {
      content = ColoredBox(color: color, child: content);
    }

    return content;
  }
}
