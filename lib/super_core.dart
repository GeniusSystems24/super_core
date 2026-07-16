/// Super Core — the shared GeniusLink design-system foundation for the Super
/// toolkit. Single source of truth for the visual identity that every Super
/// package reads from, so the whole toolkit looks like one product.
///
/// ## v1.0.0 — SuperPalette + SuperMaterialThemeData
///
/// Pick a palette and generate complete Material 3 [ThemeData]:
///
/// ```dart
/// MaterialApp(
///   theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
///   darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
/// );
/// ```
///
/// Palette switching at runtime:
///
/// ```dart
/// setState(() => _palette = SuperPalette.greenPalette);
/// // Rebuild MaterialApp — both light and dark themes update automatically.
/// ```
///
/// All Super components adapt automatically: [SuperMaterialThemeData] registers
/// [SuperThemeData] as a [ThemeExtension], so [SuperThemeData.of(context)]
/// picks up palette-derived surface tokens without extra wiring.
///
/// ## Pre-v1.0.0 API (unchanged)
///
/// ```dart
/// MaterialApp(
///   theme:     ThemeData(extensions: const [SuperThemeData.light]),
///   darkTheme: ThemeData(extensions: const [SuperThemeData.dark]),
/// );
/// final t = SuperThemeData.of(context); // falls back to .dark
/// ```
///
/// ---
///
/// ## Exported symbols
///
/// | Symbol | Purpose |
/// |---|---|
/// | [SuperPalette] | Six built-in palettes (10 shades + semantic getters) |
/// | [SuperMaterialThemeData] | Material 3 ThemeData generator |
/// | [SuperTokens] | Theme-independent brand constants |
/// | [SuperThemeData] | Swappable light/dark ThemeExtension |
/// | [SuperText] | GeniusLink type ramp as TextStyles |
/// | [SuperFormat] | Intl-free formatters |
/// | [SuperMarker] | Section-marker bar intents |
/// | Widgets | SectionCard, SectionHeader, StatusPill, SuperButton, Hairline, FieldShell, SuperCard, SuperDialog, SuperSnackBar, SuperAppBar |
///
/// Import this single barrel to get the whole foundation:
///
/// ```dart
/// import 'package:super_core/super_core.dart';
/// ```
library super_core;

export 'src/core/core.dart';
