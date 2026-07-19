// ============================================================
// core/widgets/super_section_footer.dart
// ------------------------------------------------------------
// SuperSectionFooter — the GeniusLink footer row: a hairline top rule then a
// flat line of ALL-CAPS micro-copy — brand / status string on the leading edge,
// action links on the trailing edge, all 11/700 in fg4. No emoji, no icons;
// links wrap onto a new line on narrow widths.
// ============================================================

import 'package:flutter/widgets.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_section_theme.dart';
import '../theme/super_text_styles.dart';
import 'hairline.dart';

/// A single ALL-CAPS footer action link.
class SuperFooterLink extends StatelessWidget {
  const SuperFooterLink(this.label, {super.key, this.onTap, this.emphasized = false});

  final String label;
  final VoidCallback? onTap;

  /// Render in the accent color instead of the muted fg4.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final th = SuperSectionFooterThemeData.of(context);
    final color = emphasized ? (th.emphasizedColor ?? t.tokens.accent) : t.fg4;
    final base = th.linkStyle ?? SuperText.label;
    final text = Text(label.toUpperCase(),
        style: base.copyWith(
            color: color, letterSpacing: th.letterSpacing ?? 1.1));
    if (onTap == null) return text;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: text,
    );
  }
}

/// A footer row — brand / status micro-copy on the leading edge and a set of
/// action links on the trailing edge, separated by a hairline rule.
class SuperSectionFooter extends StatelessWidget {
  const SuperSectionFooter({
    super.key,
    required this.brand,
    this.actions = const [],
    this.showDivider,
  });

  /// Leading ALL-CAPS brand / status string (e.g.
  /// `© 2024 GENIUSLINK ERP • SYSTEM STATUS: OPERATIONAL`). Upper-cased here.
  final String brand;

  /// Trailing action links — typically [SuperFooterLink]s.
  final List<Widget> actions;

  /// Whether to draw the hairline rule above the row. Falls back to the theme
  /// (default true).
  final bool? showDivider;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final th = SuperSectionFooterThemeData.of(context);
    final divider = showDivider ?? th.showDivider ?? true;
    final brandStyle = (th.brandStyle ?? SuperText.label)
        .copyWith(color: t.fg4, letterSpacing: th.letterSpacing ?? 1.1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (divider) const Hairline(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: th.verticalPadding ?? k.space4),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: th.runSpacing ?? k.space3,
            spacing: th.spacing ?? k.space6,
            children: [
              Text(brand.toUpperCase(), style: brandStyle),
              if (actions.isNotEmpty)
                Wrap(
                    spacing: th.spacing ?? k.space6,
                    runSpacing: k.space2,
                    children: actions),
            ],
          ),
        ),
      ],
    );
  }
}
