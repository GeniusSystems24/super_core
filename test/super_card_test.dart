import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  testWidgets('SuperSectionCard background overrides the theme surface', (
    tester,
  ) async {
    const background = Color(0xFFE2E8F0);

    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.light(
          textTheme: _testTypography,
          primaryTextTheme: _testTypography,
        ),
        home: const Scaffold(
          body: SuperSectionCard(
            color: background,
            child: Text('Card content'),
          ),
        ),
      ),
    );

    final card = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(SuperSectionCard),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final decoration = card.decoration! as BoxDecoration;

    expect(decoration.color, background);
  });

  testWidgets('SuperSectionCard default header uses legacy title ordering', (
    tester,
  ) async {
    const accent = Color(0xFF2563EB);
    const leadingKey = Key('legacy-leading');
    const trailingKey = Key('legacy-trailing');

    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.light(
          textTheme: _testTypography,
          primaryTextTheme: _testTypography,
        ),
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 420,
              child: SuperSectionCard(
                title: 'Account Details',
                subtitle: 'Financial identity',
                markerColor: accent,
                icon: Icons.account_balance_outlined,
                leading: SizedBox(key: leadingKey, width: 10, height: 10),
                headerTrailing: SizedBox(
                  key: trailingKey,
                  width: 20,
                  height: 20,
                ),
                child: Text('Body'),
              ),
            ),
          ),
        ),
      ),
    );

    final iconFinder = find.byIcon(Icons.account_balance_outlined);
    final leadingFinder = find.byKey(leadingKey);
    final titleFinder = find.text('Account Details');
    final trailingFinder = find.byKey(trailingKey);
    final markerFinder = find.byWidgetPredicate((widget) {
      final decoration = widget is Container ? widget.decoration : null;
      return decoration is BoxDecoration && decoration.color == accent;
    });

    expect(iconFinder, findsOneWidget);
    expect(leadingFinder, findsOneWidget);
    expect(markerFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
    expect(trailingFinder, findsOneWidget);

    final iconLeft = tester.getTopLeft(iconFinder).dx;
    final leadingLeft = tester.getTopLeft(leadingFinder).dx;
    final markerLeft = tester.getTopLeft(markerFinder).dx;
    final titleLeft = tester.getTopLeft(titleFinder).dx;
    final trailingLeft = tester.getTopLeft(trailingFinder).dx;

    expect(iconLeft, lessThan(leadingLeft));
    expect(leadingLeft, lessThan(markerLeft));
    expect(markerLeft, lessThan(titleLeft));
    expect(titleLeft, lessThan(trailingLeft));
  });

  testWidgets('SuperSectionCard2 keeps non-collapsible body visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.light(
          textTheme: _testTypography,
          primaryTextTheme: _testTypography,
        ),
        home: const Scaffold(
          body: SuperSectionCard2(
            title: 'Fixed Section',
            collapsible: false,
            initiallyExpanded: false,
            child: Text('Fixed body'),
          ),
        ),
      ),
    );

    expect(find.text('Fixed body'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);
  });

  testWidgets('SuperSectionCard2 resolves its rail from text direction', (
    tester,
  ) async {
    const accent = Color(0xFF16A34A);

    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.light(
          textTheme: _testTypography,
          primaryTextTheme: _testTypography,
        ),
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: SuperSectionCard2(
                title: 'Directional Header',
                accentColor: accent,
                collapsible: false,
                child: Text('Body'),
              ),
            ),
          ),
        ),
      ),
    );

    final railFinder = find.byWidgetPredicate((widget) {
      if (widget is! Container) return false;
      final decoration = widget.decoration;
      return decoration is BoxDecoration &&
          decoration.color == accent &&
          widget.constraints?.maxWidth == 4 &&
          widget.constraints?.maxHeight == 36;
    });
    final rail = tester.widget<Container>(railFinder);
    final decoration = rail.decoration! as BoxDecoration;

    expect(railFinder, findsOneWidget);
    expect(decoration.borderRadius, isA<BorderRadiusDirectional>());
    expect(
      tester.getCenter(railFinder).dx,
      greaterThan(tester.getCenter(find.text('DIRECTIONAL HEADER')).dx),
    );
  });

  testWidgets('SuperSectionCard1 keeps expansion state alive in lists', (
    tester,
  ) async {
    await _expectExpandedStateSurvivesScroll(
      tester,
      const SuperSectionCard1(
        title: 'Card 1',
        collapsible: true,
        initiallyExpanded: false,
        child: Text('Card 1 body'),
      ),
      title: 'Card 1',
      body: 'Card 1 body',
    );
  });

  testWidgets('SuperSectionCard2 keeps expansion state alive in lists', (
    tester,
  ) async {
    await _expectExpandedStateSurvivesScroll(
      tester,
      const SuperSectionCard2(
        title: 'Card 2',
        initiallyExpanded: false,
        child: Text('Card 2 body'),
      ),
      title: 'CARD 2',
      body: 'Card 2 body',
    );
  });
}

Future<void> _expectExpandedStateSurvivesScroll(
  WidgetTester tester,
  Widget card, {
  required String title,
  required String body,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: SuperMaterialThemeData.light(
          textTheme: _testTypography,
          primaryTextTheme: _testTypography,
        ),
      home: Scaffold(
        body: SizedBox(
          height: 160,
          child: ListView.builder(
            key: const Key('keep-alive-list'),
            cacheExtent: 0,
            itemCount: 30,
            itemBuilder: (context, index) {
              if (index == 0) return card;
              return SizedBox(height: 96, child: Text('Row $index'));
            },
          ),
        ),
      ),
    ),
  );

  expect(_sectionCrossFade(tester).crossFadeState, CrossFadeState.showSecond);

  await tester.tap(find.text(title));
  await tester.pumpAndSettle();

  expect(_sectionCrossFade(tester).crossFadeState, CrossFadeState.showFirst);

  await tester.drag(
    find.byKey(const Key('keep-alive-list')),
    const Offset(0, -900),
  );
  await tester.pumpAndSettle();

  await tester.drag(
    find.byKey(const Key('keep-alive-list')),
    const Offset(0, 900),
  );
  await tester.pumpAndSettle();

  expect(_sectionCrossFade(tester).crossFadeState, CrossFadeState.showFirst);
}

AnimatedCrossFade _sectionCrossFade(WidgetTester tester) =>
    tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade).first);

final _testTypography = SuperTextTheme(
  bodyFont: const TextStyle(fontFamily: 'TestBody'),
  otherFont: const TextStyle(fontFamily: 'TestDisplay'),
);
