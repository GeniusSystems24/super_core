// GENERATED DOCS-LAYOUT MIGRATION: super_core example docs v1
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'arabic_examples.dart';
/// Example screen for the v3.1.0 Super layout primitives.
class LayoutComponentsScreen extends StatelessWidget {
  const LayoutComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return SuperExampleDocsPage(
      title: 'Layout Components',
      subtitle: 'SUPER CORE · v3.5.0',
      description:
          'Responsive page frames, breakpoint-aware grids, provider-controlled layout, ordering, and RTL behavior built from Super Core layout primitives.',
      badges: const [
        SuperExampleDocsBadgeData(
          icon: Icons.dashboard_customize_outlined,
          label: 'Responsive',
          tone: SuperMarker.ledger,
        ),
        SuperExampleDocsBadgeData(
          icon: Icons.grid_view_outlined,
          label: 'Grid',
          tone: SuperMarker.identity,
        ),
      ],
      api: const [
        'SuperScaffold',
        'SuperBreakpoint',
        'SuperBreakpointProvider',
        'SuperGrid',
        'SuperGridCell',
      ],
      sections: [
        SuperExampleDocsSectionData(
              label: 'Responsive Page Frame',
              eyebrow: 'Layout',
              title: 'Responsive Page Frame',
              description: 'SuperScaffold + SuperBreakpoint',
              children: [
                SuperExampleDocsCard(
                        title: 'Responsive Page Frame',
                        description: 'Inspect the active breakpoint, column count, width, and responsive section spacing.',
                        code: r'''LayoutBuilder(
                  builder: (context, constraints) {
                    final breakpoint = SuperBreakpoint.ofWidth(constraints.maxWidth);
                    return SuperGrid(...);
                  },
                );''',
                        minPreviewHeight: 280,
                        previewAlignment: AlignmentDirectional.topCenter,
                        preview: LayoutBuilder(
                              builder: (context, constraints) {
                                final breakpoint = SuperBreakpoint.ofWidth(
                                  constraints.maxWidth,
                                );
                                return SuperSectionCard(
                                  title: 'Responsive Page Frame',
                                  subtitle: 'SuperScaffold + SuperBreakpoint',
                                  icon: Icons.dashboard_customize_outlined,
                                  marker: SuperMarker.identity,
                                  child: SuperGrid(
                                    scope: SuperGridScope.current,
                                    children: [
                                      SuperGridCell(
                                        mobile: 4,
                                        tablet: 4,
                                        desktop: 3,
                                        child: _MetricTile(
                                          icon: Icons.width_normal_outlined,
                                          label: 'Width',
                                          value: '${constraints.maxWidth.round()} px',
                                        ),
                                      ),
                                      SuperGridCell(
                                        mobile: 4,
                                        tablet: 4,
                                        desktop: 3,
                                        child: _MetricTile(
                                          icon: Icons.view_column_outlined,
                                          label: 'Columns',
                                          value: '${breakpoint.columns}',
                                        ),
                                      ),
                                      SuperGridCell(
                                        mobile: 4,
                                        tablet: 4,
                                        desktop: 3,
                                        child: _MetricTile(
                                          icon: Icons.devices_outlined,
                                          label: 'Breakpoint',
                                          value: breakpoint.name,
                                        ),
                                      ),
                                      SuperGridCell(
                                        mobile: 4,
                                        tablet: 4,
                                        desktop: 3,
                                        child: _MetricTile(
                                          icon: Icons.space_bar_outlined,
                                          label: 'Section Gap',
                                          value: '${t.spacing.section.round()} px',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      )
              ],
            ),
        const SuperExampleDocsSectionData(
              label: 'Arabic / RTL',
              eyebrow: 'Layout',
              title: 'Arabic / RTL',
              description: 'Responsive layout primitives in right-to-left direction.',
              children: [
                ArabicExampleSection(
                              title: 'تخطيط عربي متجاوب',
                              subtitle: 'SuperScaffold و SuperGrid مع اتجاه RTL',
                              compactHeader: true,
                            )
              ],
            ),
        const SuperExampleDocsSectionData(
              label: 'Current-Width Grid',
              eyebrow: 'Layout',
              title: 'Current-Width Grid',
              description: 'SuperGridScope.current',
              children: [
                _SectionBlock(
                              title: 'Current-Width Grid',
                              subtitle: 'SuperGridScope.current',
                              child: SuperGrid(
                                scope: SuperGridScope.current,
                                children: [
                                  SuperGridCell(
                                    mobile: 4,
                                    tablet: 4,
                                    desktop: 4,
                                    child: _DemoTile(
                                      title: 'Identity',
                                      subtitle: '4 / 4 / 4 columns',
                                      marker: SuperMarker.identity,
                                      icon: Icons.badge_outlined,
                                    ),
                                  ),
                                  SuperGridCell(
                                    mobile: 4,
                                    tablet: 4,
                                    desktop: 4,
                                    child: _DemoTile(
                                      title: 'Ledger',
                                      subtitle: '4 / 4 / 4 columns',
                                      marker: SuperMarker.ledger,
                                      icon: Icons.account_balance_wallet_outlined,
                                    ),
                                  ),
                                  SuperGridCell(
                                    mobile: 4,
                                    tablet: 8,
                                    desktop: 4,
                                    child: _DemoTile(
                                      title: 'Notes',
                                      subtitle: '4 / 8 / 4 columns',
                                      marker: SuperMarker.notes,
                                      icon: Icons.description_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            )
              ],
            ),
        SuperExampleDocsSectionData(
              label: 'Provider-Controlled Grid',
              eyebrow: 'Layout',
              title: 'Provider-Controlled Grid',
              description: 'SuperBreakpointProvider + SuperGridScope.provider',
              children: [
                _SectionBlock(
                              title: 'Provider-Controlled Grid',
                              subtitle: 'SuperBreakpointProvider + SuperGridScope.provider',
                              child: SuperBreakpointProvider(
                                breakpoint: SuperBreakpoint.tablet,
                                child: Builder(
                                  builder: (context) {
                                    final breakpoint = SuperBreakpoint.of(context);
                                    final activeInset = SuperBreakpoints.resolve<double>(
                                      context,
                                      mobile: 12,
                                      tablet: 16,
                                      desktop: 20,
                                      large: 24,
                                    );
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Wrap(
                                          spacing: t.spacing.space2,
                                          runSpacing: t.spacing.space2,
                                          children: [
                                            StatusPill('BREAKPOINT ${breakpoint.name}'),
                                            StatusPill('${breakpoint.columns} COLUMNS'),
                                            StatusPill('INSET ${activeInset.round()} PX'),
                                          ],
                                        ),
                                        SizedBox(height: t.spacing.space4),
                                        const SuperGrid(
                                          scope: SuperGridScope.provider,
                                          children: [
                                            SuperGridCell(
                                              mobile: 4,
                                              tablet: 3,
                                              desktop: 4,
                                              child: _DemoTile(
                                                title: 'A',
                                                subtitle: 'tablet span 3',
                                                marker: SuperMarker.identity,
                                              ),
                                            ),
                                            SuperGridCell(
                                              mobile: 4,
                                              tablet: 5,
                                              desktop: 4,
                                              child: _DemoTile(
                                                title: 'B',
                                                subtitle: 'tablet span 5',
                                                marker: SuperMarker.ledger,
                                              ),
                                            ),
                                            SuperGridCell(
                                              mobile: 4,
                                              tablet: 8,
                                              desktop: 4,
                                              child: _DemoTile(
                                                title: 'C',
                                                subtitle: 'tablet span 8',
                                                marker: SuperMarker.notes,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
              ],
            ),
        const SuperExampleDocsSectionData(
              label: 'Responsive Ordering',
              eyebrow: 'Layout',
              title: 'Responsive Ordering',
              description: 'SuperGridCell order fields',
              children: [
                _SectionBlock(
                              title: 'Responsive Ordering',
                              subtitle: 'SuperGridCell order fields',
                              child: SuperGrid(
                                scope: SuperGridScope.current,
                                children: [
                                  SuperGridCell(
                                    mobile: 4,
                                    tablet: 4,
                                    desktop: 3,
                                    mobileOrder: 3,
                                    desktopOrder: 1,
                                    child: _DemoTile(
                                      title: 'Summary',
                                      subtitle: 'mobile 3 / desktop 1',
                                      marker: SuperMarker.identity,
                                    ),
                                  ),
                                  SuperGridCell(
                                    mobile: 4,
                                    tablet: 4,
                                    desktop: 6,
                                    mobileOrder: 1,
                                    desktopOrder: 2,
                                    child: _DemoTile(
                                      title: 'Details',
                                      subtitle: 'mobile 1 / desktop 2',
                                      marker: SuperMarker.ledger,
                                    ),
                                  ),
                                  SuperGridCell(
                                    mobile: 4,
                                    tablet: 8,
                                    desktop: 3,
                                    mobileOrder: 2,
                                    desktopOrder: 3,
                                    child: _DemoTile(
                                      title: 'Activity',
                                      subtitle: 'mobile 2 / desktop 3',
                                      marker: SuperMarker.notes,
                                    ),
                                  ),
                                ],
                              ),
                            )
              ],
            )
      ],
      footer: const SuperExampleDocsNote(
        text:
            'Resize the example window to see the live breakpoint and grid behavior change without changing the example code.',
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SuperExampleDocsCard(
      title: title,
      description: subtitle,
      code: '// $title\nSuperGrid(\n  scope: SuperGridScope.current,\n  children: [/* SuperGridCell(...) */],\n);',
      minPreviewHeight: 260,
      previewAlignment: AlignmentDirectional.topCenter,
      preview: child,
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: t.spacing.compactCardPadding,
      decoration: BoxDecoration(
        color: t.inputBg,
        borderRadius: t.spacing.cardBorderRadius,
        border: Border.all(color: t.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: t.sizing.icon),
          SizedBox(width: t.spacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: context.superTextTheme.labelSm.copyWith(color: t.fg3),
                ),
                SizedBox(height: t.spacing.space1),
                Text(
                  value,
                  style: context.superTextTheme.titleMd.copyWith(color: t.fg1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.marker,
    this.icon,
  });

  final String title;
  final String subtitle;
  final SuperMarker marker;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return SuperSectionCard(
      padding: t.spacing.compactCardPadding,
      title: title,
      subtitle: subtitle,
      marker: marker,
      icon: icon,
      headerStyle: SuperSectionHeaderStyle.style2,
      child: SizedBox(
        height: t.spacing.space6,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            marker.name.toUpperCase(),
            style: context.superTextTheme.mono.copyWith(color: t.fg2),
          ),
        ),
      ),
    );
  }
}
