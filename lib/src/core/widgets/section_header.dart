// ============================================================
// core/widgets/section_header.dart
// ------------------------------------------------------------
// The brand's signature device: an optional icon container + a 4px colored
// pill bar + a title (Manrope, responsive size) + an optional subtitle (small
// caps). The bar color encodes the section's intent and is resolved from the
// ambient [SuperTokensData] via [SuperMarker], or overridden directly with
// [accentColor].
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_tokens.dart';

/// A section header — optional icon container + colored marker bar + title
/// + optional subtitle.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.marker = SuperMarker.identity,
    this.accentColor,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;

  /// The marker-bar intent (blue / green / orange). Ignored when [accentColor]
  /// is set.
  final SuperMarker marker;

  /// Explicit accent color for the marker bar and icon container. When set,
  /// takes precedence over [marker].
  final Color? accentColor;

  /// Optional icon displayed to the start of the marker bar in a tinted
  /// container. The container height matches the bar height.
  final IconData? icon;

  /// Optional trailing widget (an action button, a count, a toggle).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final color = accentColor ?? marker.resolve(k);
    final barHeight = subtitle == null ? 18.0 : k.markerHeight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Optional icon container — flush against the marker bar.
        if (icon != null)
          Container(
            width: 24,
            height: barHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(2),
              ),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
        // 4px marker bar.
        Container(
          width: k.markerWidth,
          height: barHeight,
          margin: EdgeInsetsDirectional.only(
            top: 1,
            end: k.space3,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(k.radiusPill),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t.textTheme.titleMd.copyWith(color: t.fg1),
              ),
              if (subtitle != null) ...[
                SizedBox(height: k.space1),
                Text(
                  subtitle!.toUpperCase(),
                  style: t.textTheme.labelSm.copyWith(
                    color: t.fg3,
                    letterSpacing: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
