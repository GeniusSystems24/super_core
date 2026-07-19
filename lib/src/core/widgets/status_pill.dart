// ============================================================
// core/widgets/status_pill.dart
// ------------------------------------------------------------
// A semantic status pill: 12px radius, 8/4 padding, uppercase 10/700 text in a
// semantic color over a +20% tint of that color. Tones map to the brand
// semantic palette, resolved dynamically from the ambient [SuperTokensData].
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_semantic_colors.dart';
import '../theme/super_text_styles.dart';

/// The semantic intent of a [StatusPill].
enum PillTone { neutral, accent, info, success, warning, danger }

/// A small uppercase status pill.
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.tone = PillTone.neutral});

  final String label;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final sem = SuperSemanticColors.of(context);
    final color = switch (tone) {
      PillTone.neutral => sem.neutral,
      PillTone.accent => sem.accent,
      PillTone.info => sem.info,
      PillTone.success => sem.success,
      PillTone.warning => sem.warning,
      PillTone.danger => sem.danger,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: k.space2, vertical: k.space1),
      decoration: BoxDecoration(
        color: color.subtle,
        borderRadius: BorderRadius.circular(k.radiusPill),
      ),
      child: Text(label.toUpperCase(),
          style: SuperText.pill.copyWith(color: color.onSubtle)),
    );
  }
}
