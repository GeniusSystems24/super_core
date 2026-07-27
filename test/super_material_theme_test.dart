import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SuperMaterialThemeData surface colors', () {
    test('light theme matches the mobile surface stack', () {
      final theme = SuperMaterialThemeData.light(
        textTheme: _testTextTheme,
        mergeTextTheme: false,
      );
      final superTheme = theme.superTheme;

      expect(theme.scaffoldBackgroundColor, const Color(0xFFEAEAEA));
      expect(theme.appBarTheme.backgroundColor, theme.scaffoldBackgroundColor);
      expect(theme.inputDecorationTheme.fillColor, const Color(0xFFFFFFFF));
      expect(theme.cardColor, const Color(0xFFEAEAEA));
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
        textTheme: _testTextTheme,
        mergeTextTheme: false,
      );
      final superTheme = theme.superTheme;

      expect(theme.scaffoldBackgroundColor, const Color(0xFF101010));
      expect(theme.appBarTheme.backgroundColor, theme.scaffoldBackgroundColor);
      expect(theme.inputDecorationTheme.fillColor, const Color(0xFF242424));
      expect(theme.cardColor, const Color(0xFF101010));
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
  });
}

const kAccent = Color(0xFF4A7CFF);
const kDarkAccent = Color(0xFF7A9AFF);
const kFabSize = BoxConstraints.tightFor(width: 54, height: 54);
final _testTextTheme = Typography.material2021().black;
