// GENERATED DOCS-LAYOUT MIGRATION: super_core example docs v1
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'arabic_examples.dart';
/// A comprehensive gallery of every `Super*` widget with all of its scenarios.
/// Pushed from [ThemeDemoScreen]; inherits the ambient palette / theme so it
/// re-themes live with the parent's controls.
class SuperWidgetsGallery extends StatefulWidget {
  const SuperWidgetsGallery({
    super.key,
    this.themeMode = ThemeMode.system,
    this.onThemeModeChanged,
  });

  /// Current app theme mode (mirrors the parent control).
  final ThemeMode themeMode;

  /// Optional callback so the gallery's own theme-mode buttons drive the app.
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  State<SuperWidgetsGallery> createState() => _SuperWidgetsGalleryState();
}

class _SuperWidgetsGalleryState extends State<SuperWidgetsGallery> {
  final _sliderController = SuperSliderController();
  bool _cardSelected = false;
  bool _sectionSelected = false;
  int _listSelected = 0;
  int _gridSelected = 0;

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);

    return SuperExampleDocsPage(
      title: 'Widget Gallery',
      subtitle: 'SUPER CORE · v3.5.0',
      description:
          'A live catalog of Super Core widgets, states, densities, selection patterns, responsive behavior, and semantic feedback.',
      badges: const [
        SuperExampleDocsBadgeData(
          icon: Icons.widgets_outlined,
          label: 'Components',
          tone: SuperMarker.ledger,
        ),
        SuperExampleDocsBadgeData(
          icon: Icons.devices_outlined,
          label: 'Responsive',
          tone: SuperMarker.identity,
        ),
      ],
      api: const [
        'SuperButton',
        'SuperSectionCard',
        'SuperSlider',
        'SuperListTile',
        'SuperGridTile',
      ],
      actions: [
        if (widget.onThemeModeChanged != null) ...[
          _ModeBtn(
            ThemeMode.light,
            widget.themeMode,
            Icons.light_mode_outlined,
            'Light',
            () => widget.onThemeModeChanged!(ThemeMode.light),
          ),
          _ModeBtn(
            ThemeMode.system,
            widget.themeMode,
            Icons.brightness_auto_outlined,
            'System',
            () => widget.onThemeModeChanged!(ThemeMode.system),
          ),
          _ModeBtn(
            ThemeMode.dark,
            widget.themeMode,
            Icons.dark_mode_outlined,
            'Dark',
            () => widget.onThemeModeChanged!(ThemeMode.dark),
          ),
        ],
      ],
      sections: [
        SuperExampleDocsSectionData(
              label: 'SuperButton',
              eyebrow: 'Widget gallery',
              title: 'SuperButton',
              description: 'Primary, secondary, icon, and disabled button states.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperButton',
                          description: 'Primary, secondary, icon, and disabled button states.',
                          code: r'''SuperButton(label: 'Primary', onPressed: () {});''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Wrap(spacing: 12, runSpacing: 12, children: [
                                            SuperButton(label: 'Primary', onPressed: () {}),
                                            SuperButton(
                                                label: 'Secondary',
                                                variant: SuperButtonVariant.secondary,
                                                onPressed: () {}),
                                            SuperButton(
                                                label: 'With Icon',
                                                icon: const Icon(Icons.add),
                                                onPressed: () {}),
                                            SuperButton(
                                                label: 'Icon • Secondary',
                                                variant: SuperButtonVariant.secondary,
                                                icon: const Icon(Icons.download_outlined),
                                                onPressed: () {}),
                                            const SuperButton(label: 'Disabled'),
                                            const SuperButton(
                                                label: 'Disabled', variant: SuperButtonVariant.secondary),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperIconButton',
              eyebrow: 'Widget gallery',
              title: 'SuperIconButton',
              description: 'Compact icon actions including destructive and disabled states.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperIconButton',
                          description: 'Compact icon actions including destructive and disabled states.',
                          code: r'''SuperIconButton(icon: Icons.edit_outlined, onPressed: () {});''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Row(children: [
                                            SuperIconButton(
                                                icon: Icons.edit_outlined, tooltip: 'Edit', onPressed: () {}),
                                            const SizedBox(width: 8),
                                            SuperIconButton(
                                                icon: Icons.delete_outline,
                                                tooltip: 'Delete',
                                                danger: true,
                                                onPressed: () {}),
                                            const SizedBox(width: 8),
                                            const SuperIconButton(
                                                icon: Icons.lock_outline, tooltip: 'Disabled'),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        const SuperExampleDocsSectionData(
              label: 'StatusPill',
              eyebrow: 'Widget gallery',
              title: 'StatusPill',
              description: 'Semantic status tones using the shared Super Core color system.',
              children: [
                SuperExampleDocsCard(
                          title: 'StatusPill',
                          description: 'Semantic status tones using the shared Super Core color system.',
                          code: r'''StatusPill('SUCCESS', tone: PillTone.success);''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Wrap(spacing: 8, runSpacing: 8, children: [
                                            StatusPill('NEUTRAL', tone: PillTone.neutral),
                                            StatusPill('ACCENT', tone: PillTone.accent),
                                            StatusPill('INFO', tone: PillTone.info),
                                            StatusPill('SUCCESS', tone: PillTone.success),
                                            StatusPill('WARNING', tone: PillTone.warning),
                                            StatusPill('DANGER', tone: PillTone.danger),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        const SuperExampleDocsSectionData(
              label: 'Arabic / RTL',
              eyebrow: 'Widget gallery',
              title: 'Arabic / RTL',
              description: 'A live right-to-left composition using the same production widgets.',
              children: [
                  ArabicExampleSection(
                              title: 'مكونات عربية',
                              subtitle: 'بطاقة مشتركة لاختبار النصوص العربية داخل المعرض',
                              compactHeader: true,
                            )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'FieldShell',
              eyebrow: 'Widget gallery',
              title: 'FieldShell',
              description: 'Labels, hints, validation, disabled state, and density around arbitrary controls.',
              children: [
                SuperExampleDocsCard(
                          title: 'FieldShell',
                          description: 'Labels, hints, validation, disabled state, and density around arbitrary controls.',
                          code: r'''FieldShell(label: 'Name', hint: 'Helpful text', child: TextField());''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                FieldShell(
                                            label: 'Name English',
                                            required: true,
                                            hint: 'Enter the official store name',
                                            child: _fakeInput(t, 'e.g. Downtown Central Store'),
                                          ),
                                const SizedBox(height: 16),
                                FieldShell(
                                            label: 'Account Code',
                                            error: 'Required field — cannot be empty',
                                            child: _fakeInput(t, 'e.g. ACC-1001', error: true),
                                          ),
                                const SizedBox(height: 16),
                                FieldShell(
                                            label: 'Reference',
                                            disabled: true,
                                            density: FieldDensity.compact,
                                            child: _fakeInput(t, 'Auto-generated'),
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'Hairline',
              eyebrow: 'Widget gallery',
              title: 'Hairline',
              description: 'Theme-aware horizontal and vertical separators.',
              children: [
                SuperExampleDocsCard(
                          title: 'Hairline',
                          description: 'Theme-aware horizontal and vertical separators.',
                          code: r'''const Hairline();''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Row(children: [
                                            Expanded(
                                                child: Text('Left',
                                                    style: context.superTextTheme.body.copyWith(color: t.fg2))),
                                            const SizedBox(height: 24, child: Hairline(vertical: true)),
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(left: 12),
                                              child: Text('Right',
                                                  style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                            )),
                                          ]),
                                const SizedBox(height: 12),
                                const Hairline()
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionCard',
              eyebrow: 'Widget gallery',
              title: 'SuperSectionCard',
              description: 'Surface, selection, composition, expansion, header, and footer scenarios.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSectionCard',
                          description: 'Surface, selection, composition, expansion, header, and footer scenarios.',
                          code: r'''SuperSectionCard(title: 'Section', child: Text('Body'));''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperSectionCard(
                                            child: Text('Plain surface card.',
                                                style: context.superTextTheme.body.copyWith(color: t.fg1)),
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            selected: _cardSelected,
                                            onTap: () => setState(() => _cardSelected = !_cardSelected),
                                            child: Text(
                                                _cardSelected ? 'Selected — tap to deselect' : 'Tap to select',
                                                style: context.superTextTheme.body.copyWith(color: t.fg1)),
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            header: const SuperSectionHeader(
                                              title: 'Expandable — vertical',
                                              subtitle: 'Tap the card or chevron',
                                              marker: SuperMarker.ledger,
                                            ),
                                            expandedChild: Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text('Revealed content grows downward.',
                                                  style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                            ),
                                            child: Text('Downtown Central Store • STR-0042',
                                                style: context.superTextTheme.body.copyWith(color: t.fg1)),
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            expandDirection: Axis.horizontal,
                                            expandedChild: SizedBox(
                                              width: 180,
                                              child: Text('Horizontal reveal grows sideways.',
                                                  style: context.superTextTheme.caption.copyWith(color: t.fg3)),
                                            ),
                                            child: Text('Horizontal expand + leading/trailing',
                                                style: context.superTextTheme.body.copyWith(color: t.fg1)),
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionHeader — style1',
              eyebrow: 'Widget gallery',
              title: 'SuperSectionHeader — style1',
              description: 'Header variants, markers, subtitles, leading/trailing content, and density.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSectionHeader — style1',
                          description: 'Header variants, markers, subtitles, leading/trailing content, and density.',
                          code: r'''SuperSectionHeader(title: 'Financial', marker: SuperMarker.ledger);''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                _panel(t, [
                                            const SuperSectionHeader(
                                              eyebrow: 'STORES & PRODUCTS • STORES',
                                              title: 'Create Store',
                                              titleArabic: 'إنشاء متجر',
                                              subtitle: 'Define store name and location information',
                                              marker: SuperMarker.identity,
                                            ),
                                            _rule(t),
                                            const SuperSectionHeader(
                                              title: 'Opening Balance',
                                              subtitle: 'Ledger totals carried into the new period',
                                              marker: SuperMarker.ledger,
                                              trailing: StatusPill('BALANCED', tone: PillTone.success),
                                            ),
                                            _rule(t),
                                            const SuperSectionHeader(
                                              title: 'Notes',
                                              subtitle: 'Any additional documentation',
                                              marker: SuperMarker.notes,
                                              leading: Icon(Icons.description_outlined, size: 20),
                                            ),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionHeader — style2',
              eyebrow: 'Widget gallery',
              title: 'SuperSectionHeader — style2',
              description: 'Header variants, markers, subtitles, leading/trailing content, and density.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSectionHeader — style2',
                          description: 'Header variants, markers, subtitles, leading/trailing content, and density.',
                          code: r'''SuperSectionHeader(title: 'Financial', marker: SuperMarker.ledger);''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                _panel(t, [
                                            const SuperSectionHeader(
                                              style: SuperSectionHeaderStyle.style2,
                                              title: 'Financial',
                                              subtitle: 'Linked control account and terms',
                                              marker: SuperMarker.identity,
                                              leading: Icon(Icons.sync_alt),
                                              trailing: Icon(Icons.expand_more),
                                            ),
                                            const SizedBox(height: 16),
                                            const SuperSectionHeader(
                                              style: SuperSectionHeaderStyle.style2,
                                              title: 'Ledger Balance',
                                              subtitle: 'Opening totals carried into the period',
                                              marker: SuperMarker.ledger,
                                              leading: Icon(Icons.account_balance_wallet_outlined),
                                              trailing: Icon(Icons.chevron_right),
                                            ),
                                            const SizedBox(height: 16),
                                            const SuperSectionHeader(
                                              style: SuperSectionHeaderStyle.style2,
                                              title: 'Documentation',
                                              subtitle: 'Compliance notes and attachments',
                                              marker: SuperMarker.notes,
                                              leading: Icon(Icons.description_outlined),
                                            ),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionFooter',
              eyebrow: 'Widget gallery',
              title: 'SuperSectionFooter',
              description: 'Brand text, links, emphasis, and optional divider behavior.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSectionFooter',
                          description: 'Brand text, links, emphasis, and optional divider behavior.',
                          code: r'''SuperSectionFooter(brand: 'Super Core', actions: [SuperFooterLink('Docs')]);''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperSectionFooter(
                                            brand: '© 2024 GeniusLink ERP • System Status: Operational',
                                            actions: [
                                              SuperFooterLink('System Status', onTap: () {}),
                                              SuperFooterLink('Documentation', onTap: () {}),
                                              SuperFooterLink('Audit Log', onTap: () {}, emphasized: true),
                                            ],
                                          ),
                                const SizedBox(height: 8),
                                const SuperSectionFooter(
                                            brand: '© 2024 GeniusLink ERP • Precision System',
                                            showDivider: false,
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionCard · composed',
              eyebrow: 'Widget gallery',
              title: 'SuperSectionCard · composed',
              description: 'Surface, selection, composition, expansion, header, and footer scenarios.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSectionCard · composed',
                          description: 'Surface, selection, composition, expansion, header, and footer scenarios.',
                          code: r'''SuperSectionCard(title: 'Section', child: Text('Body'));''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperSectionCard(
                                            eyebrow: 'STORES & PRODUCTS • STORES',
                                            title: 'Create Store',
                                            titleArabic: 'إنشاء متجر',
                                            subtitle: 'Header + footer composed automatically',
                                            marker: SuperMarker.identity,
                                            headerTrailing: const StatusPill('DRAFT', tone: PillTone.warning),
                                            footerBrand: '© 2024 GeniusLink ERP',
                                            footerActions: [
                                              SuperFooterLink('Reset', onTap: () {}),
                                              SuperFooterLink('Save Draft', onTap: () {}, emphasized: true),
                                            ],
                                            child: Text('Body content sits between header and footer.',
                                                style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            title: 'Financial',
                                            subtitle: 'Header-only, style2 (no footer)',
                                            headerStyle: SuperSectionHeaderStyle.style2,
                                            leading: const Icon(Icons.sync_alt),
                                            headerTrailing: const Icon(Icons.expand_more),
                                            child: Text('Linked control account and terms.',
                                                style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            card: false,
                                            title: 'Borderless',
                                            subtitle: 'card: false — no surface / border / shadow',
                                            marker: SuperMarker.ledger,
                                            child: Text('Useful inside an existing container.',
                                                style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            collapsible: true,
                                            dividerAfterHeader: true,
                                            title: 'Additional Notes',
                                            subtitle: 'Collapsible — tap the header to toggle',
                                            headerStyle: SuperSectionHeaderStyle.style2,
                                            marker: SuperMarker.notes,
                                            leading: const Icon(Icons.description_outlined),
                                            children: [
                                              Text('First note line — the body animates open and closed.',
                                                  style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                              Text('Second line — children are auto-spaced by gap.',
                                                  style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                            ],
                                          ),
                                const SizedBox(height: 8),
                                SuperSectionCard(
                                            selected: _sectionSelected,
                                            onTap: () => setState(() => _sectionSelected = !_sectionSelected),
                                            title: 'Selectable Section',
                                            subtitle: _sectionSelected
                                                ? 'Selected — tap to deselect'
                                                : 'Tap to select',
                                            headerStyle: SuperSectionHeaderStyle.style2,
                                            leading: const Icon(Icons.check_circle_outline),
                                            child: Text('Accent border + tint appear when selected.',
                                                style: context.superTextTheme.body.copyWith(color: t.fg2)),
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSlider — responsive · autoplay · loop',
              eyebrow: 'Widget gallery',
              title: 'SuperSlider — responsive · autoplay · loop',
              description: 'Responsive slider behavior, controls, autoplay, loop, and external controller usage.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSlider — responsive · autoplay · loop',
                          description: 'Responsive slider behavior, controls, autoplay, loop, and external controller usage.',
                          code: r'''SuperSlider(children: [/* cards */]);''',
                          minPreviewHeight: 300,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperSlider(
                                            height: 140,
                                            gap: 12,
                                            peek: 24,
                                            autoPlay: true,
                                            loop: true,
                                            children: [
                                              for (final (label, value, marker) in const [
                                                ('TOTAL BALANCE', '\$248,200.00', SuperMarker.ledger),
                                                ('OPEN JOURNALS', '18', SuperMarker.identity),
                                                ('PENDING REVIEW', '3', SuperMarker.notes),
                                                ('ACTIVE STORES', '42', SuperMarker.identity),
                                              ])
                                                _kpi(t, label, value, marker),
                                            ],
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSlider — single item · no arrows',
              eyebrow: 'Widget gallery',
              title: 'SuperSlider — single item · no arrows',
              description: 'Responsive slider behavior, controls, autoplay, loop, and external controller usage.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSlider — single item · no arrows',
                          description: 'Responsive slider behavior, controls, autoplay, loop, and external controller usage.',
                          code: r'''SuperSlider(children: [/* cards */]);''',
                          minPreviewHeight: 300,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperSlider(
                                            height: 120,
                                            visibleItems: const SuperResponsive.all(1),
                                            showArrows: false,
                                            children: [
                                              for (final (label, value, marker) in const [
                                                ('Q4 REVENUE', '\$1.24M', SuperMarker.ledger),
                                                ('NET MARGIN', '18.4%', SuperMarker.identity),
                                              ])
                                                _kpi(t, label, value, marker),
                                            ],
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSlider — external controller',
              eyebrow: 'Widget gallery',
              title: 'SuperSlider — external controller',
              description: 'Responsive slider behavior, controls, autoplay, loop, and external controller usage.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSlider — external controller',
                          description: 'Responsive slider behavior, controls, autoplay, loop, and external controller usage.',
                          code: r'''SuperSlider(children: [/* cards */]);''',
                          minPreviewHeight: 300,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperSlider(
                                            controller: _sliderController,
                                            height: 120,
                                            visibleItems: const SuperResponsive.all(1),
                                            showArrows: false,
                                            showIndicator: false,
                                            children: [
                                              for (final (label, value, marker) in const [
                                                ('SLIDE ONE', 'A', SuperMarker.identity),
                                                ('SLIDE TWO', 'B', SuperMarker.ledger),
                                                ('SLIDE THREE', 'C', SuperMarker.notes),
                                              ])
                                                _kpi(t, label, value, marker),
                                            ],
                                          ),
                                const SizedBox(height: 12),
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            SuperButton(
                                                label: 'Previous',
                                                variant: SuperButtonVariant.secondary,
                                                icon: const Icon(Icons.chevron_left),
                                                onPressed: () => _sliderController.previous()),
                                            const SizedBox(width: 12),
                                            SuperButton(
                                                label: 'Next',
                                                icon: const Icon(Icons.chevron_right),
                                                onPressed: () => _sliderController.next()),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperListTile — densities · states · badges',
              eyebrow: 'Widget gallery',
              title: 'SuperListTile — densities · states · badges',
              description: 'List densities, badges, menus, selected and read-only states.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperListTile — densities · states · badges',
                          description: 'List densities, badges, menus, selected and read-only states.',
                          code: r'''SuperListTile(title: Text('Downtown Store'), selected: true);''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                _panel(t, [
                                            SuperListTile(
                                              marker: SuperMarker.identity,
                                              leadingIcon: Icons.storefront_outlined,
                                              titleText: 'Downtown Central Store',
                                              subtitle: const Text('STR-0042 • Riyadh'),
                                              badge: const StatusPill('ACTIVE', tone: PillTone.success),
                                              trailing: const Text('\$96,540.00'),
                                              selected: _listSelected == 0,
                                              onTap: () => setState(() => _listSelected = 0),
                                            ),
                                            SuperListTile(
                                              showSeparator: true,
                                              density: SuperTileDensity.compact,
                                              leadingWidgets: [
                                                Icon(Icons.warehouse_outlined, size: 20, color: t.fg3),
                                              ],
                                              titleText: 'North Warehouse',
                                              subtitle: const Text('STR-0043 • Dammam'),
                                              badge: const StatusPill('LOW STOCK', tone: PillTone.warning),
                                              trailingActions: [
                                                SuperIconButton(
                                                    icon: Icons.edit_outlined,
                                                    tooltip: 'Edit',
                                                    onPressed: () {}),
                                                SuperIconButton(
                                                    icon: Icons.delete_outline,
                                                    tooltip: 'Delete',
                                                    danger: true,
                                                    onPressed: () {}),
                                              ],
                                              selected: _listSelected == 1,
                                              onTap: () => setState(() => _listSelected = 1),
                                              contextMenuBuilder: (context) => const [
                                                PopupMenuItem(value: 'open', child: Text('Open')),
                                                PopupMenuItem(value: 'archive', child: Text('Archive')),
                                              ],
                                            ),
                                            SuperListTile(
                                              density: SuperTileDensity.expanded,
                                              alignment: SuperListTileAlignment.top,
                                              marker: SuperMarker.notes,
                                              leadingIcon: Icons.description_outlined,
                                              titleText: 'Q4 Reconciliation Note',
                                              subtitle: const Text('DOC-2024-0112'),
                                              supporting: const Text(
                                                  'Operational adjustment for quarterly reconciliation prior to the audit window.'),
                                              trailing: const Icon(Icons.chevron_right),
                                              onTap: () {},
                                            ),
                                            const SuperListTile(loading: true),
                                            const SuperListTile(
                                              enabled: false,
                                              leadingIcon: Icons.lock_outline,
                                              titleText: 'Archived Store',
                                              subtitle: Text('Read-only'),
                                            ),
                                          ])
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperGridTile — dashboard cards · selection · overlays',
              eyebrow: 'Widget gallery',
              title: 'SuperGridTile — dashboard cards · selection · overlays',
              description: 'Dashboard tiles with selection, overlays, status, header, and footer content.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperGridTile — dashboard cards · selection · overlays',
                          description: 'Dashboard tiles with selection, overlays, status, header, and footer content.',
                          code: r'''SuperGridTile(header: Text('TOTAL BALANCE'), child: Text('248,200'));''',
                          minPreviewHeight: 300,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                GridView.count(
                                            crossAxisCount: 2,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: 1.7,
                                            children: [
                                              SuperGridTile(
                                                marker: SuperMarker.ledger,
                                                header: const Text('TOTAL BALANCE'),
                                                badge: const StatusPill('LIVE', tone: PillTone.success),
                                                footer: const Text('Updated 2m ago'),
                                                selected: _gridSelected == 0,
                                                onTap: () => setState(() => _gridSelected = 0),
                                                child: Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Text('\$248,200.00',
                                                      style: context.superTextTheme.mono
                                                          .copyWith(color: t.fg1, fontSize: 22)),
                                                ),
                                              ),
                                              SuperGridTile(
                                                marker: SuperMarker.identity,
                                                header: const Text('OPEN JOURNALS'),
                                                footer: const Text('3 pending review'),
                                                selected: _gridSelected == 1,
                                                onTap: () => setState(() => _gridSelected = 1),
                                                actions: [
                                                  SuperIconButton(
                                                      icon: Icons.open_in_full,
                                                      tooltip: 'Expand',
                                                      onPressed: () {}),
                                                ],
                                                child: Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Text('18',
                                                      style: context.superTextTheme.mono
                                                          .copyWith(color: t.fg1, fontSize: 22)),
                                                ),
                                              ),
                                              const SuperGridTile(loading: true, mediaHeight: 60),
                                              SuperGridTile(
                                                enabled: false,
                                                header: const Text('ARCHIVED'),
                                                footer: const Text('Locked'),
                                                child: Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Text('—',
                                                      style: context.superTextTheme.mono
                                                          .copyWith(color: t.fg3, fontSize: 22)),
                                                ),
                                              ),
                                            ],
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperAppBar',
              eyebrow: 'Widget gallery',
              title: 'SuperAppBar',
              description: 'Responsive app-bar title, subtitle, actions, and overflow behavior.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperAppBar',
                          description: 'Responsive app-bar title, subtitle, actions, and overflow behavior.',
                          code: r'''SuperAppBar(title: Text('Create Store'), actions: [/* ... */]);''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                ClipRRect(
                                            borderRadius: BorderRadius.circular(t.spacing.radiusCard),
                                            child: SuperAppBar(
                                              primary: false,
                                              automaticallyImplyLeading: false,
                                              leading: const BackButton(),
                                              title: const Text('Create Store'),
                                              subtitle: const Text('STORES & PRODUCTS • STORES'),
                                              subtitlePosition: SubtitlePosition.above,
                                              maxActions: 2,
                                              actions: [
                                                SuperIconButton(
                                                    icon: Icons.help_outline,
                                                    tooltip: 'Help',
                                                    onPressed: () {}),
                                                SuperIconButton(
                                                    icon: Icons.download_outlined,
                                                    tooltip: 'Export',
                                                    onPressed: () {}),
                                                const Text('Duplicate'),
                                                const Text('Archive'),
                                              ],
                                            ),
                                          )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSnackBar',
              eyebrow: 'Widget gallery',
              title: 'SuperSnackBar',
              description: 'Semantic transient feedback using the legacy ScaffoldMessenger-based API.',
              children: [
                SuperExampleDocsCard(
                          title: 'SuperSnackBar',
                          description: 'Semantic transient feedback using the legacy ScaffoldMessenger-based API.',
                          code: r'''SuperSnackBar.success(context, 'Saved successfully.');''',
                          minPreviewHeight: 220,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Wrap(spacing: 8, runSpacing: 8, children: [
                                            SuperButton(
                                                label: 'Info',
                                                variant: SuperButtonVariant.secondary,
                                                onPressed: () => SuperSnackBar.info(context, 'Draft saved.',
                                                    actionLabel: 'View', onAction: () {})),
                                            SuperButton(
                                                label: 'Success',
                                                variant: SuperButtonVariant.secondary,
                                                onPressed: () => SuperSnackBar.success(
                                                    context, 'Journal entry JV-2024-0042 posted.')),
                                            SuperButton(
                                                label: 'Warning',
                                                variant: SuperButtonVariant.secondary,
                                                onPressed: () => SuperSnackBar.warning(
                                                    context, '3 entries require review before closing.')),
                                            SuperButton(
                                                label: 'Danger',
                                                variant: SuperButtonVariant.secondary,
                                                onPressed: () => SuperSnackBar.danger(
                                                    context, 'Transfer failed — accounts out of balance.')),
                                          ])
                            ],
                          ),
                        )
                ],
            )
      ],
      footer: const SuperExampleDocsNote(
        text:
            'Every preview is the real widget, not a screenshot. Change the app theme or language to inspect live theme and RTL behavior.',
      ),
    );
  }

  // ── Local demo helpers ──────────────────────────────────────────────────

  Widget _fakeInput(SuperThemeData t, String hint, {bool error = false}) {
    final k = t.spacing;
    return Container(
      height: k.controlHeight,
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.symmetric(horizontal: k.space4),
      decoration: BoxDecoration(
        color: t.inputBg,
        borderRadius: BorderRadius.circular(k.radiusControl),
        border: Border.all(
            color: error ? Theme.of(context).colorScheme.error : t.border),
      ),
      child: Text(hint,
          style: context.superTextTheme.caption.copyWith(color: t.fg4)),
    );
  }

  Widget _panel(SuperThemeData t, List<Widget> children) => SuperSectionCard(
        child: Column(children: children),
      );

  Widget _rule(SuperThemeData t) => Divider(height: 28, color: t.border);

  Widget _kpi(
      SuperThemeData t, String label, String value, SuperMarker marker) {
    final k = t.spacing;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(k.radiusCard),
        border: Border.all(color: t.border),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: t.tokens.markerWidth,
              height: 16,
              margin: EdgeInsetsDirectional.only(end: k.space3),
              decoration: BoxDecoration(
                color: t.tokens.markerColor(marker),
                borderRadius: BorderRadius.circular(k.radiusPill),
              ),
            ),
            Expanded(
              child: Text(label,
                  style: context.superTextTheme.label.copyWith(color: t.fg3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          Text(value,
              style: context.superTextTheme.mono
                  .copyWith(color: t.fg1, fontSize: 22)),
        ],
      ),
    );
  }
}

/// A group label for the gallery — matches theme_demo_screen's `_Sec`.
/// Segmented theme-mode button (mirrors theme_demo_screen's `_ThemeModeBtn`).
class _ModeBtn extends StatelessWidget {
  const _ModeBtn(this.mode, this.current, this.icon, this.tip, this.onTap);
  final ThemeMode mode;
  final ThemeMode current;
  final IconData icon;
  final String tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sel = mode == current;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: Icon(icon, size: 20),
        tooltip: tip,
        isSelected: sel,
        style: IconButton.styleFrom(
          backgroundColor: sel ? cs.primaryContainer : null,
          foregroundColor: sel ? cs.onPrimaryContainer : cs.onSurfaceVariant,
        ),
        onPressed: onTap,
      ),
    );
  }
}
