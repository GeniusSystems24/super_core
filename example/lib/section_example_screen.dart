import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

/// Dedicated examples for the Super section component family.
class SectionExampleScreen extends StatefulWidget {
  const SectionExampleScreen({super.key});

  @override
  State<SectionExampleScreen> createState() => _SectionExampleScreenState();
}

class _SectionExampleScreenState extends State<SectionExampleScreen> {
  bool _selected = true;
  bool _controlledExpanded = true;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: t.bg,
      appBar: SuperAppBar(
        title: const Text('Section Components'),
        subtitle: const Text('SUPER CORE - v3.0.0'),
        subtitleTextStyle: t.textTheme.eyebrow.copyWith(
          color: colorScheme.primary,
        ),
      ),
      body: SuperScaffold(
        maxWidth: 1120,
        backgroundColor: t.bg,
        child: ListView(
          padding: EdgeInsets.only(bottom: t.spacing.space12),
          children: [
            const _BlockHeader(
              title: 'Generated Section Card Headers',
              subtitle: 'Default, leading, trailing, and style2 variants',
            ),
            SizedBox(height: t.spacing.space4),
            SuperGrid(
              scope: SuperGridScope.current,
              children: [
                const SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Default Title Header',
                    subtitle: 'Legacy SectionCard title row',
                    marker: SuperMarker.identity,
                    icon: Icons.badge_outlined,
                    leading: Icon(Icons.person_outline),
                    headerTrailing: StatusPill(
                      'READY',
                      tone: PillTone.success,
                    ),
                    children: [
                      _InfoRow('Account code', '100-0042'),
                      _InfoRow('Posting policy', 'Manual review'),
                    ],
                  ),
                ),
                SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Style2 Header',
                    subtitle: 'Compact marker tab and icon chip',
                    marker: SuperMarker.ledger,
                    icon: Icons.account_balance_wallet_outlined,
                    headerStyle: SuperSectionHeaderStyle.style2,
                    headerTrailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                    child: const _InlineNote(
                      'Use style2 for dense setup screens and clickable rows.',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.section),
            const _BlockHeader(
              title: 'SuperSectionHeader',
              subtitle: 'Standalone style1 and style2 headers',
            ),
            SizedBox(height: t.spacing.space4),
            const SuperGrid(
              scope: SuperGridScope.current,
              children: [
                SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: _SurfaceBlock(
                    child: SuperSectionHeader(
                      title: 'Identity Details',
                      titleArabic: 'Identity',
                      subtitle: 'Customer profile and account metadata',
                      eyebrow: 'CUSTOMER',
                      marker: SuperMarker.identity,
                      icon: Icons.perm_identity_outlined,
                      trailing: StatusPill('OPEN', tone: PillTone.info),
                    ),
                  ),
                ),
                SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: _SurfaceBlock(
                    child: SuperSectionHeader(
                      style: SuperSectionHeaderStyle.style2,
                      title: 'Ledger Balance',
                      subtitle: 'Opening totals carried into the period',
                      marker: SuperMarker.ledger,
                      leading: Icon(Icons.account_balance_outlined),
                      trailing: Icon(Icons.expand_more),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.section),
            const _BlockHeader(
              title: 'Footer Components',
              subtitle: 'Built-in footer fields and prebuilt footer widgets',
            ),
            SizedBox(height: t.spacing.space4),
            SuperGrid(
              scope: SuperGridScope.current,
              children: [
                const SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Footer From Convenience Fields',
                    subtitle: 'footerBrand + footerActions',
                    marker: SuperMarker.notes,
                    icon: Icons.description_outlined,
                    footerBrand: 'GeniusLink ERP - draft state',
                    footerActions: [
                      SuperFooterLink('Preview'),
                      SuperFooterLink('Validate', emphasized: true),
                    ],
                    child: _InlineNote(
                      'The card composes SuperSectionFooter automatically.',
                    ),
                  ),
                ),
                SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Prebuilt SuperSectionFooter',
                    subtitle: 'Custom footer instance',
                    marker: SuperMarker.identity,
                    icon: Icons.rule_folder_outlined,
                    footer: SuperSectionFooter(
                      brand: 'audit status: complete',
                      actions: [
                        SuperFooterLink('History', onTap: () {}),
                        SuperFooterLink(
                          'Approve',
                          emphasized: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                    child: const _InlineNote(
                      'Pass footer when the footer needs custom callbacks.',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.section),
            const _BlockHeader(
              title: 'Expansion Patterns',
              subtitle: 'Collapsible sections and expandable detail content',
            ),
            SizedBox(height: t.spacing.space4),
            SuperGrid(
              scope: SuperGridScope.current,
              children: [
                SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Controlled Collapsible Section',
                    subtitle: _controlledExpanded ? 'Expanded' : 'Collapsed',
                    marker: SuperMarker.ledger,
                    icon: Icons.unfold_more,
                    collapsible: true,
                    isExpanded: _controlledExpanded,
                    onExpansionChanged: (value) =>
                        setState(() => _controlledExpanded = value),
                    headerTrailing: StatusPill(
                      _controlledExpanded ? 'VISIBLE' : 'HIDDEN',
                      tone: _controlledExpanded
                          ? PillTone.success
                          : PillTone.neutral,
                    ),
                    children: const [
                      _InfoRow('Debit', 'SAR 12,450.00'),
                      _InfoRow('Credit', 'SAR 12,450.00'),
                      _InfoRow('Difference', 'SAR 0.00'),
                    ],
                  ),
                ),
                const SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Expandable Details',
                    subtitle: 'Tap card to reveal supporting content',
                    marker: SuperMarker.notes,
                    icon: Icons.open_in_full,
                    expandedChild: _DetailPanel(),
                    child: _InlineNote('Primary row remains visible.'),
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.section),
            const _BlockHeader(
              title: 'Card Surface Options',
              subtitle: 'Selected, divider, plain, and custom header states',
            ),
            SizedBox(height: t.spacing.space4),
            SuperGrid(
              scope: SuperGridScope.current,
              children: [
                SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    selected: _selected,
                    onTap: () => setState(() => _selected = !_selected),
                    title: 'Selectable Section Card',
                    subtitle: _selected ? 'Selected border active' : 'Tap card',
                    marker: SuperMarker.identity,
                    icon: Icons.check_circle_outline,
                    headerTrailing: StatusPill(
                      _selected ? 'SELECTED' : 'NORMAL',
                      tone: _selected ? PillTone.accent : PillTone.neutral,
                    ),
                    child: const _InlineNote(
                      'Selection blends an accent tint over the card surface.',
                    ),
                  ),
                ),
                const SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    title: 'Divider After Header',
                    subtitle: 'Hairline between heading and body',
                    marker: SuperMarker.ledger,
                    icon: Icons.horizontal_rule,
                    dividerAfterHeader: true,
                    children: [
                      _InfoRow('Section gap', 'Theme controlled'),
                      _InfoRow('Body gap', 'children + gap'),
                    ],
                  ),
                ),
                const SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    card: false,
                    title: 'Plain Section Layout',
                    subtitle: 'No surrounding card surface',
                    marker: SuperMarker.notes,
                    icon: Icons.layers_clear_outlined,
                    child: _InlineNote(
                      'Use card: false inside already framed content.',
                    ),
                  ),
                ),
                const SuperGridCell(
                  mobile: 4,
                  tablet: 8,
                  desktop: 6,
                  child: SuperSectionCard(
                    header: SuperSectionHeader(
                      style: SuperSectionHeaderStyle.style2,
                      title: 'Custom Header Slot',
                      subtitle: 'header overrides generated title fields',
                      marker: SuperMarker.identity,
                      icon: Icons.tune,
                      trailing: StatusPill('CUSTOM', tone: PillTone.warning),
                    ),
                    child: _InlineNote(
                      'Pass header for full control over header composition.',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.section),
            const _BlockHeader(
              title: 'Supporting Section Pieces',
              subtitle: 'Hairline and footer links used outside cards',
            ),
            SizedBox(height: t.spacing.space4),
            const _SurfaceBlock(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SuperSectionHeader(
                    title: 'Standalone Composition',
                    subtitle: 'Header, body, Hairline, and footer',
                    marker: SuperMarker.notes,
                    icon: Icons.view_stream_outlined,
                  ),
                  SizedBox(height: 16),
                  _InlineNote('Build unframed section stacks with the pieces.'),
                  SizedBox(height: 16),
                  Hairline(),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      SuperFooterLink('Terms'),
                      SuperFooterLink('Docs'),
                      SuperFooterLink('Save', emphasized: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockHeader extends StatelessWidget {
  const _BlockHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SuperSectionHeader(
      style: SuperSectionHeaderStyle.style2,
      title: title,
      subtitle: subtitle,
      marker: SuperMarker.identity,
      icon: Icons.view_agenda_outlined,
    );
  }
}

class _SurfaceBlock extends StatelessWidget {
  const _SurfaceBlock({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: t.spacing.cardBorderRadius,
        border: Border.all(color: t.border),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: t.textTheme.body.copyWith(color: t.fg3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: t.spacing.space3),
        Text(
          value,
          style: t.textTheme.mono.copyWith(color: t.fg1),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _InlineNote extends StatelessWidget {
  const _InlineNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Text(
      text,
      style: t.textTheme.body.copyWith(color: t.fg2),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel();

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Container(
      width: double.infinity,
      padding: t.spacing.compactCardPadding,
      decoration: BoxDecoration(
        color: t.inputBg,
        borderRadius: t.spacing.borderRadiusMd,
        border: Border.all(color: t.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow('Document', 'JV-2026-0042'),
          SizedBox(height: 8),
          _InfoRow('Reviewer', 'Finance lead'),
        ],
      ),
    );
  }
}
