import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  test('SuperBreakpoint resolves legacy column breakpoints', () {
    expect(SuperBreakpoint.ofWidth(599), SuperBreakpoint.mobile);
    expect(SuperBreakpoint.ofWidth(600), SuperBreakpoint.tablet);
    expect(SuperBreakpoint.ofWidth(839), SuperBreakpoint.tablet);
    expect(SuperBreakpoint.ofWidth(840), SuperBreakpoint.desktop);
    expect(SuperBreakpoint.ofWidth(1199), SuperBreakpoint.desktop);
    expect(SuperBreakpoint.ofWidth(1200), SuperBreakpoint.large);
  });

  test('SuperBreakpoints resolves fallback values by breakpoint', () {
    expect(
      SuperBreakpoints.resolveFor<String>(
        SuperBreakpoint.mobile,
        mobile: 'm',
        desktop: 'd',
      ),
      'm',
    );
    expect(
      SuperBreakpoints.resolveFor<String>(
        SuperBreakpoint.tablet,
        mobile: 'm',
        desktop: 'd',
      ),
      'm',
    );
    expect(
      SuperBreakpoints.resolveFor<String>(
        SuperBreakpoint.large,
        mobile: 'm',
        desktop: 'd',
      ),
      'd',
    );
  });

  test('SuperGridCell resolves spans and order by breakpoint', () {
    const cell = SuperGridCell(
      child: SizedBox.shrink(),
      mobile: 4,
      tablet: 6,
      desktop: 3,
      large: 2,
      mobileOrder: 3,
      tabletOrder: 2,
      desktopOrder: 1,
    );

    expect(cell.columnsAt(SuperBreakpoint.mobile), 4);
    expect(cell.columnsAt(SuperBreakpoint.tablet), 6);
    expect(cell.columnsAt(SuperBreakpoint.desktop), 3);
    expect(cell.columnsAt(SuperBreakpoint.large), 2);
    expect(cell.orderAt(SuperBreakpoint.mobile), 3);
    expect(cell.orderAt(SuperBreakpoint.tablet), 2);
    expect(cell.orderAt(SuperBreakpoint.desktop), 1);
    expect(cell.orderAt(SuperBreakpoint.large), 1);
  });

  testWidgets('SuperBreakpointProvider supplies a local breakpoint', (
    tester,
  ) async {
    late SuperBreakpoint breakpoint;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SuperBreakpointProvider(
          breakpoint: SuperBreakpoint.tablet,
          child: Builder(
            builder: (context) {
              breakpoint = SuperBreakpoint.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(breakpoint, SuperBreakpoint.tablet);
  });
}
