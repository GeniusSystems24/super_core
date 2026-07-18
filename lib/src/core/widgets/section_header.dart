// ============================================================
// core/widgets/section_header.dart
// ------------------------------------------------------------
// The brand's signature device: a 4x40 colored pill bar + a heading (16/700)
// + a subtitle (12/400 in fg3), separated by 16px. The bar color encodes the
// section's intent (identity / ledger / notes) and is resolved dynamically from
// the ambient theme's [SuperTokensData].
// ============================================================

import 'package:flutter/widgets.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_text_styles.dart';
import '../theme/super_tokens.dart';

/// A section header — colored marker bar + title + optional subtitle.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.marker = SuperMarker.identity,
    this.trailing,
  });

  final String title;
  final String? subtitle;

  /// The marker-bar intent (blue / green / orange).
  final SuperMarker marker;

  /// Optional trailing widget (an action button, a count, a toggle).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section-marker bar.
        Container(
          width: k.markerWidth,
          height: subtitle == null ? 20 : k.markerHeight,
          margin: EdgeInsetsDirectional.only(top: 1, end: k.space4),
          decoration: BoxDecoration(
            color: marker.resolve(k),
            borderRadius: BorderRadius.circular(k.radiusPill),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: SuperText.heading.copyWith(color: t.fg1)),
              if (subtitle != null) ...[
                SizedBox(height: k.space1),
                Text(subtitle!, style: SuperText.caption.copyWith(color: t.fg3)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: k.space3),
          trailing!,
        ],
      ],
    );
  }
}
