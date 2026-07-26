import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  group('SuperMaterialThemeData surface colors', () {
    test('light theme matches the mobile surface stack', () {
      final theme = SuperMaterialThemeData.light();
      final superTheme = theme.superTheme;

      expect(theme.scaffoldBackgroundColor, const Color(0xFFE9EDF3));
      expect(theme.appBarTheme.backgroundColor, theme.scaffoldBackgroundColor);
      expect(theme.inputDecorationTheme.fillColor, const Color(0xFFFFFFFF));
      expect(theme.cardColor, const Color(0xFFF8FAFD));
      expect(theme.floatingActionButtonTheme.backgroundColor, kAccent);
      expect(theme.floatingActionButtonTheme.foregroundColor, Colors.white);
      expect(theme.floatingActionButtonTheme.sizeConstraints, kFabSize);
      expect(superTheme.bg, theme.scaffoldBackgroundColor);
      expect(superTheme.inputBg, theme.inputDecorationTheme.fillColor);
      expect(theme.colorScheme.surfaceContainerLowest, superTheme.surface);
    });

    test('dark theme matches the mobile surface stack', () {
      final theme = SuperMaterialThemeData.dark();
      final superTheme = theme.superTheme;

      expect(theme.scaffoldBackgroundColor, const Color(0xFF09131D));
      expect(theme.appBarTheme.backgroundColor, theme.scaffoldBackgroundColor);
      expect(theme.inputDecorationTheme.fillColor, const Color(0xFF1B2738));
      expect(theme.cardColor, const Color(0xFF0D151C));
      expect(theme.floatingActionButtonTheme.backgroundColor, kAccent);
      expect(theme.floatingActionButtonTheme.foregroundColor, Colors.white);
      expect(theme.floatingActionButtonTheme.sizeConstraints, kFabSize);
      expect(superTheme.bg, theme.scaffoldBackgroundColor);
      expect(superTheme.inputBg, theme.inputDecorationTheme.fillColor);
      expect(theme.colorScheme.surfaceContainer, superTheme.surface);
    });
  });
}

const kAccent = Color(0xFF4A7CFF);
const kFabSize = BoxConstraints.tightFor(width: 54, height: 54);
