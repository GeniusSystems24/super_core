/// Super Core — the shared GeniusLink design-system foundation for the Super
/// toolkit. Single source of truth for the visual identity that every Super
/// package reads from, so the whole toolkit looks like one product.
///
/// ## v2.0.0 — dynamic brand tokens, custom fonts, forked app bars
///
/// **Breaking.** The former `static const` `SuperTokens` class is removed. Brand
/// tokens (accent + semantic palette, font families, radii, the 4px spacing
/// scale, control metrics, motion) are now the instance fields of the immutable
/// [SuperTokensData] carried by the theme ([SuperThemeData.tokens] /
/// [SuperMaterialThemeData.tokens]) — so a theme can override any of them:
///
/// ```dart
/// SuperMaterialThemeData.light(
///   tokens: const SuperTokensData(radiusCard: 12), // dynamic override
/// );
/// final tokens = SuperThemeData.of(context).tokens; // read at a call site
/// ```
///
/// Every field keeps its historical value as a `SuperTokensData.default*`
/// compile-time constant (e.g. `SuperTokensData.defaultSpace4`), so const call
/// sites still resolve.
///
/// **Custom fonts.** [SuperMaterialThemeData.light] / `.dark` accept a
/// `fontFamily`, and a `textTheme` whose family is honored when
/// `mergeTextTheme` is `true` (the family is applied over the default GeniusLink
/// type ramp, preserving its sizes / weights / spacing).
///
/// **Widgets.** [SuperAppBar] and [SuperSliverAppBar] are full forks of
/// Flutter's `AppBar` / `SliverAppBar` with a positionable subtitle
/// ([SubtitlePosition]) and responsive action overflow ([SuperAppBarTheme]).
/// [SuperCard] gains expand/collapse (vertical or horizontal) plus `leading` /
/// `trailing` slots ([SuperCardTheme]). `SuperDialog` is removed — use Flutter's
/// themed `showDialog` / `AlertDialog` (styled by [SuperMaterialThemeData]).
///
/// ## v1.3.0 — complete ThemeData + ColorScheme
///
/// [SuperMaterialThemeData] now generates a GeniusLink default for *every*
/// [ThemeData] property (top-level colors, density, the remaining component
/// themes) and [SuperPalette]'s color schemes fill *every* Material 3 role
/// (the fixed accent roles + the full surface-container ramp). The Scaffold is
/// painted [ColorScheme.surface] (the page background); the app bar rides the
/// card surface and keeps the OS status + navigation bars in sync via
/// `systemOverlayStyle`. Precedence is unchanged:
/// explicit override > palette-generated > Flutter default.
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
/// | [SuperMaterialThemeData] | Material 3 ThemeData generator (+ `tokens`, `fontFamily`, `mergeTextTheme`) |
/// | [SuperTokensData] | Dynamic brand tokens carried by the theme (with `default*` constants) |
/// | [SuperThemeData] | Swappable light/dark ThemeExtension (carries `tokens`) |
/// | [SuperAppBarTheme] | `AppBarTheme` + subtitle position + responsive action limits |
/// | [SuperCardTheme] | `CardThemeData` + expand / leading-trailing defaults |
/// | [SuperText] | GeniusLink type ramp as TextStyles |
/// | [SuperFormat] | Intl-free formatters |
/// | [SuperMarker] | Section-marker bar intents |
/// | Widgets | SectionCard, SectionHeader, StatusPill, SuperButton, Hairline, FieldShell, SuperCard, SuperSnackBar, SuperAppBar, SuperSliverAppBar |
///
/// Import this single barrel to get the whole foundation:
///
/// ```dart
/// import 'package:super_core/super_core.dart';
/// ```
library super_core;

export 'src/core/core.dart';
