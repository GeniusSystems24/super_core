// ============================================================
// create_account_screen.dart
// ------------------------------------------------------------
// A recreation of the GeniusLink mobile "Create Account" form built ONLY from
// super_core tools — no bespoke card chrome, no hand-tuned insets:
//
//   SuperAppBar               close / title / confirm
//   SuperSectionCard2             the card shell (compact padding + section gap)
//   SuperSectionHeader.style2 marker bar + ALL-CAPS section title
//   FieldShell                label (+ required asterisk) → control → hint
//   SuperThemeData            surfaces, fg ramp, responsive metrics
//
// Every inset on this screen comes from the theme's SuperMetrics
// (`t.padding.page`, `t.padding.field`, `t.spacing.section`, …), so the whole
// screen retunes its density from one theme override.
// ============================================================

import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

/// The compact GeniusLink account-creation form.
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _debit = true;
  bool _mainAccount = true;
  String _group = 'Current Assets';

  static const _groups = <String>[
    'Current Assets',
    'Fixed Assets',
    'Liabilities',
    'Equity',
    'Revenue',
    'Expenses',
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: SuperAppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Discard',
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Create Account'),
        subtitle: const Text('نموذج حساب يدعم العربية'),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: cs.primary),
            tooltip: 'Save account',
            onPressed: () => SuperSnackBar.success(context, 'Account saved'),
          ),
        ],
      ),
      body: ListView(
        padding: t.spacing.pagePadding,
        children: [
          // ── ACCOUNT DETAILS ────────────────────────────────────────────────
          SuperSectionCard2(
            title: 'Account Details',
            collapsible: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FieldShell(
                  label: 'Account type',
                  required: true,
                  child: _Segmented(
                    options: const ['Debit', 'Credit'],
                    selectedIndex: _debit ? 0 : 1,
                    onChanged: (i) => setState(() => _debit = i == 0),
                  ),
                ),
                SizedBox(height: t.spacing.md),
                FieldShell(
                  label: 'Account group',
                  child: _SelectBox(
                    value: _group,
                    options: _groups,
                    onChanged: (v) => setState(() => _group = v),
                  ),
                ),
                SizedBox(height: t.spacing.md),
                const FieldShell(
                  label: 'Parent account',
                  child: _InputBox(
                    hint: 'Search accounts…',
                    leadingIcon: Icons.search,
                  ),
                ),
                SizedBox(height: t.spacing.md),
                const FieldShell(
                  label: 'Name (Arabic)',
                  required: true,
                  child: _InputBox(
                    hint: 'مثال: صندوق النقدية',
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(height: t.spacing.md),
                const FieldShell(
                  label: 'Name (English)',
                  required: true,
                  child: _InputBox(hint: 'e.g. Cash Box'),
                ),
                SizedBox(height: t.spacing.md),
                _ToggleRow(
                  label: 'Main account',
                  value: _mainAccount,
                  onChanged: (v) => setState(() => _mainAccount = v),
                ),
              ],
            ),
          ),
          SizedBox(height: t.spacing.section),

          // ── ARABIC ACCOUNT DETAILS ─────────────────────────────────────────
          Directionality(
            textDirection: TextDirection.rtl,
            child: SuperSectionCard2(
              title: 'بيانات الحساب بالعربية',
              subtitle: 'حقول عربية ومحاذاة RTL',
              icon: Icons.translate_outlined,
              collapsible: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldShell(
                    label: 'نوع الحساب',
                    required: true,
                    child: _Segmented(
                      options: const ['مدين', 'دائن'],
                      selectedIndex: _debit ? 0 : 1,
                      onChanged: (i) => setState(() => _debit = i == 0),
                    ),
                  ),
                  SizedBox(height: t.spacing.md),
                  const FieldShell(
                    label: 'اسم الحساب',
                    required: true,
                    child: _InputBox(
                      hint: 'مثال: صندوق النقدية',
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  SizedBox(height: t.spacing.md),
                  const FieldShell(
                    label: 'ملاحظات',
                    child: _InputBox(
                      hint: 'أضف ملاحظة مختصرة عن هذا الحساب',
                      textDirection: TextDirection.rtl,
                      minLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: t.spacing.section),

          // ── USER RELATIONSHIP (drills down) ────────────────────────────────
          const SuperSectionCard2(
            title: 'User Relationship',
            trailing: Icon(Icons.chevron_right),
            collapsible: false,
            padding: EdgeInsets.zero,
            child: SizedBox.shrink(),
          ),
          SizedBox(height: t.spacing.section),

          // ── ADDITIONAL INFORMATION ─────────────────────────────────────────
          SuperSectionCard2(
            title: 'Additional Information',
            accentColor: SuperMarker.notes.resolve(t.tokens),
            collapsible: false,
            child: const FieldShell(
              label: 'Note',
              child: _InputBox(
                hint: 'Add notes about this account…',
                minLines: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Controls — thin wrappers over the theme's input surface. FieldShell owns the
// label / hint chrome; these own only the control box.
// ════════════════════════════════════════════════════════════════════════════

/// The shared control box: `inputBg` fill, control radius, field padding and
/// the responsive comfortable field height.
class _ControlBox extends StatelessWidget {
  const _ControlBox({required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.spacing;

    return Container(
      height: height ?? k.controlHeight,
      padding: EdgeInsets.symmetric(horizontal: k.space4),
      alignment: AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
        color: t.inputBg,
        borderRadius: BorderRadius.circular(k.radiusControl),
        border: Border.all(color: t.border),
      ),
      child: child,
    );
  }
}

/// Two-up segmented selector — the active half fills with the accent.
class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.spacing;
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: t.sizing.fieldComfortable,
      decoration: BoxDecoration(
        color: t.inputBg,
        borderRadius: BorderRadius.circular(k.radiusControl),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: t.tokens.durBase,
                  curve: t.tokens.curveStandard,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selectedIndex ? cs.primary : null,
                    borderRadius: BorderRadius.circular(k.radiusControl),
                  ),
                  child: Text(
                    options[i].toUpperCase(),
                    style: t.textTheme.label.copyWith(
                      color: i == selectedIndex ? cs.onPrimary : t.fg2,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Read-only value box with a chevron — opens the theme-styled dropdown menu.
class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return PopupMenuButton<String>(
      tooltip: '',
      position: PopupMenuPosition.under,
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final o in options) PopupMenuItem(value: o, child: Text(o)),
      ],
      child: _ControlBox(
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: t.textTheme.body.copyWith(color: t.fg1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: t.fg2),
          ],
        ),
      ),
    );
  }
}

/// Single- or multi-line text input on the shared control surface.
class _InputBox extends StatelessWidget {
  const _InputBox({
    this.hint,
    this.leadingIcon,
    this.minLines,
    this.textDirection,
  });

  final String? hint;
  final IconData? leadingIcon;
  final int? minLines;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.spacing;
    final multiline = (minLines ?? 1) > 1;

    final field = TextField(
      textDirection: textDirection,
      minLines: minLines,
      maxLines: multiline ? (minLines! + 2) : 1,
      style: t.textTheme.body.copyWith(color: t.fg1),
      decoration: InputDecoration(
        isCollapsed: true,
        filled: false,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: t.textTheme.caption.copyWith(color: t.fg4),
        prefixIcon: leadingIcon == null ? null : Icon(leadingIcon, size: 18),
        prefixIconConstraints: const BoxConstraints(minWidth: 26),
        prefixIconColor: t.fg2,
      ),
    );

    return _ControlBox(
      height: multiline ? null : k.controlHeight,
      child: field,
    );
  }
}

/// ALL-CAPS label + brand switch, on one compact row.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: t.textTheme.label.copyWith(color: t.fg1, fontSize: 12.5),
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
