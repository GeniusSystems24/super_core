import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

/// Comprehensive Material 3 theme showcase for [SuperMaterialThemeData].
///
/// Sections:
///   Palette · Color Scheme · App Bar · Buttons · Icon Buttons · FAB ·
///   Form Fields · Search · Selection Controls · Chips · Cards · List Tiles ·
///   Navigation · Tabs · Overlays (Dialog · Sheet · Drawer · Snackbar · Popup
///   · Menu) · Badges · Tooltips · Dividers · Progress · Data Table · Typography
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

class _ThemeDemoScreenState extends State<ThemeDemoScreen>
    with SingleTickerProviderStateMixin {
  // Form state
  bool _switch1 = true;
  bool _switch2 = false;
  bool _check1 = true;
  bool _check2 = false;
  int _radio = 1;
  double _slider = 0.6;
  RangeValues _range = const RangeValues(0.3, 0.7);
  String? _dropdown = 'asset';
  String? _menuValue;
  int _navIndex = 0;
  int _tabIndex = 0;

  late final TabController _tabController =
      TabController(length: 3, vsync: this)
        ..addListener(() => setState(() => _tabIndex = _tabController.index));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Overlay helpers ─────────────────────────────────────────────────────────

  void _showDialog() => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text(
              'This will post the journal entry and mark it as final. '
              'This action cannot be undone.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Post Entry')),
          ],
        ),
      );

  void _showBottomSheet() => showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Export Options',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('Choose a format for the exported data.',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 24),
              for (final item in [
                (
                  Icons.table_chart_outlined,
                  'CSV Spreadsheet',
                  'Comma-separated values'
                ),
                (
                  Icons.picture_as_pdf_outlined,
                  'PDF Document',
                  'Formatted printable report'
                ),
                (Icons.code_outlined, 'JSON Data', 'Machine-readable format'),
              ])
                ListTile(
                  leading: Icon(item.$1),
                  title: Text(item.$2),
                  subtitle: Text(item.$3),
                  onTap: () => Navigator.pop(context),
                ),
            ],
          ),
        ),
      );

  void _showSnackBar() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Journal entry JV-2024-0042 posted successfully.'),
          action: SnackBarAction(label: 'View', onPressed: () {}),
          duration: const Duration(seconds: 4),
        ),
      );

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = SuperThemeData.of(context);
    final palette = widget.selectedPalette;

    return Scaffold(
      // ── Drawer ──────────────────────────────────────────────────────────────
      drawer: _buildDrawer(context, cs, t),
      endDrawer: _buildEndDrawer(context, cs, t),

      // ── App Bar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SUPER CORE',
                style: SuperText.eyebrow.copyWith(color: cs.primary)),
            const Text('Material Theme Showcase'),
          ],
        ),
        actions: [
          _ThemeModeBtn(
              ThemeMode.light,
              widget.themeMode,
              Icons.light_mode_outlined,
              'Light',
              () => widget.onThemeModeChanged(ThemeMode.light)),
          _ThemeModeBtn(
              ThemeMode.system,
              widget.themeMode,
              Icons.brightness_auto_outlined,
              'System',
              () => widget.onThemeModeChanged(ThemeMode.system)),
          _ThemeModeBtn(
              ThemeMode.dark,
              widget.themeMode,
              Icons.dark_mode_outlined,
              'Dark',
              () => widget.onThemeModeChanged(ThemeMode.dark)),
          const SizedBox(width: 4),
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'End Drawer',
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ── FAB ─────────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create Entry'),
        tooltip: 'Open dialog demo',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ── Bottom Navigation Bar ────────────────────────────────────────────────
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.palette_outlined), label: 'Theme'),
          NavigationDestination(
              icon: Icon(Icons.widgets_outlined), label: 'Widgets'),
          NavigationDestination(
              icon: Icon(Icons.table_chart_outlined), label: 'Data'),
          NavigationDestination(
              icon: Icon(Icons.text_fields_outlined), label: 'Type'),
        ],
      ),

      // ── Body ─────────────────────────────────────────────────────────────────
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          // ════════════════════════════════════════════════════════════════════
          // 1 · PALETTE
          // ════════════════════════════════════════════════════════════════════
          const _Sec('PALETTE'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SuperPalette.values.map((p) {
              final sel = p.name == palette.name;
              return ChoiceChip(
                label: Text(p.name),
                selected: sel,
                avatar: CircleAvatar(backgroundColor: p.shade500, radius: 8),
                onSelected: (_) => widget.onPaletteChanged(p),
                selectedColor: cs.primary.withOpacity(0.15),
                side: sel
                    ? BorderSide(color: cs.primary, width: 2)
                    : BorderSide(color: t.border),
                labelStyle: SuperText.body.copyWith(
                  color: sel ? cs.primary : t.fg1,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _ShadeRow(palette: palette),

          // ════════════════════════════════════════════════════════════════════
          // 2 · COLOR SCHEME
          // ════════════════════════════════════════════════════════════════════
          _Sec('COLOR SCHEME ROLES'),
          _ColorSchemeGrid(cs: cs),

          // ════════════════════════════════════════════════════════════════════
          // 3 · APP BARS (static previews)
          // ════════════════════════════════════════════════════════════════════
          _Sec('APP BAR VARIANTS'),
          _AppBarPreview(
            title: 'Standard App Bar',
            subtitle: 'ACCOUNTING • JOURNALS',
            cs: cs,
            t: t,
          ),
          const SizedBox(height: 8),
          _AppBarPreview(
            title: 'App Bar With Search',
            subtitle: 'STORES & PRODUCTS',
            cs: cs,
            t: t,
            showSearch: true,
          ),

          // ════════════════════════════════════════════════════════════════════
          // 4 · BUTTONS
          // ════════════════════════════════════════════════════════════════════
          _Sec('BUTTONS'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            FilledButton.tonal(
                onPressed: () {}, child: const Text('Filled Tonal')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
            ElevatedButton(onPressed: null, child: const Text('Disabled')),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Entry')),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Export')),
            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, size: 16),
                label: const Text('Filter')),
          ]),

          // ── Icon Buttons ───────────────────────────────────────────────────
          _Sec('ICON BUTTONS'),
          Row(children: [
            IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
                tooltip: 'Standard'),
            IconButton.filled(
                icon: const Icon(Icons.favorite),
                onPressed: () {},
                tooltip: 'Filled'),
            IconButton.filledTonal(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
                tooltip: 'Filled Tonal'),
            IconButton.outlined(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
                tooltip: 'Outlined'),
            IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
                tooltip: 'More'),
            const SizedBox(width: 8),
            const VerticalDivider(width: 1, indent: 8, endIndent: 8),
            const SizedBox(width: 8),
            IconButton(
                icon: const Icon(Icons.delete_outline),
                color: cs.error,
                onPressed: () {},
                tooltip: 'Danger'),
          ]),

          // ── FAB Row ────────────────────────────────────────────────────────
          _Sec('FLOATING ACTION BUTTONS'),
          Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FloatingActionButton.small(
                    heroTag: 'fab_sm',
                    onPressed: () {},
                    child: const Icon(Icons.add)),
                FloatingActionButton(
                    heroTag: 'fab_std',
                    onPressed: () {},
                    child: const Icon(Icons.edit_outlined)),
                FloatingActionButton.large(
                    heroTag: 'fab_lg',
                    onPressed: () {},
                    child: const Icon(Icons.create)),
                FloatingActionButton.extended(
                    heroTag: 'fab_ext',
                    onPressed: _showDialog,
                    icon: const Icon(Icons.post_add_outlined),
                    label: const Text('New Journal')),
              ]),

          // ── Segmented Button ───────────────────────────────────────────────
          _Sec('SEGMENTED BUTTON'),
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
            selected: {_tabIndex},
            onSelectionChanged: (s) => setState(() => _tabIndex = s.first),
          ),

          // ════════════════════════════════════════════════════════════════════
          // 5 · FORM FIELDS
          // ════════════════════════════════════════════════════════════════════
          _Sec('TEXT FIELDS'),
          const TextField(
            decoration: InputDecoration(
              labelText: 'NAME ENGLISH',
              hintText: 'e.g. Downtown Central Store',
              prefixIcon: Icon(Icons.business_outlined),
              helperText: 'Enter the official store name',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'ACCOUNT CODE',
              hintText: 'e.g. ACC-1001',
              prefixIcon: Icon(Icons.tag_outlined),
              errorText: 'Required field — cannot be empty',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'REFERENCE (DISABLED)',
              hintText: 'Auto-generated',
              prefixIcon: Icon(Icons.link_outlined),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'NOTES',
              hintText: 'Add internal notes about this entry…',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _dropdown,
            decoration: const InputDecoration(
              labelText: 'ACCOUNT TYPE',
              prefixIcon: Icon(Icons.account_tree_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'asset', child: Text('Asset')),
              DropdownMenuItem(value: 'liability', child: Text('Liability')),
              DropdownMenuItem(value: 'equity', child: Text('Equity')),
              DropdownMenuItem(value: 'income', child: Text('Income')),
              DropdownMenuItem(value: 'expense', child: Text('Expense')),
            ],
            onChanged: (v) => setState(() => _dropdown = v),
          ),
          const SizedBox(height: 12),
          // DropdownMenu (Material 3 variant)
          DropdownMenu<String>(
            width: double.infinity,
            hintText: 'Select currency…',
            label: const Text('CURRENCY'),
            leadingIcon: const Icon(Icons.currency_exchange_outlined),
            initialSelection: _menuValue,
            onSelected: (v) => setState(() => _menuValue = v),
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'usd', label: 'USD — US Dollar'),
              DropdownMenuEntry(value: 'eur', label: 'EUR — Euro'),
              DropdownMenuEntry(value: 'sar', label: 'SAR — Saudi Riyal'),
              DropdownMenuEntry(value: 'gbp', label: 'GBP — British Pound'),
            ],
          ),

          // ── Search Bar ─────────────────────────────────────────────────────
          _Sec('SEARCH BAR'),
          SearchBar(
            hintText: 'Search accounts, journals, contacts…',
            leading: const Icon(Icons.search),
            trailing: [
              IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
            ],
            onChanged: (_) {},
          ),

          // ════════════════════════════════════════════════════════════════════
          // 6 · SELECTION CONTROLS
          // ════════════════════════════════════════════════════════════════════
          _Sec('SELECTION CONTROLS'),
          SwitchListTile(
            title: const Text('Active Store'),
            subtitle: const Text('Store is open for transactions'),
            value: _switch1,
            onChanged: (v) => setState(() => _switch1 = v),
          ),
          SwitchListTile(
            title: const Text('Auto-reconcile'),
            subtitle: const Text('Run nightly reconciliation'),
            value: _switch2,
            onChanged: (v) => setState(() => _switch2 = v),
          ),
          CheckboxListTile(
            title: const Text('Post to General Ledger'),
            subtitle: const Text('Automatically post approved entries'),
            value: _check1,
            onChanged: (v) => setState(() => _check1 = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text('Require dual approval'),
            value: _check2,
            onChanged: (v) => setState(() => _check2 = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(height: 8),
          for (final (val, label) in [
            (1, 'Journal Entry'),
            (2, 'Payment Voucher'),
            (3, 'Adjustment')
          ])
            RadioListTile<int>(
              title: Text(label),
              value: val,
              groupValue: _radio,
              onChanged: (v) => setState(() => _radio = v!),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confidence Threshold  ${(_slider * 100).round()}%',
                    style: SuperText.label.copyWith(color: t.fg3)),
                Slider(
                    value: _slider,
                    onChanged: (v) => setState(() => _slider = v)),
                const SizedBox(height: 4),
                Text(
                    'Amount Range  ${(_range.start * 100).round()}k – ${(_range.end * 100).round()}k SAR',
                    style: SuperText.label.copyWith(color: t.fg3)),
                RangeSlider(
                  values: _range,
                  onChanged: (v) => setState(() => _range = v),
                ),
              ],
            ),
          ),

          // ════════════════════════════════════════════════════════════════════
          // 7 · CHIPS
          // ════════════════════════════════════════════════════════════════════
          _Sec('CHIPS'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            // Action chips
            ActionChip(
                label: const Text('Refresh'),
                avatar: const Icon(Icons.refresh, size: 16),
                onPressed: () {}),
            ActionChip(
                label: const Text('Export'),
                avatar: const Icon(Icons.download_outlined, size: 16),
                onPressed: () {}),
            // Filter chips
            FilterChip(
                label: const Text('Active'),
                selected: true,
                onSelected: (_) {}),
            FilterChip(
                label: const Text('Pending'),
                selected: false,
                onSelected: (_) {}),
            FilterChip(
                label: const Text('Archived'),
                selected: false,
                onSelected: (_) {}),
            // Input chips
            InputChip(label: const Text('Damascus Branch'), onDeleted: () {}),
            InputChip(label: const Text('Q4 2024'), onDeleted: () {}),
            // Suggestion chips (choice chips)
            ChoiceChip(
                label: const Text('This Month'),
                selected: true,
                onSelected: (_) {}),
            ChoiceChip(
                label: const Text('This Year'),
                selected: false,
                onSelected: (_) {}),
          ]),

          // ── Status Pills ───────────────────────────────────────────────────
          _Sec('STATUS PILLS'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _Pill('POSTED', SuperTokens.success, t),
            _Pill('PENDING', cs.primary, t),
            _Pill('DRAFT', SuperTokens.warning, t),
            _Pill('VOIDED', cs.error, t),
            _Pill('LOCKED', t.fg3, t),
            _Pill('APPROVED', SuperTokens.success, t),
            _Pill('REJECTED', cs.error, t),
          ]),

          // ════════════════════════════════════════════════════════════════════
          // 8 · CARDS
          // ════════════════════════════════════════════════════════════════════
          _Sec('CARD VARIANTS'),
          // Elevated
          Card(
            child: ListTile(
              leading: Icon(Icons.receipt_long_outlined, color: cs.primary),
              title: const Text('Elevated Card'),
              subtitle: const Text('Default card with shadow elevation'),
              trailing: Icon(Icons.chevron_right, color: t.fg3),
            ),
          ),
          const SizedBox(height: 8),
          // Filled
          Card(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: ListTile(
              leading: Icon(Icons.inventory_2_outlined, color: cs.primary),
              title: const Text('Filled Card'),
              subtitle: const Text('Filled surface variant'),
              trailing: Icon(Icons.chevron_right, color: t.fg3),
            ),
          ),
          const SizedBox(height: 8),
          // Outlined
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: ListTile(
              leading: Icon(Icons.account_balance_outlined, color: cs.primary),
              title: const Text('Outlined Card'),
              subtitle: const Text('Hairline border, no elevation'),
              trailing: Icon(Icons.chevron_right, color: t.fg3),
            ),
          ),
          const SizedBox(height: 8),
          // Section card (GeniusLink style)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Section Card',
                              style: SuperText.heading.copyWith(color: t.fg1)),
                          Text('GeniusLink 4 px marker bar — identity',
                              style: SuperText.caption.copyWith(color: t.fg3)),
                        ]),
                  ]),
                  Divider(height: 28, color: t.border),
                  Text(
                      'The 4 px vertical pill is the most distinctive GeniusLink visual device. '
                      'Blue = identity, green = ledger, orange = notes.',
                      style: SuperText.body.copyWith(color: t.fg2)),
                ],
              ),
            ),
          ),

          // ════════════════════════════════════════════════════════════════════
          // 9 · LIST TILES
          // ════════════════════════════════════════════════════════════════════
          _Sec('LIST TILES'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: Column(children: [
              ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.person_outline, size: 18)),
                title: const Text('Ahmad Al-Rashid'),
                subtitle: const Text('Senior Accountant • Finance'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(Icons.store_outlined, color: cs.primary),
                title: const Text('Downtown Central Store'),
                subtitle: const Text('Store ID: STR-0042 • Active'),
                trailing: _Pill('ACTIVE', SuperTokens.success, t),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(Icons.warning_amber_outlined,
                    color: SuperTokens.warning),
                title: const Text('Pending Reconciliation'),
                subtitle: const Text('3 entries require review before closing'),
                isThreeLine: false,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                title: const Text('Disabled Tile'),
                subtitle: const Text('This tile is not interactive'),
                leading: Icon(Icons.lock_outline, color: t.fg4),
                enabled: false,
              ),
            ]),
          ),

          // ── Expansion Tile ─────────────────────────────────────────────────
          _Sec('EXPANSION TILE'),
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: Column(children: [
              ExpansionTile(
                leading: Icon(Icons.folder_outlined, color: cs.primary),
                title: const Text('Current Assets'),
                subtitle: const Text('4 accounts · SAR 17,640.00'),
                children: [
                  for (final (code, name, bal) in [
                    ('1001', 'Cash & Equivalents', '+12,400.00'),
                    ('1002', 'Accounts Receivable', '+5,240.00'),
                  ])
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 0),
                      title: Text(name),
                      leading: Text(code,
                          style: SuperText.mono
                              .copyWith(color: t.fg3, fontSize: 11)),
                      trailing: Text(bal,
                          style: SuperText.mono.copyWith(
                              color: SuperTokens.success, fontSize: 12)),
                    ),
                ],
              ),
              const Divider(height: 1),
              ExpansionTile(
                leading:
                    Icon(Icons.folder_outlined, color: SuperTokens.warning),
                title: const Text('Current Liabilities'),
                subtitle: const Text('2 accounts · SAR 3,800.00'),
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                    title: const Text('Short-term Payables'),
                    trailing: Text('-3,800.00',
                        style: SuperText.mono
                            .copyWith(color: cs.error, fontSize: 12)),
                  ),
                ],
              ),
            ]),
          ),

          // ════════════════════════════════════════════════════════════════════
          // 10 · NAVIGATION PREVIEWS
          // ════════════════════════════════════════════════════════════════════
          _Sec('NAVIGATION RAIL (PREVIEW)'),
          _NavRailPreview(cs: cs, t: t),

          _Sec('TAB BAR'),
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant)),
            child: Column(children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.receipt_outlined), text: 'Journals'),
                  Tab(
                      icon: Icon(Icons.account_balance_wallet_outlined),
                      text: 'Accounts'),
                  Tab(icon: Icon(Icons.bar_chart_outlined), text: 'Reports'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  [
                    'Journal entries list view',
                    'Chart of accounts',
                    'Financial reports'
                  ][_tabIndex],
                  style: SuperText.body.copyWith(color: t.fg2),
                ),
              ),
            ]),
          ),

          // ════════════════════════════════════════════════════════════════════
          // 11 · OVERLAYS
          // ════════════════════════════════════════════════════════════════════
          _Sec('OVERLAYS'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            // Dialog
            OutlinedButton.icon(
              onPressed: _showDialog,
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Alert Dialog'),
            ),
            // Bottom Sheet
            OutlinedButton.icon(
              onPressed: _showBottomSheet,
              icon: const Icon(Icons.expand_less, size: 16),
              label: const Text('Modal Bottom Sheet'),
            ),
            // Snackbar
            OutlinedButton.icon(
              onPressed: _showSnackBar,
              icon: const Icon(Icons.info_outline, size: 16),
              label: const Text('Snack Bar'),
            ),
            // Drawer
            Builder(
                builder: (ctx) => OutlinedButton.icon(
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                      icon: const Icon(Icons.menu, size: 16),
                      label: const Text('Navigation Drawer'),
                    )),
            // End Drawer
            Builder(
                builder: (ctx) => OutlinedButton.icon(
                      onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                      icon: const Icon(Icons.settings_outlined, size: 16),
                      label: const Text('End Drawer'),
                    )),
            // Popup Menu
            PopupMenuButton<String>(
              child: OutlinedButton.icon(
                onPressed: null,
                icon: Icon(Icons.more_horiz, size: 16),
                label: Text('Popup Menu'),
              ),
              onSelected: (_) {},
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'))),
                const PopupMenuItem(
                    value: 'dup',
                    child: ListTile(
                        leading: Icon(Icons.copy_outlined),
                        title: Text('Duplicate'))),
                const PopupMenuDivider(),
                PopupMenuItem(
                    value: 'del',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: cs.error),
                      title: Text('Delete', style: TextStyle(color: cs.error)),
                    )),
              ],
            ),
            // Menu Anchor
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                    leadingIcon: const Icon(Icons.print_outlined),
                    child: const Text('Print'),
                    onPressed: () {}),
                MenuItemButton(
                    leadingIcon: const Icon(Icons.share_outlined),
                    child: const Text('Share'),
                    onPressed: () {}),
                MenuItemButton(
                    leadingIcon: const Icon(Icons.download_outlined),
                    child: const Text('Download'),
                    onPressed: () {}),
              ],
              builder: (ctx, controller, _) => OutlinedButton.icon(
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                icon: const Icon(Icons.arrow_drop_down, size: 16),
                label: const Text('Menu Anchor'),
              ),
            ),
          ]),

          // ── Tooltip ────────────────────────────────────────────────────────
          _Sec('TOOLTIPS'),
          Wrap(spacing: 12, children: [
            Tooltip(
              message: 'Post journal entry to the ledger',
              child:
                  FilledButton(onPressed: () {}, child: const Text('Hover Me')),
            ),
            Tooltip(
              message: 'View full audit trail',
              preferBelow: false,
              child:
                  IconButton(icon: const Icon(Icons.history), onPressed: () {}),
            ),
            Tooltip(
              message: 'Download supporting documents',
              child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined, size: 16),
                  label: const Text('With Tooltip')),
            ),
          ]),

          // ── Badges ─────────────────────────────────────────────────────────
          _Sec('BADGES'),
          Wrap(
              spacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Badge(
                    child: const Icon(Icons.notifications_outlined, size: 28)),
                Badge(
                    label: const Text('3'),
                    child: const Icon(Icons.mail_outline, size: 28)),
                Badge(
                    label: const Text('12'),
                    child: const Icon(Icons.shopping_cart_outlined, size: 28)),
                Badge(
                  label: Text('99+',
                      style: SuperText.pill
                          .copyWith(color: cs.onError, fontSize: 9)),
                  child: const Icon(Icons.inbox_outlined, size: 28),
                ),
              ]),

          // ════════════════════════════════════════════════════════════════════
          // 12 · PROGRESS INDICATORS
          // ════════════════════════════════════════════════════════════════════
          _Sec('PROGRESS INDICATORS'),
          Row(children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(value: 0.72, strokeWidth: 4),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sync progress  72%',
                        style: SuperText.label.copyWith(color: t.fg3)),
                    const SizedBox(height: 6),
                    const LinearProgressIndicator(value: 0.72),
                    const SizedBox(height: 12),
                    Text('Loading…',
                        style: SuperText.label.copyWith(color: t.fg3)),
                    const SizedBox(height: 6),
                    const LinearProgressIndicator(),
                  ]),
            ),
          ]),

          // ════════════════════════════════════════════════════════════════════
          // 13 · DIVIDERS
          // ════════════════════════════════════════════════════════════════════
          _Sec('DIVIDERS'),
          const Divider(),
          const SizedBox(height: 4),
          const Divider(indent: 16, endIndent: 16, thickness: 2),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(
                child: Text('Left content',
                    style: SuperText.body.copyWith(color: t.fg2))),
            const SizedBox(height: 32, child: VerticalDivider()),
            Expanded(
                child: Text('Right content',
                    style: SuperText.body.copyWith(color: t.fg2))),
            const SizedBox(height: 32, child: VerticalDivider()),
            Expanded(
                child: Text('Third content',
                    style: SuperText.body.copyWith(color: t.fg2))),
          ]),

          // ════════════════════════════════════════════════════════════════════
          // 14 · DATA TABLE
          // ════════════════════════════════════════════════════════════════════
          _Sec('DATA TABLE'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text('#',
                        style: SuperText.mono.copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('ACCOUNT',
                        style: SuperText.label.copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('TYPE',
                        style: SuperText.label.copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('NATURE',
                        style: SuperText.label.copyWith(color: t.fg3))),
                DataColumn(
                    label: Text('BALANCE',
                        style: SuperText.label.copyWith(color: t.fg3)),
                    numeric: true),
              ],
              rows: [
                _row(cs, t, '1', 'Cash & Equivalents', 'Asset', 'DR',
                    '+\$12,400.00'),
                _row(cs, t, '2', 'Accounts Receivable', 'Asset', 'DR',
                    '+\$5,240.00'),
                _row(cs, t, '3', 'Short-term Liabilities', 'Liability', 'CR',
                    '-\$3,800.00'),
                _row(cs, t, '4', 'Retained Earnings', 'Equity', 'CR',
                    '+\$13,840.00'),
              ],
            ),
          ),

          // ════════════════════════════════════════════════════════════════════
          // 15 · TYPOGRAPHY
          // ════════════════════════════════════════════════════════════════════
          _Sec('SUPER TEXT STYLES'),
          for (final r in [
            ('h1 — Manrope 26 / 700', SuperText.h1, t.fg1),
            ('heading — Inter 16 / 700', SuperText.heading, t.fg1),
            ('body — Inter 14 / 400', SuperText.body, t.fg1),
            ('button — Inter 14 / 600', SuperText.button, t.fg1),
            ('label — Inter 11 / 700 CAPS', SuperText.label, t.fg2),
            ('caption — Inter 12 / 400', SuperText.caption, t.fg3),
            ('mono — JetBrains 14 / 400', SuperText.mono, t.fg1),
            ('eyebrow — 11 / 700 WIDE', SuperText.eyebrow, t.fg3),
            ('pill — 10 / 700', SuperText.pill, cs.primary),
          ])
            _TypeRow(r.$1, r.$2, r.$3),

          _Sec('MATERIAL TEXT THEME'),
          for (final r in [
            ('displaySmall', Theme.of(context).textTheme.displaySmall),
            ('headlineMedium', Theme.of(context).textTheme.headlineMedium),
            ('titleLarge', Theme.of(context).textTheme.titleLarge),
            ('titleMedium', Theme.of(context).textTheme.titleMedium),
            ('bodyLarge', Theme.of(context).textTheme.bodyLarge),
            ('bodyMedium', Theme.of(context).textTheme.bodyMedium),
            ('bodySmall', Theme.of(context).textTheme.bodySmall),
            ('labelLarge', Theme.of(context).textTheme.labelLarge),
            ('labelSmall', Theme.of(context).textTheme.labelSmall),
          ])
            if (r.$2 != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(children: [
                  Expanded(flex: 3, child: Text('Aa', style: r.$2)),
                  Expanded(
                      flex: 5,
                      child: Text(r.$1,
                          style: SuperText.caption.copyWith(color: t.fg4))),
                ]),
              ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── Drawer ──────────────────────────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context, ColorScheme cs, SuperThemeData t) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 28,
                        backgroundColor: cs.primaryContainer,
                        child: Icon(Icons.account_balance,
                            color: cs.primary, size: 28)),
                    const SizedBox(height: 12),
                    Text('GeniusLink ERP',
                        style: SuperText.heading.copyWith(color: t.fg1)),
                    Text('Precision System v1.0',
                        style: SuperText.caption.copyWith(color: t.fg3)),
                  ]),
            ),
            const Divider(),
            for (final (icon, label, sel) in [
              (Icons.dashboard_outlined, 'Dashboard', true),
              (Icons.receipt_long_outlined, 'Journal Entries', false),
              (Icons.account_tree_outlined, 'Chart of Accounts', false),
              (Icons.inventory_2_outlined, 'Inventory', false),
              (Icons.people_outline, 'Contacts', false),
              (Icons.bar_chart_outlined, 'Reports', false),
            ])
              ListTile(
                leading: Icon(icon, color: sel ? cs.primary : t.fg3),
                title: Text(label,
                    style: SuperText.body.copyWith(
                        color: sel ? cs.primary : t.fg1,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                selected: sel,
                selectedTileColor: cs.primary.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onTap: () => Navigator.pop(context),
              ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: t.fg3),
              title: Text('Settings',
                  style: SuperText.body.copyWith(color: t.fg1)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDrawer(
      BuildContext context, ColorScheme cs, SuperThemeData t) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(children: [
                Expanded(
                    child: Text('Settings',
                        style: SuperText.heading.copyWith(color: t.fg1))),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
              ]),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: widget.themeMode == ThemeMode.dark,
              onChanged: (v) => widget
                  .onThemeModeChanged(v ? ThemeMode.dark : ThemeMode.light),
            ),
            SwitchListTile(
                title: const Text('Compact Density'),
                value: false,
                onChanged: (_) {}),
            SwitchListTile(
                title: const Text('RTL Layout'),
                value: false,
                onChanged: (_) {}),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('PALETTE',
                  style: SuperText.eyebrow.copyWith(color: t.fg4)),
            ),
            const SizedBox(height: 8),
            ...SuperPalette.values.map((p) => ListTile(
                  leading:
                      CircleAvatar(backgroundColor: p.shade500, radius: 10),
                  title: Text(p.name),
                  trailing: widget.selectedPalette.name == p.name
                      ? Icon(Icons.check, color: cs.primary, size: 18)
                      : null,
                  onTap: () {
                    widget.onPaletteChanged(p);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  // ── Table row helper ─────────────────────────────────────────────────────────

  DataRow _row(ColorScheme cs, SuperThemeData t, String n, String name,
      String type, String nature, String bal) {
    final neg = bal.startsWith('-');
    final typeColor = type == 'Asset'
        ? SuperTokens.success
        : type == 'Liability'
            ? cs.error
            : cs.primary;
    final natureColor = nature == 'DR' ? cs.primary : SuperTokens.warning;
    return DataRow(cells: [
      DataCell(Text(n, style: SuperText.mono.copyWith(color: t.fg3))),
      DataCell(Text(name, style: SuperText.body.copyWith(color: t.fg1))),
      DataCell(_Pill(type.toUpperCase(), typeColor, t)),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: natureColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(nature,
            style: SuperText.mono.copyWith(color: natureColor, fontSize: 11)),
      )),
      DataCell(Text(bal,
          style: SuperText.mono
              .copyWith(color: neg ? cs.error : SuperTokens.success))),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Helper widgets
// ══════════════════════════════════════════════════════════════════════════════

class _ThemeModeBtn extends StatelessWidget {
  const _ThemeModeBtn(this.mode, this.current, this.icon, this.tip, this.onTap);
  final ThemeMode mode, current;
  final IconData icon;
  final String tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sel = mode == current;
    final cs = Theme.of(context).colorScheme;
    return IconButton(
        icon: Icon(icon, size: 20),
        color: sel ? cs.primary : null,
        onPressed: onTap,
        tooltip: tip);
  }
}

/// Section label eyebrow with top spacing.
class _Sec extends StatelessWidget {
  const _Sec(this.text);
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

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.color, this.t);
  final String label;
  final Color color;
  final SuperThemeData t;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: t.tintFill(color, 0.14),
          borderRadius: BorderRadius.circular(SuperTokens.radiusPill),
        ),
        child: Text(label, style: SuperText.pill.copyWith(color: color)),
      );
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
      child: Row(children: [
        Expanded(
            flex: 2, child: Text('Aa', style: style.copyWith(color: color))),
        Expanded(
            flex: 5,
            child: Text(name, style: SuperText.caption.copyWith(color: t.fg4))),
      ]),
    );
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
          final fg = color.computeLuminance() > 0.35
              ? const Color(0xFF0F172A)
              : const Color(0xFFFFFFFF);
          return Expanded(
            child: Tooltip(
              message:
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
              child: Container(
                height: 56,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 4),
                color: color,
                child:
                    Text('$label', style: SuperText.pill.copyWith(color: fg)),
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
      ('primaryContainer', cs.primaryContainer, cs.onPrimaryContainer),
      ('onPrimaryContainer', cs.onPrimaryContainer, cs.primaryContainer),
      ('secondary', cs.secondary, cs.onSecondary),
      ('onSecondary', cs.onSecondary, cs.secondary),
      ('tertiary', cs.tertiary, cs.onTertiary),
      ('onTertiary', cs.onTertiary, cs.tertiary),
      ('error', cs.error, cs.onError),
      ('onError', cs.onError, cs.error),
      ('errorContainer', cs.errorContainer, cs.onErrorContainer),
      ('surface', cs.surface, cs.onSurface),
      ('onSurface', cs.onSurface, cs.surface),
      ('surfaceVariant', cs.surfaceVariant, cs.onSurfaceVariant),
      ('outline', cs.outline, cs.surface),
      ('outlineVariant', cs.outlineVariant, cs.onSurface),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles.map((r) {
        final (name, bg, fg) = r;
        return Container(
          width: 132,
          height: 52,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          padding: const EdgeInsets.all(7),
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

class _AppBarPreview extends StatelessWidget {
  const _AppBarPreview({
    required this.title,
    required this.subtitle,
    required this.cs,
    required this.t,
    this.showSearch = false,
  });
  final String title, subtitle;
  final ColorScheme cs;
  final SuperThemeData t;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side:
              BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      child: Column(
        children: [
          Container(
            height: 56,
            color: t.surface,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(children: [
              IconButton(
                  icon: const Icon(Icons.menu, size: 20), onPressed: () {}),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(subtitle,
                        style: SuperText.eyebrow
                            .copyWith(color: cs.primary, fontSize: 9)),
                    Text(title,
                        style: SuperText.heading
                            .copyWith(color: t.fg1, fontSize: 14)),
                  ],
                ),
              ),
              if (showSearch)
                IconButton(
                    icon: const Icon(Icons.search, size: 20), onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 20),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.account_circle_outlined, size: 20),
                  onPressed: () {}),
            ]),
          ),
          Divider(height: 1, color: t.border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              Icon(Icons.info_outline, size: 14, color: t.fg4),
              const SizedBox(width: 6),
              Text('App bar preview — not interactive',
                  style:
                      SuperText.caption.copyWith(color: t.fg4, fontSize: 11)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _NavRailPreview extends StatefulWidget {
  const _NavRailPreview({required this.cs, required this.t});
  final ColorScheme cs;
  final SuperThemeData t;

  @override
  State<_NavRailPreview> createState() => _NavRailPreviewState();
}

class _NavRailPreviewState extends State<_NavRailPreview> {
  int _sel = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side:
              BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      child: SizedBox(
        height: 240,
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _sel,
              onDestinationSelected: (i) => setState(() => _sel = i),
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text('Dashboard')),
                NavigationRailDestination(
                    icon: Icon(Icons.receipt_outlined),
                    selectedIcon: Icon(Icons.receipt),
                    label: Text('Journals')),
                NavigationRailDestination(
                    icon: Icon(Icons.account_tree_outlined),
                    selectedIcon: Icon(Icons.account_tree),
                    label: Text('Accounts')),
                NavigationRailDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: Text('Reports')),
              ],
            ),
            VerticalDivider(width: 1, color: widget.t.border),
            Expanded(
              child: Center(
                child: Text(
                  [
                    'Dashboard view',
                    'Journal entries',
                    'Chart of accounts',
                    'Reports'
                  ][_sel],
                  style: SuperText.body.copyWith(color: widget.t.fg3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
