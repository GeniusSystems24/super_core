import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_core/super_core.dart';

import 'home_screen.dart';

void main() => runApp(const SuperCoreExampleApp());

class SuperCoreExampleApp extends StatefulWidget {
  const SuperCoreExampleApp({super.key});

  @override
  State<SuperCoreExampleApp> createState() => _SuperCoreExampleAppState();
}

class _SuperCoreExampleAppState extends State<SuperCoreExampleApp> {
  SuperPalette _palette = SuperPalette.bluePalette;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    final isArabic = _locale.languageCode == 'ar';
    final typography = SuperTextTheme(isArabic: isArabic);

    return MaterialApp(
      title: 'Super Core',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      themeMode: _themeMode,
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeOutCubic,
      theme: SuperMaterialThemeData.light(
        palette: _palette,
        textTheme: typography,
        primaryTextTheme: typography,
      ),
      darkTheme: SuperMaterialThemeData.dark(
        palette: _palette,
        textTheme: typography,
        primaryTextTheme: typography,
      ),
      builder: (context, child) => SuperToastHost(
        child: child ?? const SizedBox.shrink(),
      ),
      home: HomeScreen(
        selectedPalette: _palette,
        themeMode: _themeMode,
        locale: _locale,
        onPaletteChanged: (palette) => setState(() => _palette = palette),
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      ),
    );
  }
}
