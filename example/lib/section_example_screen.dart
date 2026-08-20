// GENERATED DOCS-LAYOUT MIGRATION: super_core example docs v1
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'arabic_examples.dart';
/// Dedicated examples for the Super section component family.
class SectionExampleScreen extends StatefulWidget {
  const SectionExampleScreen({super.key});

  @override
  State<SectionExampleScreen> createState() => _SectionExampleScreenState();
}

class _SectionExampleScreenState extends State<SectionExampleScreen> {
  bool _selected = true;
  bool _controlledExpanded = true;
  bool _card1Expanded = true;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SuperExampleDocsPage(
      title: 'Section Components',
      subtitle: 'SUPER CORE · v3.5.0',
      description:
          'Composable section surfaces for dense product screens: headers, cards, expansion, selection, footers, markers, and RTL content.',
      badges: const [
        SuperExampleDocsBadgeData(
          icon: Icons.view_agenda_outlined,
          label: 'Composable',
          tone: SuperMarker.identity,
        ),
        SuperExampleDocsBadgeData(
          icon: Icons.tune_outlined,
          label: 'Stateful',
          tone: SuperMarker.ledger,
        ),
      ],
      api: const [
        'SuperSectionCard',
        'SuperSectionCard1',
        'SuperSectionCard2',
        'SuperSectionHeader',
        'SuperSectionFooter',
      ],
      sections: [
        const SuperExampleDocsSectionData(
              label: 'Arabic / RTL sections',
              eyebrow: 'Components',
              title: 'Arabic / RTL sections',
              description: 'Section components with Arabic text direction',
              children: [
                  ArabicExampleSection(
                                title: 'قسم عربي',
                                subtitle: 'بطاقة قسم تستخدم اتجاه النص من اليمين إلى اليسار',
                              )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionCard',
              eyebrow: 'Components',
              title: 'SuperSectionCard examples',
              description: 'Headers, footers, expansion, and surface states',
              children: [
                SuperExampleDocsCard(
                          title: 'Live SuperSectionCard examples',
                          description: 'Headers, footers, expansion, and surface states',
                          code: r'''SuperSectionCard(
                  title: 'Section title',
                  subtitle: 'Supporting description',
                  marker: SuperMarker.identity,
                  child: Text('Section body'),
                );''',
                          minPreviewHeight: 320,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperGrid(
                                              scope: SuperGridScope.current,
                                              children: [
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard(
                                                    title: 'Marker Hidden',
                                                    subtitle: 'showMarker: false keeps the complete header',
                                                    showMarker: false,
                                                    icon: Icons.visibility_off_outlined,
                                                    headerTrailing: StatusPill('NO MARKER'),
                                                    child: _InlineNote(
                                                      'Only the colored marker is hidden; title, subtitle, icon and trailing content remain visible.',
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard(
                                                    eyebrow: 'ADAPTIVE MARKER HEIGHT',
                                                    title: 'Marker Matches Header Content',
                                                    subtitle:
                                                        'The rail stretches to the actual header content height.',
                                                    marker: SuperMarker.ledger,
                                                    icon: Icons.height_outlined,
                                                    child: _InlineNote(
                                                      'No fixed marker height is required for title-only or multi-line header content.',
                                                    ),
                                                  ),
                                                ),
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
                                            )
                            ],
                          ),
                        )
                ],
            ),
        SuperExampleDocsSectionData(
              label: 'SuperSectionCard1',
              eyebrow: 'Components',
              title: 'SuperSectionCard1 examples',
              description: 'Accent-title card with SuperCardTheme integration',
              children: [
                SuperExampleDocsCard(
                          title: 'Live SuperSectionCard1 examples',
                          description: 'Accent-title card with SuperCardTheme integration',
                          code: r'''SuperSectionCard1(
                  title: 'Basic accent section',
                  subtitle: 'Tap to collapse',
                  child: Text('Section body'),
                );''',
                          minPreviewHeight: 320,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperGrid(
                                              scope: SuperGridScope.current,
                                              children: [
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Marker Hidden',
                                                    subtitle: 'showMarker: false',
                                                    showMarker: false,
                                                    icon: Icons.visibility_off_outlined,
                                                    child: _InlineNote(
                                                      'SuperSectionCard1 keeps all header content while hiding only the marker.',
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Adaptive Marker Height',
                                                    subtitle:
                                                        'Marker height follows this title + subtitle content',
                                                    icon: Icons.height_outlined,
                                                    child: _InlineNote(
                                                      'The marker is stretched by the rendered header instead of a fixed 24/40 px value.',
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Basic Accent Section',
                                                    subtitle: 'Tap to collapse',
                                                    icon: Icons.article_outlined,
                                                    collapsible: true,
                                                    child: _InlineNote(
                                                      'Inherits fill, border, radius, padding and animation from the ambient theme.',
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Non-Collapsible',
                                                    subtitle: 'collapsible: false',
                                                    icon: Icons.lock_outline,
                                                    child: _InlineNote(
                                                      'No chevron and no tap target; body content remains visible.',
                                                    ),
                                                  ),
                                                ),
                                                SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Custom Accent',
                                                    subtitle: 'Starts collapsed',
                                                    icon: Icons.palette_outlined,
                                                    accentColor: colorScheme.tertiary,
                                                    collapsible: true,
                                                    initiallyExpanded: false,
                                                    child: const _InlineNote(
                                                      'Pass accentColor to override the title rail and icon tint.',
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Divider After Header',
                                                    subtitle: 'Hairline separates heading from body',
                                                    icon: Icons.horizontal_rule,
                                                    dividerAfterHeader: true,
                                                    child: Column(
                                                      children: [
                                                        _InfoRow('Opening balance', 'SAR 12,450.00'),
                                                        SizedBox(height: 8),
                                                        _InfoRow('Closing balance', 'SAR 15,200.00'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Callback Accent Section',
                                                    subtitle: _card1Expanded ? 'Expanded' : 'Collapsed',
                                                    icon: Icons.dashboard_customize_outlined,
                                                    collapsible: true,
                                                    onExpansionChanged: (value) =>
                                                        setState(() => _card1Expanded = value),
                                                    dividerAfterHeader: true,
                                                    isSelected: _card1Expanded,
                                                    trailing: StatusPill(
                                                      _card1Expanded ? 'OPEN' : 'CLOSED',
                                                      tone:
                                                          _card1Expanded ? PillTone.success : PillTone.neutral,
                                                    ),
                                                    footerBrand: 'SuperCore themed surface',
                                                    footerActions: [
                                                      SuperFooterLink('Details', onTap: () {}),
                                                      SuperFooterLink(
                                                        'Apply',
                                                        emphasized: true,
                                                        onTap: () {},
                                                      ),
                                                    ],
                                                    child: const Column(
                                                      children: [
                                                        _InfoRow('Animation', 'Theme duration + curve'),
                                                        SizedBox(height: 8),
                                                        _InfoRow('Callback', 'Expansion state notification'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'With Trailing',
                                                    subtitle: 'Status pill in the title row',
                                                    icon: Icons.task_alt_outlined,
                                                    isSelected: true,
                                                    trailing: StatusPill('READY', tone: PillTone.success),
                                                    child: _InlineNote(
                                                      'trailing sits inside SuperSectionTitle1 after the title copy.',
                                                    ),
                                                  ),
                                                ),
                                                SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Custom Surface Controls',
                                                    subtitle: 'background, padding, margin, clipBehavior',
                                                    icon: Icons.layers_outlined,
                                                    accentColor: colorScheme.tertiary,
                                                    background: colorScheme.tertiaryContainer.withValues(
                                                      alpha: 0.24,
                                                    ),
                                                    padding: EdgeInsets.all(t.spacing.space4),
                                                    margin: EdgeInsets.only(bottom: t.spacing.space2),
                                                    clipBehavior: Clip.antiAlias,
                                                    animationDuration: const Duration(milliseconds: 320),
                                                    animationCurve: Curves.easeOutCubic,
                                                    child: const Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        _InlineNote(
                                                          'Explicit surface fields override the ambient card theme.',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard1(
                                                    title: 'Prebuilt Footer',
                                                    icon: Icons.rule_folder_outlined,
                                                    accentColor: colorScheme.secondary,
                                                    dividerAfterHeader: true,
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
                                                      'Pass footer directly when actions need callbacks.',
                                                    ),
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
              label: 'SuperSectionCard2',
              eyebrow: 'Components',
              title: 'SuperSectionCard2 examples',
              description: 'Rail-and-chip card with animation, footer, divider and theme integration',
              children: [
                SuperExampleDocsCard(
                          title: 'Live SuperSectionCard2 examples',
                          description: 'Rail-and-chip card with animation, footer, divider and theme integration',
                          code: r'''SuperSectionCard2(
                  title: 'Financial',
                  subtitle: 'Compact rail-and-chip header',
                  icon: Icons.account_balance_wallet_outlined,
                  child: Text('Section body'),
                );''',
                          minPreviewHeight: 320,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperGrid(
                                              scope: SuperGridScope.current,
                                              children: [
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Marker Hidden',
                                                    subtitle: 'showMarker: false',
                                                    showMarker: false,
                                                    icon: Icons.visibility_off_outlined,
                                                    child: _InlineNote(
                                                      'The title, subtitle, icon chip and collapse affordance remain visible.',
                                                    ),
                                                  ),
                                                ),
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Adaptive Marker Height',
                                                    subtitle: 'Rail height follows the rendered header content',
                                                    icon: Icons.height_outlined,
                                                    child: _InlineNote(
                                                      'The style-2 rail no longer uses a fixed 36 px height.',
                                                    ),
                                                  ),
                                                ),
                                                // Basic collapsible (default)
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Basic Section',
                                                    subtitle: 'Tap to collapse',
                                                    icon: Icons.article_outlined,
                                                    child: _InlineNote(
                                                      'Inherits fill, border and radius from the ambient SuperCardTheme.',
                                                    ),
                                                  ),
                                                ),
                                                // Non-collapsible — no chevron, body always visible
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Non-Collapsible',
                                                    subtitle: 'collapsible: false',
                                                    icon: Icons.lock_outline,
                                                    collapsible: false,
                                                    child: _InlineNote(
                                                      'No chevron and no tap target — body is always visible.',
                                                    ),
                                                  ),
                                                ),
                                                // Custom accent + starts collapsed
                                                SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Custom Accent',
                                                    subtitle: 'Starts collapsed',
                                                    icon: Icons.palette_outlined,
                                                    accentColor: colorScheme.tertiary,
                                                    initiallyExpanded: false,
                                                    child: const _InlineNote(
                                                      'Pass accentColor to override the left rail and icon chip tint.',
                                                    ),
                                                  ),
                                                ),
                                                // Divider after header
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Divider After Header',
                                                    subtitle: 'Hairline separates heading from body',
                                                    icon: Icons.horizontal_rule,
                                                    dividerAfterHeader: true,
                                                    child: Column(
                                                      children: [
                                                        _InfoRow('Opening balance', 'SAR 12,450.00'),
                                                        SizedBox(height: 8),
                                                        _InfoRow('Closing balance', 'SAR 15,200.00'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // With trailing widget
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'With Trailing',
                                                    subtitle: 'Status pill in the header',
                                                    icon: Icons.task_alt_outlined,
                                                    isSelected: true,
                                                    trailing: StatusPill('READY', tone: PillTone.success),
                                                    child: _InlineNote(
                                                      'trailing sits between the title and the chevron.',
                                                    ),
                                                  ),
                                                ),
                                                // footerBrand + footerActions
                                                const SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'With Footer',
                                                    subtitle: 'footerBrand auto-builds SuperSectionFooter',
                                                    icon: Icons.receipt_long_outlined,
                                                    footerBrand: 'GeniusLink ERP · draft',
                                                    footerActions: [
                                                      SuperFooterLink('Preview'),
                                                      SuperFooterLink('Submit', emphasized: true),
                                                    ],
                                                    child: _InlineNote(
                                                      'Footer appears below the body, separated by a hairline.',
                                                    ),
                                                  ),
                                                ),
                                                // Prebuilt footer + divider + accentColor
                                                SuperGridCell(
                                                  mobile: 4,
                                                  tablet: 8,
                                                  desktop: 6,
                                                  child: SuperSectionCard2(
                                                    title: 'Prebuilt Footer',
                                                    icon: Icons.rule_folder_outlined,
                                                    accentColor: colorScheme.secondary,
                                                    dividerAfterHeader: true,
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
                                                      'Pass footer directly when the footer needs custom callbacks.',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                            ],
                          ),
                        )
                ],
            ),
        const SuperExampleDocsSectionData(
              label: 'SuperSectionHeader',
              eyebrow: 'Components',
              title: 'SuperSectionHeader',
              description: 'Standalone style1 and style2 headers',
              children: [
                SuperExampleDocsCard(
                          title: 'Live SuperSectionHeader',
                          description: 'Standalone style1 and style2 headers',
                          code: r'''SuperSectionHeader(
                  title: 'Identity details',
                  subtitle: 'Customer profile and metadata',
                  marker: SuperMarker.identity,
                );''',
                          minPreviewHeight: 320,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                SuperGrid(
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
                                            )
                            ],
                          ),
                        )
                ],
            ),
        const SuperExampleDocsSectionData(
              label: 'Supporting Section Pieces',
              eyebrow: 'Components',
              title: 'Supporting Section Pieces',
              description: 'Hairline and footer links used outside cards',
              children: [
                SuperExampleDocsCard(
                          title: 'Live Supporting Section Pieces',
                          description: 'Hairline and footer links used outside cards',
                          code: r'''Column(
                  children: [
                    SuperSectionHeader(...),
                    Hairline(),
                    SuperSectionFooter(...),
                  ],
                );''',
                          minPreviewHeight: 320,
                          previewAlignment: AlignmentDirectional.topCenter,
                          preview: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                _SurfaceBlock(
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
                                            )
                            ],
                          ),
                        )
                ],
            )
      ],
      footer: const SuperExampleDocsNote(
        text:
            'All section examples are live and continue to use the active Super Core palette, density, typography, and RTL direction.',
      ),
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
            style: context.superTextTheme.body.copyWith(color: t.fg3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: t.spacing.space3),
        Text(
          value,
          style: context.superTextTheme.mono.copyWith(color: t.fg1),
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
      style: context.superTextTheme.body.copyWith(color: t.fg2),
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
