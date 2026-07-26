import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  testWidgets('SuperCard background overrides the theme surface', (
    tester,
  ) async {
    const background = Color(0xFFE2E8F0);

    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.light(),
        home: const Scaffold(
          body: SuperCard(background: background, child: Text('Card content')),
        ),
      ),
    );

    final card = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(SuperCard),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final decoration = card.decoration! as BoxDecoration;

    expect(decoration.color, background);
  });
}
