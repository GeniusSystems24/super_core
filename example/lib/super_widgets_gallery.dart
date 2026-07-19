import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

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

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SUPER CORE',
                style: SuperText.eyebrow.copyWith(color: cs.primary)),
            const Text('Widget Gallery'),
          ],
        ),
        actions: [
          if (widget.onThemeModeChanged != null) ...[
            _ModeBtn(ThemeMode.light, widget.themeMode, Icons.light_mode_outlined,
                'Light', () => widget.onThemeModeChanged!(ThemeMode.light)),
            _ModeBtn(ThemeMode.system, widget.themeMode,
                Icons.brightness_auto_outlined, 'System',
                () => widget.onThemeModeChanged!(ThemeMode.system)),
            _ModeBtn(ThemeMode.dark, widget.themeMode, Icons.dark_mode_outlined,
                'Dark', () => widget.onThemeModeChanged!(ThemeMode.dark)),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        children: [
          // ══ SuperButton ══════════════════════════════════════════════════
          const _G('SuperButton'),
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
          ]),

          // ══ SuperIconButton ══════════════════════════════════════════════
          const _G('SuperIconButton'),
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
            const SuperIconButton(icon: Icons.lock_outline, tooltip: 'Disabled'),
          ]),

          // ══ StatusPill ═══════════════════════════════════════════════════
          const _G('StatusPill'),
          const Wrap(spacing: 8, runSpacing: 8, children: [
            StatusPill('NEUTRAL', tone: PillTone.neutral),
            StatusPill('ACCENT', tone: PillTone.accent),
            StatusPill('INFO', tone: PillTone.info),
            StatusPill('SUCCESS', tone: PillTone.success),
            StatusPill('WARNING', tone: PillTone.warning),
            StatusPill('DANGER', tone: PillTone.danger),
          ]),

          // ══ FieldShell ═══════════════════════════════════════════════════
          const _G('FieldShell'),
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
          ),

          // ══ Hairline ═════════════════════════════════════════════════════
          const _G('Hairline'),
          Row(children: [
            Expanded(child: Text('Left', style: SuperText.body.copyWith(color: t.fg2))),
            const SizedBox(height: 24, child: Hairline(vertical: true)),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text('Right', style: SuperText.body.copyWith(color: t.fg2)),
            )),
          ]),
          const SizedBox(height: 12),
          const Hairline(),

          // ══ SuperCard ════════════════════════════════════════════════════
          const _G('SuperCard'),
          SuperCard(
            child: Text('Plain surface card.',
                style: SuperText.body.copyWith(color: t.fg1)),
          ),
          const SizedBox(height: 8),
          SuperCard(
            selected: _cardSelected,
            onTap: () => setState(() => _cardSelected = !_cardSelected),
            child: Text(
                _cardSelected ? 'Selected — tap to deselect' : 'Tap to select',
                style: SuperText.body.copyWith(color: t.fg1)),
          ),
          const SizedBox(height: 8),
          SuperCard(
            leading: Icon(Icons.storefront_outlined, color: cs.primary),
            header: const SectionHeader(
              title: 'Expandable — vertical',
              subtitle: 'Tap the card or chevron',
              marker: SuperMarker.ledger,
            ),
            expandedChild: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Revealed content grows downward.',
                  style: SuperText.body.copyWith(color: t.fg2)),
            ),
            child: Text('Downtown Central Store • STR-0042',
                style: SuperText.body.copyWith(color: t.fg1)),
          ),
          const SizedBox(height: 8),
          SuperCard(
            expandDirection: Axis.horizontal,
            leading: Icon(Icons.info_outline, color: t.tokens.warning),
            trailing: const StatusPill('NOTES', tone: PillTone.warning),
            expandedChild: SizedBox(
              width: 180,
              child: Text('Horizontal reveal grows sideways.',
                  style: SuperText.caption.copyWith(color: t.fg3)),
            ),
            child: Text('Horizontal expand + leading/trailing',
                style: SuperText.body.copyWith(color: t.fg1)),
          ),

          // ══ SuperSectionHeader — style1 ══════════════════════════════════
          const _G('SuperSectionHeader — style1'),
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
          ]),

          // ══ SuperSectionHeader — style2 ══════════════════════════════════
          const _G('SuperSectionHeader — style2'),
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
          ]),

          // ══ SuperSectionFooter ═══════════════════════════════════════════
          const _G('SuperSectionFooter'),
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
          ),

          // ══ SuperSection ═════════════════════════════════════════════════
          const _G('SuperSection'),
          SuperSection(
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
                style: SuperText.body.copyWith(color: t.fg2)),
          ),
          const SizedBox(height: 8),
          SuperSection(
            title: 'Financial',
            subtitle: 'Header-only, style2 (no footer)',
            headerStyle: SuperSectionHeaderStyle.style2,
            leading: const Icon(Icons.sync_alt),
            headerTrailing: const Icon(Icons.expand_more),
            child: Text('Linked control account and terms.',
                style: SuperText.body.copyWith(color: t.fg2)),
          ),
          const SizedBox(height: 8),
          SuperSection(
            card: false,
            title: 'Borderless',
            subtitle: 'card: false — no surface / border / shadow',
            marker: SuperMarker.ledger,
            child: Text('Useful inside an existing container.',
                style: SuperText.body.copyWith(color: t.fg2)),
          ),
          const SizedBox(height: 8),
          SuperSection(
            collapsible: true,
            dividerAfterHeader: true,
            title: 'Additional Notes',
            subtitle: 'Collapsible — tap the header to toggle',
            headerStyle: SuperSectionHeaderStyle.style2,
            marker: SuperMarker.notes,
            leading: const Icon(Icons.description_outlined),
            children: [
              Text('First note line — the body animates open and closed.',
                  style: SuperText.body.copyWith(color: t.fg2)),
              Text('Second line — children are auto-spaced by gap.',
                  style: SuperText.body.copyWith(color: t.fg2)),
            ],
          ),
          const SizedBox(height: 8),
          SuperSection(
            selected: _sectionSelected,
            onTap: () => setState(() => _sectionSelected = !_sectionSelected),
            title: 'Selectable Section',
            subtitle: _sectionSelected ? 'Selected — tap to deselect' : 'Tap to select',
            headerStyle: SuperSectionHeaderStyle.style2,
            leading: const Icon(Icons.check_circle_outline),
            child: Text('Accent border + tint appear when selected.',
                style: SuperText.body.copyWith(color: t.fg2)),
          ),

          // ══ SuperSlider ══════════════════════════════════════════════════
          const _G('SuperSlider — responsive · autoplay · loop'),
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
          ),
          const _G('SuperSlider — single item · no arrows'),
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
          ),
          const _G('SuperSlider — external controller'),
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
          ]),

          // ══ SuperAppBar ══════════════════════════════════════════════════
          const _G('SuperAppBar'),
          ClipRRect(
            borderRadius: BorderRadius.circular(t.tokens.radiusCard),
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
                    icon: Icons.help_outline, tooltip: 'Help', onPressed: () {}),
                SuperIconButton(
                    icon: Icons.download_outlined,
                    tooltip: 'Export',
                    onPressed: () {}),
                const Text('Duplicate'),
                const Text('Archive'),
              ],
            ),
          ),

          // ══ SuperSnackBar ════════════════════════════════════════════════
          const _G('SuperSnackBar'),
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
          ]),
        ],
      ),
    );
  }

  // ── Local demo helpers ──────────────────────────────────────────────────

  Widget _fakeInput(SuperThemeData t, String hint, {bool error = false}) {
    final k = t.tokens;
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
      child: Text(hint, style: SuperText.caption.copyWith(color: t.fg4)),
    );
  }

  Widget _panel(SuperThemeData t, List<Widget> children) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(t.tokens.radiusCard),
          border: Border.all(color: t.border),
          boxShadow: t.cardShadow,
        ),
        child: Column(children: children),
      );

  Widget _rule(SuperThemeData t) => Divider(height: 28, color: t.border);

  Widget _kpi(SuperThemeData t, String label, String value, SuperMarker marker) {
    final k = t.tokens;
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
              width: k.markerWidth,
              height: 16,
              margin: EdgeInsetsDirectional.only(end: k.space3),
              decoration: BoxDecoration(
                color: k.markerColor(marker),
                borderRadius: BorderRadius.circular(k.radiusPill),
              ),
            ),
            Expanded(
              child: Text(label,
                  style: SuperText.label.copyWith(color: t.fg3),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ]),
          Text(value, style: SuperText.mono.copyWith(color: t.fg1, fontSize: 22)),
        ],
      ),
    );
  }
}

/// A group label for the gallery — matches theme_demo_screen's `_Sec`.
class _G extends StatelessWidget {
  const _G(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12),
      child: Text(text, style: SuperText.eyebrow.copyWith(color: t.fg4)),
    );
  }
}

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
