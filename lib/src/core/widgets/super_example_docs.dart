// Reusable documentation-layout widgets for Super package examples,
// component galleries, previews, and code samples.
// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import '../extensions/context_extensions.dart';
import '../layout/scaffold/scaffold.dart';
import '../theme/super_tokens.dart';
import 'super_app_bar.dart';

class SuperExampleDocsBadgeData {
  const SuperExampleDocsBadgeData({
    required this.icon,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final SuperMarker tone;
}

class SuperExampleDocsSectionData {
  const SuperExampleDocsSectionData({
    required this.label,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.children,
  });

  final String label;
  final String eyebrow;
  final String title;
  final String description;
  final List<Widget> children;
}

class SuperExampleDocsPage extends StatefulWidget {
  const SuperExampleDocsPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.sections,
    this.badges = const [],
    this.api = const [],
    this.actions = const [],
    this.footer,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<SuperExampleDocsBadgeData> badges;
  final List<String> api;
  final List<SuperExampleDocsSectionData> sections;
  final List<Widget> actions;
  final Widget? footer;

  @override
  State<SuperExampleDocsPage> createState() => _SuperExampleDocsPageState();
}

class _SuperExampleDocsPageState extends State<SuperExampleDocsPage> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _syncKeys();
  }

  @override
  void didUpdateWidget(covariant SuperExampleDocsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections.length != widget.sections.length) _syncKeys();
  }

  void _syncKeys() {
    _sectionKeys = List<GlobalKey>.generate(
      widget.sections.length,
      (_) => GlobalKey(),
    );
  }

  Future<void> _scrollTo(int index) async {
    if (index < 0 || index >= _sectionKeys.length) return;
    final target = _sectionKeys[index].currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Scaffold(
      appBar: SuperAppBar(
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        actions: widget.actions,
      ),
      body: SuperScaffold(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showRail = constraints.maxWidth >= 1120;
            final pagePadding = t.spacing.pagePadding;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsetsDirectional.only(
                          start: pagePadding.left,
                          end: showRail ? t.spacing.space4 : pagePadding.right,
                          top: pagePadding.top,
                          bottom: pagePadding.bottom,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 860),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _SuperDocsHero(
                                    title: widget.title,
                                    description: widget.description,
                                    badges: widget.badges,
                                    api: widget.api,
                                  ),
                                  SizedBox(height: t.spacing.space5),
                                  if (!showRail) ...[
                                    _SuperMobileToc(
                                      sections: widget.sections,
                                      onSelected: _scrollTo,
                                    ),
                                    SizedBox(height: t.spacing.space5),
                                  ],
                                  for (
                                    var i = 0;
                                    i < widget.sections.length;
                                    i++
                                  ) ...[
                                    _SuperDocsSection(
                                      key: _sectionKeys[i],
                                      data: widget.sections[i],
                                    ),
                                    if (i != widget.sections.length - 1)
                                      SizedBox(height: t.spacing.space8),
                                  ],
                                  if (widget.footer case final footer?) ...[
                                    SizedBox(height: t.spacing.space6),
                                    footer,
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showRail)
                  SizedBox(
                    width: 240,
                    child: _SuperDesktopToc(
                      sections: widget.sections,
                      onSelected: _scrollTo,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SuperDocsHero extends StatelessWidget {
  const _SuperDocsHero({
    required this.title,
    required this.description,
    required this.badges,
    required this.api,
  });

  final String title;
  final String description;
  final List<SuperExampleDocsBadgeData> badges;
  final List<String> api;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badges.isNotEmpty)
          Wrap(
            spacing: t.spacing.space2,
            runSpacing: t.spacing.space2,
            children: [for (final badge in badges) _SuperBadge(data: badge)],
          ),
        if (badges.isNotEmpty) SizedBox(height: t.spacing.space4),
        Text(
          title,
          style: text.displayLg.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w800,
            letterSpacing: context.isRtl ? null : -1,
          ),
        ),
        SizedBox(height: t.spacing.space2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            description,
            style: text.bodyLg.copyWith(color: t.fg3, height: 1.55),
          ),
        ),
        if (api.isNotEmpty) ...[
          SizedBox(height: t.spacing.space4),
          Wrap(
            spacing: t.spacing.space2,
            runSpacing: t.spacing.space2,
            children: [for (final item in api) _SuperApiPill(item)],
          ),
        ],
      ],
    );
  }
}

class _SuperDocsSection extends StatelessWidget {
  const _SuperDocsSection({super.key, required this.data});
  final SuperExampleDocsSectionData data;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          data.eyebrow.toUpperCase(),
          style: text.eyebrow.copyWith(
            color: t.tokens.accent,
            letterSpacing: context.isRtl ? 0 : 1.25,
          ),
        ),
        SizedBox(height: t.spacing.space1),
        Text(
          data.title,
          style: text.headlineSm.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: t.spacing.space2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            data.description,
            style: text.bodySm.copyWith(color: t.fg3, height: 1.55),
          ),
        ),
        SizedBox(height: t.spacing.space4),
        ..._superExampleSeparated(
          data.children,
          SizedBox(height: t.spacing.space4),
        ),
      ],
    );
  }
}

class SuperExampleDocsCard extends StatefulWidget {
  const SuperExampleDocsCard({
    super.key,
    required this.title,
    required this.description,
    required this.code,
    required this.preview,
    this.minPreviewHeight = 220,
    this.previewAlignment = Alignment.center,
  });

  final String title;
  final String description;
  final String code;
  final Widget preview;
  final double minPreviewHeight;
  final AlignmentGeometry previewAlignment;

  @override
  State<SuperExampleDocsCard> createState() => _SuperExampleDocsCardState();
}

enum _SuperExampleTab { preview, code }

class _SuperExampleDocsCardState extends State<SuperExampleDocsCard> {
  _SuperExampleTab _tab = _SuperExampleTab.preview;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: text.titleMd.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: t.spacing.space1),
        Text(
          widget.description,
          style: text.bodySm.copyWith(color: t.fg3, height: 1.45),
        ),
        SizedBox(height: t.spacing.space3),
        DecoratedBox(
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: t.border),
            borderRadius: t.spacing.cardBorderRadius,
            boxShadow: t.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: t.spacing.cardBorderRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SuperTabs(
                  selected: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
                Divider(height: 1, thickness: 1, color: t.border),
                AnimatedSwitcher(
                  duration: t.tokens.durBase,
                  switchInCurve: t.tokens.curveStandard,
                  switchOutCurve: t.tokens.curveStandard,
                  child: _tab == _SuperExampleTab.preview
                      ? ConstrainedBox(
                          key: const ValueKey('preview'),
                          constraints: BoxConstraints(
                            minHeight: widget.minPreviewHeight,
                          ),
                          child: Container(
                            width: double.infinity,
                            alignment: widget.previewAlignment,
                            padding: EdgeInsets.all(t.spacing.space5),
                            color: Color.alphaBlend(
                              t.tokens.accent.withValues(alpha: 0.018),
                              t.bg,
                            ),
                            child: widget.preview,
                          ),
                        )
                      : SuperExampleCodeBlock(
                          key: const ValueKey('code'),
                          code: widget.code,
                          embedded: true,
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SuperExamplePreviewColumn extends StatelessWidget {
  const SuperExamplePreviewColumn({
    super.key,
    required this.children,
    this.maxWidth = 520,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final List<Widget> children;
  final double maxWidth;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: _superExampleSeparated(
          children,
          SizedBox(height: context.superTheme.spacing.space3),
        ),
      ),
    );
  }
}

class SuperExampleCodeBlock extends StatelessWidget {
  const SuperExampleCodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.embedded = false,
    this.withLinesCount = true,
    this.withZoom = false,
    this.selectable = true,
    this.fontSize = 13,
    this.maxHeight = 520,
  }) : assert(maxHeight >= 76, 'maxHeight must be at least 76.');

  final String code;
  final String language;
  final bool embedded;

  /// Whether line numbers are shown by [SyntaxView].
  final bool withLinesCount;

  /// Whether the syntax-view zoom controls are shown.
  final bool withZoom;

  /// Whether the highlighted code can be selected.
  final bool selectable;

  /// Base font size used by [SyntaxView].
  final double fontSize;

  /// Maximum height of the highlighted code viewport.
  ///
  /// Long examples scroll inside the code block rather than increasing the
  /// documentation page height indefinitely.
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final lineCount = '\n'.allMatches(code).length + 1;
    final estimatedHeight = (lineCount * (fontSize * 1.55)) + 28;
    final viewportHeight = estimatedHeight
        .clamp(
          76.0,
          maxHeight,
        )
        .toDouble();

    final body = Container(
      width: double.infinity,
      color: Color.alphaBlend(t.fg1.withValues(alpha: 0.025), t.bg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              t.spacing.space4,
              t.spacing.space2,
              t.spacing.space2,
              t.spacing.space2,
            ),
            child: Row(
              children: [
                _SuperCodeLanguageBadge(language: language),
                const Spacer(),
                IconButton(
                  tooltip: 'Copy code',
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.content_copy_rounded,
                    size: 16,
                    color: t.fg3,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: t.border),
          SizedBox(
            height: viewportHeight,
            child: SyntaxView(
              code: code,
              syntax: _superSyntaxFromLanguage(language),
              syntaxTheme: _superSyntaxTheme(context),
              fontSize: fontSize,
              withZoom: withZoom,
              withLinesCount: withLinesCount,
              expanded: true,
              selectable: selectable,
            ),
          ),
        ],
      ),
    );

    if (embedded) return body;

    return ClipRRect(
      borderRadius: t.spacing.cardBorderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: t.border),
          borderRadius: t.spacing.cardBorderRadius,
        ),
        child: body,
      ),
    );
  }
}

class _SuperCodeLanguageBadge extends StatelessWidget {
  const _SuperCodeLanguageBadge({required this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space2,
        vertical: t.spacing.space1,
      ),
      decoration: BoxDecoration(
        color: t.selectionFill(0.08),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Text(
        language.toUpperCase(),
        style: context.superTextTheme.eyebrow.copyWith(
          color: t.fg3,
          letterSpacing: 0.75,
        ),
      ),
    );
  }
}

Syntax _superSyntaxFromLanguage(String language) {
  switch (language.trim().toLowerCase()) {
    case 'c':
      return Syntax.C;
    case 'c++':
    case 'cpp':
      return Syntax.CPP;
    case 'javascript':
    case 'js':
      return Syntax.JAVASCRIPT;
    case 'kotlin':
    case 'kt':
      return Syntax.KOTLIN;
    case 'java':
      return Syntax.JAVA;
    case 'swift':
      return Syntax.SWIFT;
    case 'yaml':
    case 'yml':
      return Syntax.YAML;
    case 'rust':
    case 'rs':
      return Syntax.RUST;
    case 'lua':
      return Syntax.LUA;
    case 'python':
    case 'py':
      return Syntax.PYTHON;
    case 'dart':
    default:
      return Syntax.DART;
  }
}

SyntaxTheme _superSyntaxTheme(BuildContext context) {
  final t = context.superTheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final base = isDark
      ? SyntaxTheme.vscodeDark()
      : SyntaxTheme.vscodeLight();

  final background = Color.alphaBlend(
    t.fg1.withValues(alpha: isDark ? 0.035 : 0.018),
    t.bg,
  );

  return base.copyWith(
    backgroundColor: background,
    linesCountColor: t.fg4,
    zoomIconColor: t.fg3,
  );
}

// SUPER_CODE_PREVIEW: flutter_syntax_view

class SuperExampleDocsNote extends StatelessWidget {
  const SuperExampleDocsNote({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Container(
      padding: EdgeInsets.all(t.spacing.space4),
      decoration: BoxDecoration(
        color: t.selectionFill(0.08),
        border: Border.all(color: t.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: t.tokens.accent),
          SizedBox(width: t.spacing.space3),
          Expanded(
            child: Text(
              text,
              style: context.superTextTheme.bodySm.copyWith(
                color: t.fg3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuperTabs extends StatelessWidget {
  const _SuperTabs({required this.selected, required this.onChanged});

  final _SuperExampleTab selected;
  final ValueChanged<_SuperExampleTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: t.spacing.space2,
        end: t.spacing.space2,
        top: t.spacing.space1,
      ),
      child: Row(
        children: [
          _SuperTabButton(
            label: 'Preview',
            selected: selected == _SuperExampleTab.preview,
            onTap: () => onChanged(_SuperExampleTab.preview),
          ),
          _SuperTabButton(
            label: 'Code',
            selected: selected == _SuperExampleTab.code,
            onTap: () => onChanged(_SuperExampleTab.code),
          ),
        ],
      ),
    );
  }
}

class _SuperTabButton extends StatelessWidget {
  const _SuperTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: t.spacing.pillBorderRadius,
      child: AnimatedContainer(
        duration: t.tokens.durFast,
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.space3,
          vertical: t.spacing.space2,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? t.tokens.accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: context.superTextTheme.labelSm.copyWith(
            color: selected ? t.fg1 : t.fg3,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SuperDesktopToc extends StatelessWidget {
  const _SuperDesktopToc({required this.sections, required this.onSelected});

  final List<SuperExampleDocsSectionData> sections;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: BorderDirectional(start: BorderSide(color: t.border)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(
          t.spacing.space4,
          t.spacing.space6,
          t.spacing.space4,
          t.spacing.space6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On this page',
              style: context.superTextTheme.labelMd.copyWith(
                color: t.fg1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: t.spacing.space3),
            for (var i = 0; i < sections.length; i++)
              _SuperTocButton(
                label: sections[i].label,
                onTap: () => onSelected(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuperMobileToc extends StatelessWidget {
  const _SuperMobileToc({required this.sections, required this.onSelected});

  final List<SuperExampleDocsSectionData> sections;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On this page',
              style: context.superTextTheme.labelMd.copyWith(
                color: t.fg1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: t.spacing.space2),
            Wrap(
              spacing: t.spacing.space1,
              runSpacing: t.spacing.space1,
              children: [
                for (var i = 0; i < sections.length; i++)
                  ActionChip(
                    label: Text(sections[i].label),
                    onPressed: () => onSelected(i),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SuperTocButton extends StatelessWidget {
  const _SuperTocButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: t.spacing.pillBorderRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.space2,
          vertical: t.spacing.space2,
        ),
        child: Text(
          label,
          style: context.superTextTheme.bodySm.copyWith(color: t.fg3),
        ),
      ),
    );
  }
}

class _SuperBadge extends StatelessWidget {
  const _SuperBadge({required this.data});
  final SuperExampleDocsBadgeData data;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final color = t.tokens.markerColor(data.tone);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space2,
        vertical: t.spacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.20)),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 14, color: color),
          SizedBox(width: t.spacing.space1),
          Text(
            data.label,
            style: context.superTextTheme.labelSm.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuperApiPill extends StatelessWidget {
  const _SuperApiPill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space2,
        vertical: t.spacing.space1,
      ),
      decoration: BoxDecoration(
        color: t.selectionFill(0.12),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Text(
        label,
        style: context.superTextTheme.labelSm.copyWith(
          color: t.fg2,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

List<Widget> _superExampleSeparated(List<Widget> children, Widget separator) {
  if (children.length < 2) return children;
  return [
    for (var i = 0; i < children.length; i++) ...[
      children[i],
      if (i != children.length - 1) separator,
    ],
  ];
}
