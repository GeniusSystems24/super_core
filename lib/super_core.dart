/// Super Core — the shared GeniusLink design-system foundation for the Super
/// toolkit. Single source of truth for the visual identity that every Super
/// package reads from, so the whole toolkit looks like one product.
///
/// ## v3.0.0 - layout primitives and consolidated section surfaces
///
/// Adds the Super layout family: [SuperBreakpoint], [SuperBreakpoints],
/// [SuperBreakpointProvider], [SuperGrid], [SuperGridCell], [SuperGridScope],
/// and [SuperScaffold].
///
/// **Breaking.** `SectionCard`, `SuperSection`, and `SuperCard` are replaced by
/// [SuperSectionCard]. `SectionHeader` is replaced by [SuperSectionHeader].
/// The consolidated card keeps section headers, footers, `child`/`children`,
/// collapse, selected/tap states, Material-card fill/elevation/shape options,
/// and expandable detail content in one public widget.
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
/// final typography = SuperTextTheme();
/// SuperMaterialThemeData.light(
///   textTheme: typography,
///   primaryTextTheme: typography,
///   tokens: const SuperTokensData(radiusCard: 12), // dynamic override
/// );
/// final tokens = SuperThemeData.of(context).tokens; // read at a call site
/// ```
///
/// There are NO static token constants — read every token dynamically from
/// the ambient theme (`SuperThemeData.of(context).tokens.x`). The default
/// values live only as the literals in the `SuperTokensData` constructor; the
/// single default instance is `SuperTokensData.fallback`.
///
/// **Typography.** [SuperMaterialThemeData.light] / `.dark` require explicit
/// [SuperTextTheme] values for `textTheme` and `primaryTextTheme`. Typography is
/// owned by the Material theme rather than [SuperThemeData]; read branded styles
/// through `context.superTextTheme` or [SuperMaterialThemeData.textTheme].
///
/// **Widgets.** [SuperAppBar] and [SuperSliverAppBar] are full forks of
/// Flutter's `AppBar` / `SliverAppBar` with a positionable subtitle
/// ([SubtitlePosition]) and responsive action overflow ([SuperAppBarTheme]).
/// [SuperSectionCard] carries the section/card expand-collapse behavior and
/// reads defaults from [SuperCardTheme]. `SuperDialog` is removed ? use Flutter's
/// themed `showDialog` / `AlertDialog` (styled by [SuperMaterialThemeData]).
///
/// ## v1.3.0 — complete ThemeData + ColorScheme
///
/// [SuperMaterialThemeData] now generates a GeniusLink default for *every*
/// [ThemeData] property (top-level colors, density, the remaining component
/// themes) and [SuperPalette]'s color schemes fill *every* Material 3 role
/// (the fixed accent roles + the full surface-container ramp). The Scaffold and
/// app bar are painted [ColorScheme.surface] (the page background) while cards
/// and fields sit on lifted surface tokens; the OS status + navigation bars are
/// kept in sync via `systemOverlayStyle`. Precedence is unchanged:
/// explicit override > palette-generated > Flutter default.
///
/// ## v1.0.0 — SuperPalette + SuperMaterialThemeData
///
/// Pick a palette and generate complete Material 3 [ThemeData]:
///
/// ```dart
/// final typography = SuperTextTheme();
/// MaterialApp(
///   theme: SuperMaterialThemeData.light(
///     palette: SuperPalette.bluePalette,
///     textTheme: typography,
///     primaryTextTheme: typography,
///   ),
///   darkTheme: SuperMaterialThemeData.dark(
///     palette: SuperPalette.bluePalette,
///     textTheme: typography,
///     primaryTextTheme: typography,
///   ),
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
/// | [SuperMaterialThemeData] | Material 3 ThemeData generator (+ required `SuperTextTheme` typography, tokens, and palette) |
/// | [SuperTokensData] | Dynamic brand tokens carried by the theme (with `default*` constants) |
/// | [SuperThemeData] | Swappable light/dark ThemeExtension (carries `tokens`) |
/// | [SuperAppBarTheme] | `AppBarTheme` + subtitle position + responsive action limits |
/// | [SuperCardTheme] | `CardThemeData` + section-card expand / border defaults |
/// | [SuperTextTheme] | Responsive named type ramp (displayLg → labelSm), built from tokens via `GoogleFonts` |
/// | [SuperFormat] | Intl-free formatters |
/// | [SuperMarker] | Section-marker bar intents |
/// | Layout | SuperBreakpoint, SuperBreakpoints, SuperBreakpointProvider, SuperGrid, SuperGridCell, SuperGridScope, SuperScaffold |
/// | Widgets | SuperSectionCard, SuperSectionHeader, SuperSectionFooter, AccentSectionCard, StatusPill, SuperButton, SuperConfirmView, SuperConfirmDialog, SuperFieldView, SuperFieldDialog, Hairline, FieldShell, SuperSnackBar, SuperAppBar, SuperSliverAppBar |
///
/// Import this single barrel to get the whole foundation:
///
/// ```dart
/// import 'package:super_core/super_core.dart';
/// ```
library super_core;

export 'src/core/core.dart';
