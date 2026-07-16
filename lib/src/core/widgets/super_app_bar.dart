// ============================================================
// core/widgets/super_app_bar.dart
// ------------------------------------------------------------
// The GeniusLink app bar. A flat, hairline-bottomed bar carrying an optional
// ALL-CAPS breadcrumb eyebrow above a Title-Case page title (with room for an
// inline translation / status trailing the title), plus leading + action
// slots and an optional bottom (e.g. a TabBar). Implements
// [PreferredSizeWidget] so it drops straight into `Scaffold.appBar`.
//
//   Scaffold(
//     appBar: SuperAppBar(
//       eyebrow: 'Stores & Products • Stores',
//       title: 'Create Store',
//       actions: [SuperIconButton(icon: Icons.help_outline, onPressed: () {})],
//     ),
//   );
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_text_styles.dart';
import '../theme/super_tokens.dart';

/// A GeniusLink-styled [AppBar] with an optional breadcrumb eyebrow.
class SuperAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SuperAppBar({
    super.key,
    required this.title,
    this.eyebrow,
    this.titleTrailing,
    this.leading,
    this.actions = const <Widget>[],
    this.bottom,
    this.centerTitle = false,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  /// Title-Case page title.
  final String title;

  /// Optional breadcrumb / eyebrow shown above the title (rendered ALL CAPS
  /// with wide tracking). Separate segments with the bullet `•`.
  final String? eyebrow;

  /// Optional widget trailing the title on the same line — e.g. an inline
  /// Arabic translation in tertiary text, or a [StatusPill].
  final Widget? titleTrailing;

  /// Optional leading widget. When null, the back button is implied per
  /// [automaticallyImplyLeading].
  final Widget? leading;

  /// Trailing action widgets, typically [SuperIconButton]s.
  final List<Widget> actions;

  /// Optional bar bottom (e.g. a `TabBar`). Its height is added to
  /// [preferredSize].
  final PreferredSizeWidget? bottom;

  /// Whether the title is centered. GeniusLink app bars are left-aligned by
  /// default.
  final bool centerTitle;

  /// Bar background. Defaults to the page background in dark mode and the card
  /// surface in light mode (matching the generated `AppBarTheme`).
  final Color? backgroundColor;

  /// Whether to imply a leading back button when [leading] is null.
  final bool automaticallyImplyLeading;

  double get _toolbarHeight => eyebrow == null ? kToolbarHeight : 68;

  @override
  Size get preferredSize =>
      Size.fromHeight(_toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final theme = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? t.bg : t.surface);
    final titleStyle =
        (theme.textTheme.titleLarge ?? SuperText.heading).copyWith(color: t.fg1);

    final titleColumn = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!.toUpperCase(),
            style: SuperText.eyebrow.copyWith(color: t.fg3),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: SuperTokens.space1),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (titleTrailing != null) ...[
              const SizedBox(width: SuperTokens.space2),
              titleTrailing!,
            ],
          ],
        ),
      ],
    );

    return AppBar(
      backgroundColor: bg,
      foregroundColor: t.fg1,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: isDark ? 1 : 2,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      centerTitle: centerTitle,
      toolbarHeight: _toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: titleColumn,
      iconTheme: IconThemeData(color: t.fg1, size: 20),
      actionsIconTheme: IconThemeData(color: t.fg2, size: 20),
      actions: [
        ...actions,
        if (actions.isNotEmpty) const SizedBox(width: SuperTokens.space2),
      ],
      bottom: bottom,
      shape: Border(bottom: BorderSide(color: t.border, width: 1)),
    );
  }
}
