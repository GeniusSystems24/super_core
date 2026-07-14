import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

/// Full-screen demo showcasing [SuperPalette] and [SuperMaterialThemeData].
///
/// Features:
/// - Palette selector — all six built-in palettes as choice chips
/// - Light / Dark / System theme mode toggle in the app bar
/// - Shade swatch row (shade50 – shade900) for the active palette
/// - ColorScheme role grid (primary, secondary, surface, error, outline, …)
/// - Buttons (elevated, outlined, text, filled, with icon, disabled)
/// - Form fields (text, error state, dropdown)
/// - Section card with GeniusLink-style 4 px marker bar
/// - Toggle controls (switch, checkbox, slider)
/// - Chips and segmented button
/// - Status pills (GeniusLink semantic states)
/// - Progress indicators (circular + linear)
/// - Data table (audit-grade, with mono numerics and status pills)
/// - Typography ramp (all SuperText styles)
class ThemeDemoScreen extends StatefulWidget {
  const ThemeDemoScreen({
    super.key,
    required this.selectedPalette,
    required this.themeMode,
    required this.onPaletteChanged,
    required this.onThemeModeChanged,
  });

  final SuperPalette selectedPalette;
  final ThemeMode themeMode;
  final ValueChanged<SuperPalette> onPaletteChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends State<ThemeDemoScreen> {
  bool _switchValue = true;
  bool _checkboxValue = true;
  double _sliderValue = 0.6;
  int _navIndex = 0;
  String? _dropdownValue = 'asset';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = SuperThemeData.of(context);
    final palette = widget.selectedPalette;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SUPER CORE',
                style: SuperText.eyebrow.copyWith(color: cs.primary)),
            const Text('Theme Demo'),
          ],
        ),
        actions: [
          _ThemeModeButton(
            mode: ThemeMode.light,
            current: widget.themeMode,
            icon: Icons.light_mode_outlined,
            tooltip: 'Light',
            onTap: () => widget.onThemeModeChanged(ThemeMode.light),
          ),
          _ThemeModeButton(
            mode: ThemeMode.system,
            current: widget.themeMode,
            icon: Icons.brightness_auto_outlined,
            tooltip: 'System',
            onTap: () => widget.onThemeModeChanged(ThemeMode.system),
          ),
          _ThemeModeButton(
            mode: ThemeMode.dark,
            current: widget.themeMode,
            icon: Icons.dark_mode_outlined,
            tooltip: 'Dark',
            onTap: () => widget.onThemeModeChanged(ThemeMode.dark),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.palette_outlined), label: 'Palette'),
          NavigationDestination(
              icon: Icon(Icons.widgets_outlined), label: 'Components'),
          NavigationDestination(
              icon: Icon(Icons.table_chart_outlined), label: 'Data'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(SuperTokens.space6),
        children: [
          // ── Palette Selector ──────────────────────────────────────────────
          _Label('PALETTE'),
          const SizedBox(height: SuperTokens.space2),
          Wrap(
            spacing: SuperTokens.space2,
            runSpacing: SuperTokens.space2,
            children: SuperPalette.values.map((p) {
              final selected = p.name == palette.name;
              return ChoiceChip(
                label: Text(p.name),
                selected: selected,
                avatar: CircleAvatar(
                    backgroundColor: p.shade500, radius: 8),
                onSelected: (_) => widget.onPaletteChanged(p),
                selectedColor: cs.primary.withOpacity(0.18),
                side: selected
                    ? BorderSide(color: cs.primary, width: 2)
                    : BorderSide(color: t.border),
                labelStyle: SuperText.body.copyWith(
                  color: selected ? cs.primary : t.fg1,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Shade Swatches ────────────────────────────────────────────────
          _Label('SHADES — ${palette.name.toUpperCase()}'),
          const SizedBox(height: SuperTokens.space3),
          _ShadeRow(palette: palette),

          const SizedBox(height: SuperTokens.space8),

          // ── ColorScheme Roles ─────────────────────────────────────────────
          _Label('COLOR SCHEME ROLES'),
          const SizedBox(height: SuperTokens.space3),
          _ColorSchemeGrid(cs: cs),

          const SizedBox(height: SuperTokens.space8),

          // ── Buttons ───────────────────────────────────────────────────────
          _Label('BUTTONS'),
          const SizedBox(height: SuperTokens.space3),
          Wrap(
            spacing: SuperTokens.space2,
            runSpacing: SuperTokens.space2,
            children: [
              ElevatedButton(
                  onPressed: () {}, child: const Text('Elevated')),
              OutlinedButton(
                  onPressed: () {}, child: const Text('Outlined')),
              TextButton(onPressed: () {}, child: const Text('Text')),
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              ElevatedButton(
                  onPressed: null, child: const Text('Disabled')),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Entry'),
              ),
            ],
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Form Fields ───────────────────────────────────────────────────
          _Label('FORM FIELDS'),
          const SizedBox(height: SuperTokens.space3),
          const TextField(
            decoration: InputDecoration(
              labelText: 'NAME ENGLISH',
              hintText: 'e.g. Downtown Central Store',
              prefixIcon: Icon(Icons.business_outlined),
            ),
          ),
          const SizedBox(height: SuperTokens.space4),
          const TextField(
            decoration: InputDecoration(
              labelText: 'ACCOUNT CODE',
              hintText: 'e.g. ACC-1001',
              prefixIcon: Icon(Icons.tag_outlined),
              errorText: 'Required field',
            ),
          ),
          const SizedBox(height: SuperTokens.space4),
          DropdownButtonFormField<String>(
            value: _dropdownValue,
            decoration:
                const InputDecoration(labelText: 'ACCOUNT TYPE'),
            items: const [
              DropdownMenuItem(value: 'asset', child: Text('Asset')),
              DropdownMenuItem(
                  value: 'liability', child: Text('Liability')),
              DropdownMenuItem(value: 'equity', child: Text('Equity')),
            ],
            onChanged: (v) => setState(() => _dropdownValue = v),
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Section Card ──────────────────────────────────────────────────
          _Label('SECTION CARD'),
          const SizedBox(height: SuperTokens.space3),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(SuperTokens.space6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SuperTokens.markerWidth,
                        height: SuperTokens.markerHeight,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(
                              SuperTokens.radiusPill),
                        ),
                      ),
                      const SizedBox(width: SuperTokens.space4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Store Details',
                              style: SuperText.heading
                                  .copyWith(color: t.fg1)),
                          Text(
                              'Define store name and location information',
                              style: SuperText.caption
                                  .copyWith(color: t.fg3)),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: SuperTokens.space8, color: t.border),
                  Text(
                    'Cards use an 8 px radius, 1 px hairline border, and a '
                    'drop shadow in dark mode. The 4 px colored section-marker '
                    'bar is the most distinctive GeniusLink visual element — '
                    'blue for identity, green for ledger, orange for notes.',
                    style: SuperText.body.copyWith(color: t.fg2),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Toggle Controls ───────────────────────────────────────────────
          _Label('TOGGLE CONTROLS'),
          const SizedBox(height: SuperTokens.space2),
          SwitchListTile(
            title: Text('Active',
                style: SuperText.body.copyWith(color: t.fg1)),
            subtitle: Text('Store is open for transactions',
                style: SuperText.caption.copyWith(color: t.fg3)),
            value: _switchValue,
            onChanged: (v) => setState(() => _switchValue = v),
          ),
          CheckboxListTile(
            title: Text('Auto-reconcile',
                style: SuperText.body.copyWith(color: t.fg1)),
            subtitle: Text('Run nightly reconciliation',
                style: SuperText.caption.copyWith(color: t.fg3)),
            value: _checkboxValue,
            onChanged: (v) =>
                setState(() => _checkboxValue = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SuperTokens.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Confidence threshold '
                    '(${(_sliderValue * 100).round()}%)',
                    style:
                        SuperText.label.copyWith(color: t.fg3)),
                Slider(
                  value: _sliderValue,
                  onChanged: (v) =>
                      setState(() => _sliderValue = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Chips ─────────────────────────────────────────────────────────
          _Label('CHIPS & SEGMENTED BUTTON'),
          const SizedBox(height: SuperTokens.space3),
          Wrap(
            spacing: SuperTokens.space2,
            runSpacing: SuperTokens.space2,
            children: [
              Chip(
                  label: const Text('Journal Entry'),
                  onDeleted: () {}),
              Chip(label: const Text('Inventory'), onDeleted: () {}),
              FilterChip(
                label: const Text('Active'),
                selected: true,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Archived'),
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
          const SizedBox(height: SuperTokens.space4),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.view_list_outlined),
                  label: Text('List')),
              ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.grid_view_outlined),
                  label: Text('Grid')),
              ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.bar_chart_outlined),
                  label: Text('Chart')),
            ],
            selected: const {0},
            onSelectionChanged: (_) {},
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Status Pills ──────────────────────────────────────────────────
          _Label('STATUS PILLS'),
          const SizedBox(height: SuperTokens.space3),
          Wrap(
            spacing: SuperTokens.space2,
            runSpacing: SuperTokens.space2,
            children: [
              _StatusPill('POSTED', SuperTokens.success, t),
              _StatusPill('PENDING', SuperTokens.accent, t),
              _StatusPill('DRAFT', SuperTokens.warning, t),
              _StatusPill('VOIDED', SuperTokens.danger, t),
            ],
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Progress ──────────────────────────────────────────────────────
          _Label('PROGRESS INDICATORS'),
          const SizedBox(height: SuperTokens.space3),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                    value: 0.7, strokeWidth: 4),
              ),
              const SizedBox(width: SuperTokens.space6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sync progress — 60%',
                        style: SuperText.caption
                            .copyWith(color: t.fg3)),
                    const SizedBox(height: SuperTokens.space1),
                    const LinearProgressIndicator(value: 0.6),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Data Table ────────────────────────────────────────────────────
          _Label('DATA TABLE'),
          const SizedBox(height: SuperTokens.space3),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text('#',
                        style:
                            SuperText.mono.copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('ACCOUNT',
                        style: SuperText.label
                            .copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('TYPE',
                        style: SuperText.label
                            .copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('BALANCE',
                        style: SuperText.label
                            .copyWith(color: t.fg3)),
                    numeric: true),
              ],
              rows: [
                _tableRow(t, '1', 'Cash & Equivalents',
                    'Asset', '+\$12,400.00'),
                _tableRow(t, '2', 'Accounts Receivable',
                    'Asset', '+\$5,240.00'),
                _tableRow(t, '3', 'Short-term Liabilities',
                    'Liability', '-\$3,800.00'),
                _tableRow(t, '4', 'Retained Earnings',
                    'Equity', '+\$13,840.00'),
              ],
            ),
          ),

          const SizedBox(height: SuperTokens.space8),

          // ── Typography Ramp ───────────────────────────────────────────────
          _Label('TYPOGRAPHY RAMP'),
          const SizedBox(height: SuperTokens.space3),
          _TypeRow('h1 — Manrope 26/700 −0.025em',
              SuperText.h1, t.fg1),
          _TypeRow('heading — Inter 16/700',
              SuperText.heading, t.fg1),
          _TypeRow('body — Inter 14/400',
              SuperText.body, t.fg1),
          _TypeRow('button — Inter 14/600',
              SuperText.button, t.fg1),
          _TypeRow('label — Inter 11/700 ALL CAPS',
              SuperText.label, t.fg2),
          _TypeRow('caption — Inter 12/400',
              SuperText.caption, t.fg3),
          _TypeRow('mono — JetBrains Mono 14/400',
              SuperText.mono, t.fg1),
          _TypeRow('eyebrow — 11/700 WIDE TRACK',
              SuperText.eyebrow, t.fg3),
          _TypeRow('pill — 10/700',
              SuperText.pill, cs.primary),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  DataRow _tableRow(SuperThemeData t, String n, String account,
      String type, String balance) {
    final isNeg = balance.startsWith('-');
    final typeColor = type == 'Asset'
        ? SuperTokens.success
        : type == 'Liability'
            ? SuperTokens.danger
            : SuperTokens.accent;
    return DataRow(cells: [
      DataCell(Text(n,
          style: SuperText.mono.copyWith(color: t.fg3))),
      DataCell(Text(account,
          style: SuperText.body.copyWith(color: t.fg1))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(
            horizontal: SuperTokens.space2, vertical: 2),
        decoration: BoxDecoration(
          color: typeColor.withOpacity(0.12),
          borderRadius:
              BorderRadius.circular(SuperTokens.radiusPill),
        ),
        child: Text(type.toUpperCase(),
            style: SuperText.pill.copyWith(color: typeColor)),
      )),
      DataCell(Text(balance,
          style: SuperText.mono.copyWith(
              color: isNeg
                  ? SuperTokens.danger
                  : SuperTokens.success))),
    ]);
  }
}

// ── Reusable helpers ──────────────────────────────────────────────────────────

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton({
    required this.mode,
    required this.current,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final ThemeMode mode, current;
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = mode == current;
    final cs = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(icon, size: 20),
      color: selected ? cs.primary : null,
      onPressed: onTap,
      tooltip: tooltip,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Text(text,
        style: SuperText.eyebrow.copyWith(color: t.fg4));
  }
}

class _ShadeRow extends StatelessWidget {
  const _ShadeRow({required this.palette});
  final SuperPalette palette;

  @override
  Widget build(BuildContext context) {
    final shades = [
      (50, palette.shade50),
      (100, palette.shade100),
      (200, palette.shade200),
      (300, palette.shade300),
      (400, palette.shade400),
      (500, palette.shade500),
      (600, palette.shade600),
      (700, palette.shade700),
      (800, palette.shade800),
      (900, palette.shade900),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
      child: Row(
        children: shades.map((s) {
          final (label, color) = s;
          final onColor = color.computeLuminance() > 0.35
              ? const Color(0xFF0F172A)
              : const Color(0xFFFFFFFF);
          return Expanded(
            child: Tooltip(
              message:
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
              child: Container(
                height: 64,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 4),
                color: color,
                child: Text('$label',
                    style: SuperText.pill
                        .copyWith(color: onColor)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ColorSchemeGrid extends StatelessWidget {
  const _ColorSchemeGrid({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final roles = [
      ('primary', cs.primary, cs.onPrimary),
      ('onPrimary', cs.onPrimary, cs.primary),
      ('primaryContainer', cs.primaryContainer,
          cs.onPrimaryContainer),
      ('onPrimaryContainer', cs.onPrimaryContainer,
          cs.primaryContainer),
      ('secondary', cs.secondary, cs.onSecondary),
      ('onSecondary', cs.onSecondary, cs.secondary),
      ('tertiary', cs.tertiary, cs.onTertiary),
      ('error', cs.error, cs.onError),
      ('surface', cs.surface, cs.onSurface),
      ('onSurface', cs.onSurface, cs.surface),
      ('surfaceVariant', cs.surfaceVariant, cs.onSurfaceVariant),
      ('outline', cs.outline, cs.surface),
    ];
    return Wrap(
      spacing: SuperTokens.space2,
      runSpacing: SuperTokens.space2,
      children: roles.map((r) {
        final (name, bg, fg) = r;
        return Container(
          width: 140,
          height: 56,
          decoration: BoxDecoration(
            color: bg,
            borderRadius:
                BorderRadius.circular(SuperTokens.radiusControl),
            border: Border.all(
                color: Colors.black.withOpacity(0.08), width: 1),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.bottomLeft,
          child: Text(name,
              style: SuperText.pill.copyWith(color: fg),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill(this.label, this.color, this.t);
  final String label;
  final Color color;
  final SuperThemeData t;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: SuperTokens.space2, vertical: SuperTokens.space1),
      decoration: BoxDecoration(
        color: t.tintFill(color, 0.14),
        borderRadius: BorderRadius.circular(SuperTokens.radiusPill),
      ),
      child: Text(label, style: SuperText.pill.copyWith(color: color)),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow(this.name, this.style, this.color);
  final String name;
  final TextStyle style;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Aa', style: style.copyWith(color: color)),
          ),
          Expanded(
            flex: 5,
            child: Text(name,
                style: SuperText.caption.copyWith(color: t.fg4)),
          ),
        ],
      ),
    );
  }
}
