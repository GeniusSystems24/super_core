import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SuperMaterialThemeData surface colors', () {
    test('light theme matches the mobile surface stack', () {
      final theme = SuperMaterialThemeData.light(
        textTheme: _testTypography,
        primaryTextTheme: _testTypography,
      );
      final superTheme = theme.superTheme;

      expect(theme.textTheme, isA<SuperTextTheme>());
      expect(theme.primaryTextTheme, isA<SuperTextTheme>());
      expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
      expect(theme.scaffoldBackgroundColor, const Color(0xFFEAEAEA));
      expect(theme.appBarTheme.backgroundColor, theme.scaffoldBackgroundColor);
      expect(theme.cardColor, theme.colorScheme.surfaceContainer);
      expect(theme.cardColor, const Color(0xFFF2F2F2));
      expect(theme.cardTheme.color, theme.colorScheme.surfaceContainer);
      expect(theme.dialogTheme.backgroundColor, theme.colorScheme.surfaceContainer);
      expect(theme.bottomSheetTheme.backgroundColor, theme.colorScheme.surfaceContainer);
      expect(theme.inputDecorationTheme.fillColor, const Color(0xFFFFFFFF));
      expect(theme.scaffoldBackgroundColor, isNot(theme.cardColor));
      expect(theme.scaffoldBackgroundColor,
          isNot(theme.inputDecorationTheme.fillColor));
      expect(theme.floatingActionButtonTheme.backgroundColor, kAccent);
      expect(
        theme.floatingActionButtonTheme.foregroundColor,
        theme.colorScheme.onPrimary,
      );
      expect(theme.floatingActionButtonTheme.sizeConstraints, kFabSize);
      expect(superTheme.bg, theme.scaffoldBackgroundColor);
      expect(superTheme.inputBg, theme.inputDecorationTheme.fillColor);
      expect(theme.colorScheme.surfaceContainer, superTheme.surface);
    });

    test('dark theme matches the mobile surface stack', () {
      final theme = SuperMaterialThemeData.dark(
        textTheme: _testTypography,
        primaryTextTheme: _testTypography,
      );
      final superTheme = theme.superTheme;

      expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
      expect(theme.scaffoldBackgroundColor, const Color(0xFF101010));
      expect(theme.appBarTheme.backgroundColor, theme.scaffoldBackgroundColor);
      expect(theme.cardColor, theme.colorScheme.surfaceContainer);
      expect(theme.cardColor, const Color(0xFF181818));
      expect(theme.cardTheme.color, theme.colorScheme.surfaceContainer);
      expect(theme.dialogTheme.backgroundColor, theme.colorScheme.surfaceContainer);
      expect(theme.bottomSheetTheme.backgroundColor, theme.colorScheme.surfaceContainer);
      expect(theme.inputDecorationTheme.fillColor, const Color(0xFF242424));
      expect(theme.scaffoldBackgroundColor, isNot(theme.cardColor));
      expect(theme.scaffoldBackgroundColor,
          isNot(theme.inputDecorationTheme.fillColor));
      expect(theme.floatingActionButtonTheme.backgroundColor, kDarkAccent);
      expect(
        theme.floatingActionButtonTheme.foregroundColor,
        theme.colorScheme.onPrimary,
      );
      expect(theme.floatingActionButtonTheme.sizeConstraints, kFabSize);
      expect(superTheme.bg, theme.scaffoldBackgroundColor);
      expect(superTheme.inputBg, theme.inputDecorationTheme.fillColor);
      expect(theme.colorScheme.surfaceContainer, superTheme.surface);
    });

    test('light theme registers light interactive-state colors', () {
      final theme = SuperMaterialThemeData.light(
        textTheme: _testTypography,
        primaryTextTheme: _testTypography,
      );
      final states = theme.extension<SuperInteractiveStateThemeData>();

      expect(states, isNotNull);
      expect(states!.accent, theme.colorScheme.primary);
      expect(states.hoverSurface, theme.colorScheme.surfaceContainerHighest);
      expect(states.hoverSurface, const Color(0xFFE6E6E6));
      expect(theme.superTheme.interactiveStates, same(states));
      expect(SuperThemeData.light.interactiveStates.hoverSurface,
          const Color(0xFFE6E6E6));
      expect(SuperThemeData.dark.interactiveStates.hoverSurface,
          const Color(0xFF2A2A2A));
    });

    testWidgets('plain light ThemeData gets a brightness-aware state fallback',
        (tester) async {
      late SuperInteractiveStateThemeData resolved;
      final scheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B5CF6),
        brightness: Brightness.light,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: scheme),
          home: Builder(
            builder: (context) {
              resolved = SuperInteractiveStateThemeData.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.accent, scheme.primary);
      expect(resolved.hoverSurface, scheme.surfaceContainerHighest);
    });

    test('explicit Scaffold background override still wins', () {
      const override = Color(0xFFFAFAFA);
      final theme = SuperMaterialThemeData.light(
        textTheme: _testTypography,
        primaryTextTheme: _testTypography,
        scaffoldBackgroundColor: override,
      );

      expect(theme.scaffoldBackgroundColor, override);
      expect(theme.cardColor, theme.colorScheme.surfaceContainer);
    });

    test('copyWith accepts plain Flutter text themes', () {
      final theme = SuperMaterialThemeData.light(
        textTheme: _testTypography,
        primaryTextTheme: _testTypography,
      );

      final copied = theme.copyWith(
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 17)),
        primaryTextTheme: const TextTheme(titleMedium: TextStyle(fontSize: 18)),
      );

      expect(copied.textTheme, isA<SuperTextTheme>());
      expect(copied.primaryTextTheme, isA<SuperTextTheme>());
    });

    test('can be localized by Flutter ThemeData', () {
      final theme = SuperMaterialThemeData.light(
        textTheme: _testTypography,
        primaryTextTheme: _testTypography,
      );

      final localized = ThemeData.localize(
        theme,
        theme.typography.geometryThemeFor(ScriptCategory.englishLike),
      );

      expect(localized, isA<SuperMaterialThemeData>());
      expect(localized.textTheme, isA<SuperTextTheme>());
      expect(localized.primaryTextTheme, isA<SuperTextTheme>());
    });
  });
}

const kAccent = Color(0xFF4A7CFF);
const kDarkAccent = Color(0xFF7A9AFF);
const kFabSize = BoxConstraints.tightFor(width: 54, height: 54);
final _testTypography = SuperTextTheme(
  bodyFont: const TextStyle(fontFamily: 'TestBody'),
  otherFont: const TextStyle(fontFamily: 'TestDisplay'),
);
