// ============================================================
// core/widgets/accent_section_card.dart
// ------------------------------------------------------------
// A section card with a vertical 3px accent bar on the leading edge and a
// tinted header strip above the body. Useful for categorised panels where the
// bar color encodes intent (ledger / notes / identity / custom).
//
//   AccentSectionCard(
//     title: 'Payment Summary',
//     icon: Icons.receipt_long_outlined,
//     accentColor: t.tokens.success,
//     child: PaymentTable(),
//   );
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// A card with a leading accent bar and a distinct tinted header area.
///
/// The accent bar is 3px wide and spans the full card height. When [title] is
/// supplied, a header row is rendered above the body with a background derived
/// from the theme's surface container levels. The header text is rendered in
/// small-caps style (upper-cased for non-Arabic locales).
class AccentSectionCard extends StatelessWidget {
  const AccentSectionCard({
    super.key,
    this.title,
    this.icon,
    this.trailing,
    this.accentColor,
    required this.child,
    this.bodyPadding,
    this.headerPadding,
    this.backgroundColor,
  });

  final String? title;

  /// Optional icon displayed to the start of the title text.
  final IconData? icon;

  /// Optional trailing widget shown at the end of the header row.
  final Widget? trailing;

  /// Accent bar and header text color. Defaults to the theme's primary accent
  /// ([SuperTokensData.accent]).
  final Color? accentColor;

  final Widget child;

  /// Padding applied to [child]. Defaults to `EdgeInsets.all(tokens.space4)`.
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding applied to the header row. Defaults to symmetric
  /// `horizontal: space4, vertical: space3`.
  final EdgeInsetsGeometry? headerPadding;

  /// Card fill color. Defaults to `colorScheme.surfaceContainerLow`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final cs = Theme.of(context).colorScheme;
    final isDark = t.brightness == Brightness.dark;

    final accent = accentColor ?? k.accent;
    final bg = backgroundColor ?? cs.surfaceContainerLow;

    // Header background — a tinted version of the elevated surface containers.
    final headerBg = isDark
        ? cs.surfaceContainerHigh.withValues(alpha: 0.72)
        : cs.surfaceContainerHighest.withValues(alpha: 0.84);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(k.radiusCard),
        boxShadow: t.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(k.radiusCard),
        child: Stack(
          children: [
            // 3px accent bar spanning full height.
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 3, color: accent),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null)
                    Container(
                      color: headerBg,
                      padding: headerPadding ??
                          EdgeInsets.symmetric(
                            horizontal: k.space4,
                            vertical: k.space3,
                          ),
                      child: Row(
                        children: [
                          if (icon != null) ...[
                            Icon(icon, size: 16, color: accent),
                            SizedBox(width: k.space2),
                          ],
                          Expanded(
                            child: Text(
                              _caps(context, title!),
                              style: t.textTheme.labelMd.copyWith(
                                color: accent,
                                letterSpacing: 0.9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (trailing != null) ...[
                            SizedBox(width: k.space2),
                            trailing!,
                          ],
                        ],
                      ),
                    ),
                  Padding(
                    padding: bodyPadding ?? EdgeInsets.all(k.space4),
                    child: child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _caps(BuildContext context, String text) {
    if (Localizations.localeOf(context).languageCode == 'ar') return text;
    return text.toUpperCase();
  }
}
