import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'dialog_views_example_screen.dart';
import 'layout_components_screen.dart';
import 'section_example_screen.dart';
import 'super_widgets_gallery.dart';
import 'theme_demo_screen.dart';
import 'toast_example_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.selectedPalette,
    required this.themeMode,
    required this.locale,
    required this.onPaletteChanged,
    required this.onThemeModeChanged,
    required this.onLocaleChanged,
  });

  final SuperPalette selectedPalette;
  final ThemeMode themeMode;
  final Locale locale;
  final ValueChanged<SuperPalette> onPaletteChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final copy = _HomeCopy(locale.languageCode == 'ar');
    final destinations = _destinations(copy);

    void open(_ExampleDestination destination) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: destination.builder),
      );
    }

    return Scaffold(
      appBar: SuperAppBar(
        title: Text(copy.appTitle),
        subtitle: Text(copy.appSubtitle),
        actions: [
          ChangeLanguageButton(
            locale: locale,
            onChanged: onLocaleChanged,
          ),
          ChangeThemeButton(
            themeMode: themeMode,
            onChanged: onThemeModeChanged,
            isArabic: copy.isArabic,
          ),
        ],
      ),
      body: SuperScaffold(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: t.spacing.pagePadding,
                child: _HeroPanel(
                  copy: copy,
                  selectedPalette: selectedPalette,
                  themeMode: themeMode,
                  locale: locale,
                  onExploreToast: () => open(destinations.first),
                  onOpenTheme: () => open(destinations[1]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: t.spacing.pagePadding.left,
                  end: t.spacing.pagePadding.right,
                  bottom: t.spacing.space4,
                ),
                child: _SectionHeading(
                  eyebrow: copy.exploreEyebrow,
                  title: copy.exploreTitle,
                  description: copy.exploreDescription,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: t.spacing.pagePadding.left,
                  end: t.spacing.pagePadding.right,
                  bottom: t.spacing.pagePadding.bottom,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final gap = t.spacing.space3;
                    final columns = constraints.maxWidth >= 1080
                        ? 3
                        : constraints.maxWidth >= 680
                        ? 2
                        : 1;
                    final cardWidth =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;

                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final destination in destinations)
                          SizedBox(
                            width: cardWidth,
                            child: _DestinationCard(
                              destination: destination,
                              onTap: () => open(destination),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: t.spacing.pagePadding.left,
                  end: t.spacing.pagePadding.right,
                  bottom: t.spacing.pagePadding.bottom,
                ),
                child: _FooterNote(copy: copy),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_ExampleDestination> _destinations(_HomeCopy copy) => [
    _ExampleDestination(
      title: copy.toastTitle,
      description: copy.toastDescription,
      category: copy.feedbackCategory,
      icon: Icons.notifications_active_outlined,
      marker: SuperMarker.identity,
      featured: true,
      builder: (_) => const ToastExampleScreen(),
    ),
    _ExampleDestination(
      title: copy.themeTitle,
      description: copy.themeDescription,
      category: copy.foundationCategory,
      icon: Icons.palette_outlined,
      marker: SuperMarker.identity,
      builder: (_) => ThemeDemoScreen(
        selectedPalette: selectedPalette,
        themeMode: themeMode,
        onPaletteChanged: onPaletteChanged,
        onThemeModeChanged: onThemeModeChanged,
      ),
    ),
    _ExampleDestination(
      title: copy.galleryTitle,
      description: copy.galleryDescription,
      category: copy.componentsCategory,
      icon: Icons.widgets_outlined,
      marker: SuperMarker.ledger,
      builder: (_) => const SuperWidgetsGallery(),
    ),
    _ExampleDestination(
      title: copy.layoutTitle,
      description: copy.layoutDescription,
      category: copy.layoutCategory,
      icon: Icons.dashboard_customize_outlined,
      marker: SuperMarker.ledger,
      builder: (_) => const LayoutComponentsScreen(),
    ),
    _ExampleDestination(
      title: copy.sectionTitle,
      description: copy.sectionDescription,
      category: copy.componentsCategory,
      icon: Icons.view_agenda_outlined,
      marker: SuperMarker.notes,
      builder: (_) => const SectionExampleScreen(),
    ),
    _ExampleDestination(
      title: copy.dialogTitle,
      description: copy.dialogDescription,
      category: copy.patternsCategory,
      icon: Icons.open_in_new_outlined,
      marker: SuperMarker.notes,
      builder: (_) => const DialogViewsExampleScreen(),
    ),
  ];
}

/// Compact app-level theme switch used by the example shell.
class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({
    super.key,
    required this.themeMode,
    required this.onChanged,
    this.isArabic = false,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final tooltip = isArabic
        ? (isDark ? 'استخدام المظهر الفاتح' : 'استخدام المظهر الداكن')
        : (isDark ? 'Use light theme' : 'Use dark theme');

    return SuperIconButton(
      icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      tooltip: tooltip,
      onPressed: () => onChanged(nextMode),
    );
  }
}

/// Toggles the example application between English and Arabic.
class ChangeLanguageButton extends StatelessWidget {
  const ChangeLanguageButton({
    super.key,
    required this.locale,
    required this.onChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final isArabic = locale.languageCode == 'ar';
    final next = Locale(isArabic ? 'en' : 'ar');

    return Tooltip(
      message: isArabic ? 'Switch to English' : 'التبديل إلى العربية',
      child: SuperButton(
        label: isArabic ? 'EN' : 'AR',
        variant: SuperButtonVariant.secondary,
        icon: const Icon(Icons.language_rounded),
        onPressed: () => onChanged(next),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.copy,
    required this.selectedPalette,
    required this.themeMode,
    required this.locale,
    required this.onExploreToast,
    required this.onOpenTheme,
  });

  final _HomeCopy copy;
  final SuperPalette selectedPalette;
  final ThemeMode themeMode;
  final Locale locale;
  final VoidCallback onExploreToast;
  final VoidCallback onOpenTheme;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return ClipRRect(
      borderRadius: t.spacing.cardBorderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              t.selectionFill(0.24),
              t.surface,
              t.tint(t.tokens.info, 0.08),
            ],
          ),
          border: Border.all(color: t.border),
          borderRadius: t.spacing.cardBorderRadius,
          boxShadow: t.cardShadow,
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              top: -72,
              end: -54,
              child: IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.tokens.accent.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: -90,
              start: -70,
              child: IgnorePointer(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.tokens.info.withValues(alpha: 0.06),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(t.spacing.space6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  final intro = _HeroIntro(
                    copy: copy,
                    onExploreToast: onExploreToast,
                    onOpenTheme: onOpenTheme,
                  );
                  final preview = _SystemPreview(
                    copy: copy,
                    selectedPalette: selectedPalette,
                    themeMode: themeMode,
                    locale: locale,
                  );

                  if (!wide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        intro,
                        SizedBox(height: t.spacing.space5),
                        preview,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: intro),
                      SizedBox(width: t.spacing.space6),
                      Expanded(flex: 4, child: preview),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroIntro extends StatelessWidget {
  const _HeroIntro({
    required this.copy,
    required this.onExploreToast,
    required this.onOpenTheme,
  });

  final _HomeCopy copy;
  final VoidCallback onExploreToast;
  final VoidCallback onOpenTheme;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _VersionBadge(label: copy.versionBadge),
        SizedBox(height: t.spacing.space4),
        Text(
          copy.heroTitle,
          style: context.superTextTheme.displayLg.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        SizedBox(height: t.spacing.space3),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            copy.heroDescription,
            style: context.superTextTheme.bodyLg.copyWith(
              color: t.fg3,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: t.spacing.space5),
        Wrap(
          spacing: t.spacing.space2,
          runSpacing: t.spacing.space2,
          children: [
            SuperButton(
              label: copy.exploreToast,
              icon: const Icon(Icons.notifications_active_outlined),
              onPressed: onExploreToast,
            ),
            SuperButton(
              label: copy.openTheme,
              variant: SuperButtonVariant.secondary,
              icon: const Icon(Icons.palette_outlined),
              onPressed: onOpenTheme,
            ),
          ],
        ),
      ],
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space3,
        vertical: t.spacing.space1,
      ),
      decoration: BoxDecoration(
        color: t.selectionFill(0.18),
        border: Border.all(color: t.tokens.accent.withValues(alpha: 0.25)),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.tokens.accent,
            ),
          ),
          SizedBox(width: t.spacing.space2),
          Text(
            label,
            style: context.superTextTheme.labelSm.copyWith(
              color: t.fg2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemPreview extends StatelessWidget {
  const _SystemPreview({
    required this.copy,
    required this.selectedPalette,
    required this.themeMode,
    required this.locale,
  });

  final _HomeCopy copy;
  final SuperPalette selectedPalette;
  final ThemeMode themeMode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final actualDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.surface.withValues(alpha: 0.84),
        border: Border.all(color: t.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: t.sizing.iconButton,
                height: t.sizing.iconButton,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: t.selectionFill(),
                  borderRadius: t.spacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.auto_awesome_outlined,
                  size: t.sizing.icon,
                  color: t.tokens.accent,
                ),
              ),
              SizedBox(width: t.spacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      copy.previewTitle,
                      style: context.superTextTheme.titleMd.copyWith(
                        color: t.fg1,
                      ),
                    ),
                    SizedBox(height: t.spacing.space1),
                    Text(
                      copy.previewSubtitle,
                      style: context.superTextTheme.bodySm.copyWith(
                        color: t.fg3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.space4),
          _PreviewRow(
            icon: Icons.palette_outlined,
            label: copy.paletteLabel,
            value: selectedPalette.name,
          ),
          SizedBox(height: t.spacing.space2),
          _PreviewRow(
            icon: actualDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            label: copy.appearanceLabel,
            value: themeMode == ThemeMode.system
                ? '${copy.system} · ${actualDark ? copy.dark : copy.light}'
                : actualDark
                ? copy.dark
                : copy.light,
          ),
          SizedBox(height: t.spacing.space2),
          _PreviewRow(
            icon: Icons.language_rounded,
            label: copy.languageLabel,
            value: locale.languageCode == 'ar' ? 'العربية' : 'English',
          ),
          SizedBox(height: t.spacing.space4),
          Wrap(
            spacing: t.spacing.space2,
            runSpacing: t.spacing.space2,
            children: [
              _StatPill(value: '6', label: copy.examplesStat),
              _StatPill(value: '10', label: copy.palettesStat),
              _StatPill(value: '2', label: copy.languagesStat),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space3,
        vertical: t.spacing.space2,
      ),
      decoration: BoxDecoration(
        color: t.inputBg.withValues(alpha: 0.72),
        borderRadius: t.spacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(icon, size: t.sizing.icon, color: t.fg3),
          SizedBox(width: t.spacing.space2),
          Expanded(
            child: Text(
              label,
              style: context.superTextTheme.bodySm.copyWith(color: t.fg3),
            ),
          ),
          Text(
            value,
            style: context.superTextTheme.labelMd.copyWith(color: t.fg1),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space3,
        vertical: t.spacing.space2,
      ),
      decoration: BoxDecoration(
        color: t.selectionFill(0.12),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: context.superTextTheme.labelMd.copyWith(
                color: t.tokens.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: context.superTextTheme.labelSm.copyWith(color: t.fg3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: context.superTextTheme.eyebrow.copyWith(
            color: t.tokens.accent,
            letterSpacing: context.isRtl ? 0 : 1.2,
          ),
        ),
        SizedBox(height: t.spacing.space1),
        Text(
          title,
          style: context.superTextTheme.headlineSm.copyWith(color: t.fg1),
        ),
        SizedBox(height: t.spacing.space2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            description,
            style: context.superTextTheme.body.copyWith(
              color: t.fg3,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatefulWidget {
  const _DestinationCard({
    required this.destination,
    required this.onTap,
  });

  final _ExampleDestination destination;
  final VoidCallback onTap;

  @override
  State<_DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<_DestinationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final destination = widget.destination;
    final markerColor = destination.marker.resolve(t.tokens);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.01 : 1,
          duration: t.tokens.durBase,
          curve: t.tokens.curveStandard,
          child: AnimatedContainer(
            duration: t.tokens.durBase,
            curve: t.tokens.curveStandard,
            constraints: const BoxConstraints(minHeight: 184),
            padding: t.spacing.cardPadding,
            decoration: BoxDecoration(
              color: _hovered ? t.hover : t.surface,
              border: Border.all(
                color: _hovered
                    ? markerColor.withValues(alpha: 0.45)
                    : t.border,
              ),
              borderRadius: t.spacing.cardBorderRadius,
              boxShadow: _hovered ? t.cardShadow : const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: t.sizing.iconButton,
                      height: t.sizing.iconButton,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: destination.featured
                            ? t.tint(markerColor, 0.18)
                            : t.tint(markerColor, 0.10),
                        borderRadius: t.spacing.borderRadiusMd,
                      ),
                      child: Icon(
                        destination.icon,
                        size: t.sizing.icon,
                        color: markerColor,
                      ),
                    ),
                    const Spacer(),
                    _CategoryChip(label: destination.category),
                  ],
                ),
                SizedBox(height: t.spacing.space4),
                Text(
                  destination.title,
                  style: context.superTextTheme.titleMd.copyWith(
                    color: t.fg1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: t.spacing.space2),
                Text(
                  destination.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.superTextTheme.body.copyWith(
                    color: t.fg3,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: t.spacing.space4),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: markerColor,
                        borderRadius: t.spacing.pillBorderRadius,
                      ),
                    ),
                    const Spacer(),
                    AnimatedSlide(
                      offset: _hovered
                          ? Offset.zero
                          : Offset(context.isRtl ? 0.12 : -0.12, 0),
                      duration: t.tokens.durBase,
                      curve: t.tokens.curveStandard,
                      child: Icon(
                        context.isRtl
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward_rounded,
                        size: t.sizing.icon,
                        color: _hovered ? t.tokens.accent : t.fg3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

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
        color: t.inputBg,
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Text(
        label,
        style: context.superTextTheme.labelSm.copyWith(color: t.fg3),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.copy});

  final _HomeCopy copy;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.inputBg.withValues(alpha: 0.55),
        border: Border.all(color: t.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.tips_and_updates_outlined,
            size: t.sizing.icon,
            color: t.tokens.accent,
          ),
          SizedBox(width: t.spacing.space3),
          Expanded(
            child: Text(
              copy.footerNote,
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

class _ExampleDestination {
  const _ExampleDestination({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.marker,
    required this.builder,
    this.featured = false,
  });

  final String title;
  final String description;
  final String category;
  final IconData icon;
  final SuperMarker marker;
  final WidgetBuilder builder;
  final bool featured;
}

class _HomeCopy {
  const _HomeCopy(this.isArabic);

  final bool isArabic;

  String get appTitle => isArabic ? 'Super Core' : 'Super Core';
  String get appSubtitle =>
      isArabic ? 'نظام تصميم Flutter' : 'Flutter design system';
  String get versionBadge => isArabic ? 'SUPER CORE · 3.5.1' : 'SUPER CORE · 3.5.1';
  String get heroTitle => isArabic
      ? 'ابنِ واجهات Flutter متناسقة، أسرع.'
      : 'Build consistent Flutter experiences, faster.';
  String get heroDescription => isArabic
      ? 'استكشف المكونات، نظام الثيم، التخطيطات وSuperToast من تطبيق واحد حديث ومتجاوب يستخدم نفس رموز وتصميم Super Core.'
      : 'Explore components, theming, layouts and SuperToast from one modern, responsive app that uses the same Super Core tokens and design language.';
  String get exploreToast => isArabic ? 'استكشف SuperToast' : 'Explore SuperToast';
  String get openTheme => isArabic ? 'استوديو الثيم' : 'Theme studio';
  String get previewTitle => isArabic ? 'النظام الحالي' : 'Current system';
  String get previewSubtitle =>
      isArabic ? 'إعدادات التصميم الفعالة الآن' : 'Live design settings';
  String get paletteLabel => isArabic ? 'لوحة الألوان' : 'Palette';
  String get appearanceLabel => isArabic ? 'المظهر' : 'Appearance';
  String get languageLabel => isArabic ? 'اللغة' : 'Language';
  String get light => isArabic ? 'فاتح' : 'Light';
  String get dark => isArabic ? 'داكن' : 'Dark';
  String get system => isArabic ? 'النظام' : 'System';
  String get examplesStat => isArabic ? 'أمثلة' : 'examples';
  String get palettesStat => isArabic ? 'لوحات' : 'palettes';
  String get languagesStat => isArabic ? 'لغتان' : 'languages';
  String get exploreEyebrow => isArabic ? 'المعرض' : 'Showcase';
  String get exploreTitle => isArabic ? 'استكشف النظام' : 'Explore the system';
  String get exploreDescription => isArabic
      ? 'كل شاشة تركز على جزء محدد من نظام التصميم، مع استخدام المكونات الفعلية والـ responsive tokens الخاصة بالمكتبة.'
      : 'Each screen focuses on one design-system capability using the real components and responsive tokens shipped by the package.';

  String get toastTitle => 'SuperToast';
  String get toastDescription => isArabic
      ? 'إشعارات Overlay متقدمة، stacking، animations، gestures وaccessibility.'
      : 'Advanced overlay feedback with stacking, motion, gestures and accessibility.';
  String get themeTitle => isArabic ? 'نظام الثيم' : 'Theme system';
  String get themeDescription => isArabic
      ? 'لوحات الألوان، الوضع الفاتح والداكن وتغطية Material Theme.'
      : 'Palettes, light/dark appearance and Material theme coverage.';
  String get galleryTitle => isArabic ? 'معرض المكونات' : 'Widget gallery';
  String get galleryDescription => isArabic
      ? 'الأزرار، tiles، sections، sliders، app bars وعناصر feedback.'
      : 'Buttons, tiles, sections, sliders, app bars and feedback primitives.';
  String get layoutTitle => isArabic ? 'مكونات التخطيط' : 'Layout components';
  String get layoutDescription => isArabic
      ? 'SuperScaffold متجاوب، grid وسلوك نقاط التوقف.'
      : 'Responsive SuperScaffold, grid and breakpoint behavior.';
  String get sectionTitle => isArabic ? 'مكونات الأقسام' : 'Section components';
  String get sectionDescription => isArabic
      ? 'أنواع section cards، headers وfooters في مكان واحد.'
      : 'Section-card variants, headers and footers in one place.';
  String get dialogTitle => isArabic ? 'Views وDialogs' : 'Views and dialogs';
  String get dialogDescription => isArabic
      ? 'Confirm/field views قابلة لإعادة الاستخدام مع dialog wrappers.'
      : 'Reusable confirm/field views and their dialog wrappers.';

  String get feedbackCategory => isArabic ? 'Feedback' : 'Feedback';
  String get foundationCategory => isArabic ? 'الأساس' : 'Foundation';
  String get componentsCategory => isArabic ? 'مكونات' : 'Components';
  String get layoutCategory => isArabic ? 'تخطيط' : 'Layout';
  String get patternsCategory => isArabic ? 'Patterns' : 'Patterns';

  String get footerNote => isArabic
      ? 'استخدم أزرار اللغة والثيم في شريط التطبيق لمعاينة RTL وتغييرات المظهر مباشرة. جميع ألوان ومسافات هذه الصفحة مأخوذة من Super Core.'
      : 'Use the language and theme controls in the app bar to preview RTL and appearance changes instantly. Every color and spacing value on this page comes from Super Core.';
}
