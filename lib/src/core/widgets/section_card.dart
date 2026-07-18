// ============================================================
// core/widgets/section_card.dart
// ------------------------------------------------------------
// The fundamental layout unit: an 8px-radius card with a hairline border and
// the theme's card shadow, 24px padding, an optional SectionHeader, and a 32px
// gap before its body. Cards stack with 32px between them. Spacing / radius are
// resolved dynamically from the ambient theme's [SuperTokensData].
// ============================================================

import 'package:flutter/widgets.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_tokens.dart';
import 'section_header.dart';

/// A section card. Provide a [header] (or [title]/[subtitle]/[marker]) and the
/// [child] body; the card supplies surface, border, shadow and padding.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.header,
    this.title,
    this.subtitle,
    this.marker = SuperMarker.identity,
    this.headerTrailing,
    required this.child,
    this.padding,
  });

  /// A pre-built header. If null and [title] is set, one is built for you.
  final Widget? header;
  final String? title;
  final String? subtitle;
  final SuperMarker marker;
  final Widget? headerTrailing;
  final Widget child;

  /// Interior padding. Defaults to `24 24 24 40` (the GeniusLink card interior)
  /// resolved from the theme tokens when null.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final resolvedHeader = header ??
        (title != null
            ? SectionHeader(
                title: title!,
                subtitle: subtitle,
                marker: marker,
                trailing: headerTrailing,
              )
            : null);

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(k.radiusCard),
        border: Border.all(color: t.border),
        boxShadow: t.cardShadow,
      ),
      padding: padding ??
          EdgeInsets.fromLTRB(k.space6, k.space6, k.space6, k.space10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (resolvedHeader != null) ...[
            resolvedHeader,
            SizedBox(height: k.space8),
          ],
          child,
        ],
      ),
    );
  }
}
