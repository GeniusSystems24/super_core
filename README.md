# Super Core

The shared **GeniusLink** design-system foundation for the Super toolkit. It is
the single source of truth for the visual identity — colors, font sizes, field
sizes, spacing, radii, motion, theme, formatters and the design-system widgets —
so every Super package reads as one product.

Depended on by:

- `super_auto_suggestion_box`
- `super_form_field`
- `super_map`
- `super_table_field`
- `super_tree`

## What's inside

| Symbol | Purpose |
|---|---|
| `SuperTokens` | Theme-independent brand constants: the electric-blue accent + semantic palette, the three font families (Manrope · Inter · JetBrains Mono · Noto Naskh Arabic), radii, the 4px spacing scale, control + **field sizes**, and motion curves. |
| `SuperThemeData` | The swappable light/dark `ThemeExtension` — surfaces, hairline borders, the `fg1…fg4` text ramp, card/popover shadows, and accent/semantic tint helpers (`tint`, `tintOnBg`, `tintFill`, `selectionFill`). |
| `SuperText` | The GeniusLink type ramp as ready-made `TextStyle`s (colorless — apply an `fg*` token at the call site). |
| `SuperFormat` | Intl-free number / currency / byte / serial formatters. |
| `SuperMarker` | The three section-marker intents (identity / ledger / notes). |
| Widgets | `SectionCard`, `SectionHeader`, `StatusPill`, `SuperButton`, `Hairline`, `FieldShell`. |
| Plumbing | failures, typedefs, usecases, key-direction + `BuildContext` helpers. |

## Usage

```dart
import 'package:super_core/super_core.dart';

MaterialApp(
  theme:     ThemeData(extensions: const [SuperThemeData.light]),
  darkTheme: ThemeData(extensions: const [SuperThemeData.dark]),
);

// at a call site:
final t = SuperThemeData.of(context); // falls back to .dark
Text('TOTAL', style: SuperText.label.copyWith(color: t.fg2));
```

Drop the brand `.ttf` files under `assets/fonts/` and uncomment the `fonts:`
block in `pubspec.yaml` to match the design system pixel-for-pixel.
