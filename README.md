# Super Core

The shared **GeniusLink** design-system foundation for the Super toolkit —
the single source of truth for colors, palettes, Material themes, typography,
spacing, radii, motion, formatters, and design-system widgets.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  super_core: ^1.0.0  # monorepo path dependency
```

Then import the barrel:

```dart
import 'package:super_core/super_core.dart';
```

---

## Packages that depend on super_core

| Package | Purpose |
|---|---|
| `super_auto_suggestion_box` | Typeahead / combobox |
| `super_form_field` | Eight GeniusLink form field types |
| `super_map` | Node-graph canvas |
| `super_tab_bar` | Browser-style workspace tab bar |
| `super_table_field` | ERP data grid |
| `super_tree` | Recursive hierarchy / chart of accounts |

---

## What's inside

| Symbol | Purpose |
|---|---|
| `SuperPalette` | Six swappable color palettes, each with 10 shades + semantic getters |
| `SuperMaterialThemeData` | Complete Material 3 `ThemeData` generator |
| `SuperTokens` | Theme-independent brand constants (accent, semantic palette, font families, spacing, radii, motion) |
| `SuperThemeData` | Swappable light/dark `ThemeExtension` — surfaces, borders, `fg1…fg4` text ramp |
| `SuperText` | GeniusLink type ramp as `TextStyle`s (Manrope / Inter / JetBrains Mono) |
| `SuperFormat` | Intl-free number / currency / byte / serial formatters |
| `SuperMarker` | Three section-marker intents (identity / ledger / notes) |
| Widgets | `SectionCard`, `SectionHeader`, `StatusPill`, `SuperButton`, `Hairline`, `FieldShell` |
| Plumbing | Failures, typedefs, usecases, key-direction + `BuildContext` helpers |

---

## SuperPalette

Six built-in palettes:

| Palette | `shade500` | Notes |
|---|---|---|
| `SuperPalette.bluePalette` | `#4A7CFF` | Default GeniusLink accent |
| `SuperPalette.purplePalette` | `#7C5CFC` | Violet / indigo |
| `SuperPalette.greenPalette` | `#1DB88A` | GeniusLink success green |
| `SuperPalette.goldenPalette` | `#F59E0B` | Warm amber / gold |
| `SuperPalette.grayPalette` | `#64748B` | Neutral grays |
| `SuperPalette.monochromePalette` | `#737373` | Pure black / white |

Each palette exposes ten shades (`shade50` … `shade900`) and semantic
accessors: `primary`, `primaryDark`, `onPrimary`, `error`, `success`,
`warning`, plus light/dark surface tokens (`lightBg`, `darkSurface`,
`darkFg1`, …).

All six palettes use the same **GeniusLink-standard neutral surfaces** — only
the accent/primary color varies. This preserves the precision-instrument feel
of the design system regardless of which palette is active.

---

## SuperMaterialThemeData

Generate a complete Material 3 `ThemeData`:

```dart
MaterialApp(
  theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
  darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
  // palette is optional — defaults to SuperPalette.bluePalette
);
```

### Runtime palette switching

```dart
class _MyAppState extends State<MyApp> {
  SuperPalette _palette = SuperPalette.bluePalette;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:     SuperMaterialThemeData.light(palette: _palette),
      darkTheme: SuperMaterialThemeData.dark(palette: _palette),
      home: MyHome(
        onPaletteChanged: (p) => setState(() => _palette = p),
      ),
    );
  }
}
```

### What's configured

- `ColorScheme` derived from the palette
- Typography wired to Manrope / Inter / JetBrains Mono
- App bar, scaffold background
- All button variants (elevated, outlined, text, filled, icon)
- Input decoration (4 px radius, `fieldComfortable` height)
- Navigation bar, rail, drawer
- Dialog, bottom sheet, popup menu, tooltip, snack bar
- Card, chip, tab bar, segmented button
- Switch, checkbox, radio, slider, progress indicator
- Data table (hover row, label headers)
- Scrollbar, FAB, expansion tile, menu

### SuperThemeData auto-registration

`SuperMaterialThemeData` registers `SuperThemeData` as a `ThemeExtension`, so
every Super component that calls `SuperThemeData.of(context)` picks up the
palette-derived surface tokens automatically:

```dart
// In any Super component — no extra setup needed when using SuperMaterialThemeData:
final t = SuperThemeData.of(context);
Text('TOTAL', style: SuperText.label.copyWith(color: t.fg2));
```

---

## SuperThemeData — pre-v1.0.0 API (unchanged)

```dart
// Manual registration — still supported:
MaterialApp(
  theme:     ThemeData(extensions: const [SuperThemeData.light]),
  darkTheme: ThemeData(extensions: const [SuperThemeData.dark]),
);

final t = SuperThemeData.of(context); // falls back to .dark
```

---

## Font setup

Drop the brand `.ttf` files under `assets/fonts/` and uncomment the `fonts:`
block in `pubspec.yaml`:

| Family | Role |
|---|---|
| Manrope | Display — H1 page titles, watermark |
| Inter | Body, labels, buttons, captions |
| JetBrains Mono | Numerics, serials, audit log |
| Noto Naskh Arabic | Arabic glyphs |
