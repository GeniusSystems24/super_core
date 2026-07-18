# Super Core

The shared **GeniusLink** design-system foundation for the Super toolkit —
the single source of truth for colors, palettes, Material themes, typography,
spacing, radii, motion, formatters, and design-system widgets.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  super_core: ^2.0.0  # monorepo path dependency
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
| `super_navigation_sidebar` | Responsive app navigation sidebar |
| `super_naviagtion_page` | Overlay / sheet navigation surfaces |

---

## What's inside

| Symbol | Purpose |
|---|---|
| `SuperPalette` | Six swappable color palettes, each with 10 shades + semantic getters |
| `SuperMaterialThemeData` | Complete Material 3 theme — **a `ThemeData` subclass** (palette + responsive `SuperDeviceMode`) |
| `SuperDeviceMode` | `mobile` / `tablet` / `desktop` device mode + `SuperResponsive<T>` container |
| `SuperMetrics` | Responsive spacing / sizing / padding / margin token bundle |
| `SuperInteractiveStateThemeData` | Hover / focus / pressed / selected overlay treatment (`ThemeExtension`) |
| `SuperTokensData` | **Dynamic** brand tokens carried by the theme (accent + semantic palette, font families, spacing, radii, motion). Every field also has a `default*` compile-time constant. Replaces the removed `static const` `SuperTokens`. |
| `SuperThemeData` | Swappable light/dark `ThemeExtension` — surfaces, borders, `fg1…fg4` text ramp, and `tokens` |
| `SuperAppBarTheme` | `AppBarTheme` subclass — adds `subtitlePosition` + responsive `maxActions` / `maxMobileActions` / `maxTabletActions` / `maxDesktopActions` |
| `SuperCardTheme` | `CardThemeData` subclass — adds expand direction / duration / curve, tap-to-toggle, chevron, padding, border colors |
| `SuperText` | GeniusLink type ramp as `TextStyle`s (Manrope / Inter / JetBrains Mono) |
| `SuperFormat` | Intl-free number / currency / byte / serial formatters |
| `SuperMarker` | Three section-marker intents (identity / ledger / notes) |
| Widgets | `SectionCard`, `SectionHeader`, `StatusPill`, `SuperButton`, `Hairline`, `FieldShell`, `SuperCard`, `SuperSnackBar`, `SuperAppBar`, `SuperSliverAppBar` |
| Plumbing | Failures, typedefs, usecases, key-direction + `BuildContext` helpers |

> **Migrating from v1?** `SuperTokens.x` → `SuperThemeData.of(context).tokens.x`
> for the live theme value, or `SuperTokensData.defaultX` in a `const` context.
> `SuperDialog` is removed — use Flutter's `showDialog` / `AlertDialog` (already
> styled by `SuperMaterialThemeData`). See the `skill/migration_v1_to_v2/` guides.

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

`SuperMaterialThemeData` **extends `ThemeData`** — it *is* a Material theme, so
`Theme.of(context) is SuperMaterialThemeData` is `true`. Generate a complete
Material 3 theme from a palette and a device mode:

```dart
MaterialApp(
  theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
  darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
  // palette + mode are optional — default SuperPalette.bluePalette / SuperDeviceMode.mobile
);
```

### Constructor overrides & precedence

Both `.light` and `.dark` accept `palette`, `mode`, and per-component overrides
(`textTheme`, `appBarTheme`, `navigationBarTheme`, `buttonTheme`,
`formFieldTheme`, `cardTheme`, `dialogTheme`, `tableTheme`, `dividerTheme`,
`iconTheme`, `interactiveStateTheme`, `extensions`). Precedence is
**explicit override > palette-generated > Flutter default**. `.light()` always
produces `Brightness.light`; `.dark()` always `Brightness.dark`.

### Context lookups

```dart
SuperMaterialThemeData? m = SuperMaterialThemeData.maybeOf(context); // null if not a Super theme
SuperMaterialThemeData  t = SuperMaterialThemeData.of(context);      // always valid; wraps a plain ThemeData, preserving its config
```

### Responsive device mode

```dart
// Pick a mode from the current width and rebuild the theme responsively:
final mode = SuperDeviceMode.of(context); // tablet ≥ 600, desktop ≥ 1024
SuperMaterialThemeData.light(mode: mode);

// Responsive tokens (spacing grows with the viewport; control heights shrink):
final s = SuperThemeData.of(context);
s.padding.card;   s.spacing.lg;   s.sizing.control;   s.margin.section;

// Author your own responsive value with the same container:
const gutter = SuperResponsive<double>(mobile: 16, tablet: 24, desktop: 32);
gutter.resolve(mode);
```

The generated `TextTheme` and `InputDecorationTheme` also scale per mode
(font size / line height, and field padding / density / height / border /
icon constraints). Caller `textTheme:` / `formFieldTheme:` override these
wholesale.

### Runtime palette switching
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

- Complete `ColorScheme` derived from the palette — including the Material 3
  **fixed** accent roles (`primaryFixed`, `primaryFixedDim`, `onPrimaryFixed`,
  `onPrimaryFixedVariant`, and the secondary/tertiary equivalents) and the full
  **surface-container ramp** (`surfaceDim`, `surfaceBright`,
  `surfaceContainerLowest` → `surfaceContainerHighest`)
- Typography wired to Manrope / Inter / JetBrains Mono
- **Scaffold background = `ColorScheme.surface`** (the GeniusLink page
  background). Cards, panels, fields and app bars sit on the brighter
  `surfaceContainer` ramp / card surface so they stay clearly separated from the
  Scaffold
- **App bar** painted on the elevated card surface (distinct from the Scaffold)
  with a `systemOverlayStyle` that paints the **status bar and navigation bar**
  the same color and picks status/nav icon brightness automatically for contrast
- All button variants (elevated, outlined, text, filled, icon)
- Input decoration (4 px radius, `fieldComfortable` height)
- Navigation bar, rail, drawer, bottom navigation bar, bottom app bar
- Dialog, bottom sheet, popup menu, tooltip, snack bar, material banner
- Card, chip, tab bar, segmented button, toggle buttons, badge
- Switch, checkbox, radio, slider, progress indicator
- Data table (hover row, label headers)
- Date picker, time picker, search bar, search view, dropdown menu, menu bar
- Text selection (cursor / handle / selection tint)
- Scrollbar, FAB, expansion tile, menu
- Top-level color roles (`focusColor`, `hoverColor`, `highlightColor`,
  `splashColor`, `hintColor`, `primaryColor` + dark/light, `shadowColor`,
  `secondaryHeaderColor`, `unselectedWidgetColor`), `visualDensity`,
  `materialTapTargetSize`, `splashFactory`, `applyElevationOverlayColor`

> Precedence is always **explicit constructor override > palette-generated >
> Flutter default** — the generated values above only fill in what you do not
> pass. Host-derived fields (`platform`, `cupertinoOverrideTheme`,
> `pageTransitionsTheme`, `typography`) are left to Flutter unless overridden.

### SuperThemeData auto-registration

`SuperMaterialThemeData` carries a `superTheme` field AND registers that same
`SuperThemeData` instance as a `ThemeExtension`, so `theme.superTheme` and
`Theme.of(context).extension<SuperThemeData>()` always agree, and every Super
component that calls `SuperThemeData.of(context)` picks up the palette-,
brightness- and device-mode-derived tokens automatically:

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

## Dynamic brand tokens (`SuperTokensData`)

Brand tokens are no longer `static const` — they are instance fields on the
immutable `SuperTokensData` the theme carries, so any of them can be overridden
per theme. Every field keeps its historical value as a `default*` constant, so
`const SuperTokensData()` reproduces the GeniusLink defaults exactly.

```dart
// Override tokens on the generated theme:
SuperMaterialThemeData.light(
  palette: SuperPalette.bluePalette,
  tokens: const SuperTokensData(radiusCard: 12, space4: 20),
);

// Read the active tokens at any call site:
final tokens = SuperThemeData.of(context).tokens;
SizedBox(height: tokens.space4);
BorderRadius.circular(tokens.radiusCard);
color: SuperMarker.ledger.resolve(tokens);

// In a const context, reference the brand default constant:
const SizedBox(height: SuperTokensData.defaultSpace4);
```

## Custom font family

Change the toolkit's font without losing the GeniusLink type ramp. Precedence:
explicit `fontFamily` > the family carried by a provided `textTheme` (when
`mergeTextTheme` is `true`) > the token default.

```dart
// Simplest — swap the whole workhorse/display family:
SuperMaterialThemeData.light(fontFamily: 'IBM Plex Sans');

// Merge a TextTheme's font over the default ramp (sizes/weights preserved):
SuperMaterialThemeData.light(
  textTheme: GoogleFonts.ibmPlexSansTextTheme(),
  mergeTextTheme: true, // default — keeps SuperMaterialThemeData typography, adopts the font
);

// Replace the ramp wholesale instead:
SuperMaterialThemeData.light(textTheme: myTextTheme, mergeTextTheme: false);
```

## App bars — `SuperAppBar` / `SuperSliverAppBar`

Full forks of Flutter's `AppBar` / `SliverAppBar` (every property is
customizable) plus two GeniusLink features: a positionable **subtitle** and
**responsive action overflow** — extra actions past the limit collapse into a
three-dot menu. The limit is resolved per device class (mobile 3 / tablet 4 /
desktop 5) unless you set `maxActions` or the per-device overrides.

```dart
Scaffold(
  appBar: SuperAppBar(
    title: const Text('Create Store'),
    subtitle: const Text('STORES & PRODUCTS • STORES'),
    subtitlePosition: SubtitlePosition.above, // or .below (default)
    actions: [/* > maxActions collapse into a ⋮ overflow */],
    // maxActions / maxMobileActions / maxTabletActions / maxDesktopActions
  ),
);

CustomScrollView(slivers: [
  SuperSliverAppBar(
    pinned: true,
    expandedHeight: 200,
    title: const Text('Journal'),
    subtitle: const Text('BANKING • LOCAL TRANSFERS'),
    flexibleSpace: const FlexibleSpaceBar(background: LedgerHeaderArt()),
    actions: [/* … */],
  ),
]);
```

Defaults come from the `SuperAppBarTheme` installed into
`ThemeData.appBarTheme` by `SuperMaterialThemeData`; override it via
`appBarTheme:` on the theme constructor.

## Expandable `SuperCard`

`SuperCard` can reveal `expandedChild` on tap or via its chevron, along the
vertical **or** horizontal axis, and hosts `leading` / `trailing` slots.
Defaults come from the `SuperCardTheme` in `ThemeData.cardTheme`.

```dart
SuperCard(
  leading: const Icon(Icons.storefront_outlined),
  header: const SectionHeader(title: 'Downtown Central Store'),
  trailing: const StatusPill('ACTIVE', tone: PillTone.success),
  expandedChild: const StoreDetailTable(), // revealed on tap / chevron
  // expandDirection: Axis.horizontal, initiallyExpanded, isExpanded, onExpansionChanged…
  child: const StoreSummary(),
);
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
