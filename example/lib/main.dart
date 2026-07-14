import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'theme_demo_screen.dart';

void main() => runApp(const SuperCoreExampleApp());

/// Root widget that owns [SuperPalette] + [ThemeMode] state and wires
/// [SuperMaterialThemeData] into the [MaterialApp].
///
/// Demonstrates:
/// - [SuperMaterialThemeData.light] and [SuperMaterialThemeData.dark]
/// - Runtime palette switching via [SuperPalette.values]
/// - Light / Dark / System [ThemeMode] toggle
class SuperCoreExampleApp extends StatefulWidget {
  const SuperCoreExampleApp({super.key});

  @override
  State<SuperCoreExampleApp> createState() => _SuperCoreExampleAppState();
}

class _SuperCoreExampleAppState extends State<SuperCoreExampleApp> {
  SuperPalette _palette = SuperPalette.bluePalette;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Core — Theme Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // SuperMaterialThemeData generates complete Material 3 ThemeData and
      // registers SuperThemeData as a ThemeExtension automatically.
      theme: SuperMaterialThemeData.light(palette: _palette),
      darkTheme: SuperMaterialThemeData.dark(palette: _palette),
      home: ThemeDemoScreen(
        selectedPalette: _palette,
        themeMode: _themeMode,
        onPaletteChanged: (p) => setState(() => _palette = p),
        onThemeModeChanged: (m) => setState(() => _themeMode = m),
      ),
    );
  }
}
