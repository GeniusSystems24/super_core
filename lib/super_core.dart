/// Super Core — the shared GeniusLink design-system foundation for the Super
/// toolkit. It is the single source of truth for the visual identity that every
/// Super package reads from, so the whole toolkit looks like one product:
///
///   • `SuperTokens`     — theme-independent brand constants: the electric-blue
///                         accent + semantic palette, the three font families,
///                         radii, the 4px spacing scale, control + field sizes,
///                         and motion curves.
///   • `SuperThemeData`  — the swappable light/dark `ThemeExtension` (surfaces,
///                         borders, the `fg1…fg4` text ramp, card/popover
///                         shadows, accent/semantic tints).
///   • `SuperText`       — the GeniusLink type ramp as ready-made `TextStyle`s.
///   • `SuperFormat`     — intl-free number / currency / byte / serial helpers.
///   • shared widgets    — `SectionCard`, `SectionHeader`, `StatusPill`,
///                         `SuperButton`, `Hairline`, `FieldShell`.
///   • shared plumbing   — failures, typedefs, usecases, key-direction + context
///                         helpers.
///
/// Register the theme once and every Super component themes from here:
///
/// ```dart
/// MaterialApp(
///   theme:     ThemeData(extensions: const [SuperThemeData.light]),
///   darkTheme: ThemeData(extensions: const [SuperThemeData.dark]),
/// );
/// final t = SuperThemeData.of(context); // falls back to .dark
/// ```
///
/// Import this single barrel to get the whole foundation:
///   `import 'package:super_core/super_core.dart';`
library super_core;

export 'src/core/core.dart';
