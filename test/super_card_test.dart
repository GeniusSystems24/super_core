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
        theme: SuperMaterialThemeData.light(),
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
        theme: SuperMaterialThemeData.light(),
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
}
