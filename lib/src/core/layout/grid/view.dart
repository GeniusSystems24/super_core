part of 'grid.dart';

/// Column-based responsive grid that wraps [SuperGridCell] children into rows.
///
/// [SuperGrid] uses 4 columns on mobile, 8 on tablet, and 12 on desktop/large.
/// Give each cell a span per breakpoint and optional per-breakpoint display
/// order. Cells with an active span of `0` are hidden.
class SuperGrid extends StatelessWidget {
  const SuperGrid({
    super.key,
    required this.children,
    this.gutter,
    this.rowSpacing,
    this.scope = SuperGridScope.provider,
    this.overrideBreakpoint,
    this.shouldProvideValue = true,
  });

  /// Grid cells to arrange into responsive rows.
  final List<SuperGridCell> children;

  /// Horizontal gap between cells. Defaults to the active spacing scale.
  final double? gutter;

  /// Vertical gap between rows. Defaults to the active spacing scale.
  final double? rowSpacing;

  /// How the active [SuperBreakpoint] is resolved.
  final SuperGridScope scope;

  /// Explicit breakpoint override. Takes precedence over [scope].
  final SuperBreakpoint? overrideBreakpoint;

  /// Whether descendants receive the resolved breakpoint through
  /// [SuperBreakpointProvider].
  final bool shouldProvideValue;

  @override
  Widget build(BuildContext context) {
    final override = overrideBreakpoint;
    if (override != null) return _buildGrid(context, override);

    return switch (scope) {
      SuperGridScope.provider => _buildGrid(
        context,
        SuperBreakpointProvider.maybeBreakpointOf(context) ??
            SuperBreakpoint.globalOf(context),
      ),
      SuperGridScope.global => _buildGrid(
        context,
        SuperBreakpoint.globalOf(context),
      ),
      SuperGridScope.current => LayoutBuilder(
        builder: (context, constraints) => _buildGrid(
          context,
          SuperBreakpoint.ofWidth(constraints.maxWidth),
          width: constraints.maxWidth,
        ),
      ),
    };
  }

  Widget _buildGrid(
    BuildContext context,
    SuperBreakpoint breakpoint, {
    double? width,
  }) {
    final grid = _buildGridColumn(context, breakpoint);
    if (!shouldProvideValue) return grid;
    return SuperBreakpointProvider(
      breakpoint: breakpoint,
      defaultWidth: width,
      child: grid,
    );
  }

  Widget _buildGridColumn(BuildContext context, SuperBreakpoint breakpoint) {
    final t = context.superTheme;
    final totalColumns = breakpoint.columns;
    final gutterWidth =
        gutter ??
        SuperBreakpoints.resolveFor<double>(
          breakpoint,
          mobile: t.spacing.space4,
          desktop: t.spacing.space3,
        );
    final verticalGap = rowSpacing ?? t.spacing.space2;

    final indexedCells =
        <({SuperGridCell cell, int index})>[
          for (var i = 0; i < children.length; i++)
            if (children[i].columnsAt(breakpoint) != 0)
              (cell: children[i], index: i),
        ]..sort((a, b) {
          final order = a.cell
              .orderAt(breakpoint)
              .compareTo(b.cell.orderAt(breakpoint));
          return order == 0 ? a.index.compareTo(b.index) : order;
        });

    final rows = <List<({SuperGridCell cell, int span})>>[];
    var currentRow = <({SuperGridCell cell, int span})>[];
    var usedColumns = 0;

    for (final item in indexedCells) {
      final span = item.cell
          .columnsAt(breakpoint)
          .clamp(1, totalColumns)
          .toInt();
      if (usedColumns + span > totalColumns) {
        if (currentRow.isNotEmpty) rows.add(currentRow);
        currentRow = [];
        usedColumns = 0;
      }

      currentRow.add((cell: item.cell, span: span));
      usedColumns += span;
    }
    if (currentRow.isNotEmpty) rows.add(currentRow);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: verticalGap),
          _buildRow(rows[i], gutterWidth),
        ],
      ],
    );
  }

  Widget _buildRow(
    List<({SuperGridCell cell, int span})> cells,
    double gutterWidth,
  ) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < cells.length; i++) ...[
        if (i > 0) SizedBox(width: gutterWidth),
        Expanded(flex: cells[i].span, child: cells[i].cell.child),
      ],
    ],
  );
}
