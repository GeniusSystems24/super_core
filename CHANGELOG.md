# Changelog

All notable changes to **super_core** are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/); versioning is
[SemVer](https://semver.org/).

---

## [1.1.0] — 2026-07-16

### Added

#### SuperMaterialThemeData is now a ThemeData subclass

`SuperMaterialThemeData` **extends `ThemeData`** (via a private `super.raw`
delegating constructor). It IS a Material theme — `Theme.of(context) is
SuperMaterialThemeData` is `true`, and it drops straight into `MaterialApp.theme`
/ `darkTheme`. The old `SuperMaterialThemeData.light(...)` / `.dark(...)` call
sites keep working (they are now factory constructors instead of statics).

New constructor parameters (both `.light` and `.dark`), each an explicit
override with precedence **explicit arg > palette-generated > Flutter default**:

```dart
SuperMaterialThemeData.light({
  SuperPalette palette = SuperPalette.bluePalette,
  SuperDeviceMode mode = SuperDeviceMode.mobile,
  TextTheme? textTheme,
  AppBarTheme? appBarTheme,
  NavigationBarThemeData? navigationBarTheme,
  ButtonThemeData? buttonTheme,
  InputDecorationTheme? formFieldTheme,
  CardThemeData? cardTheme,
  DialogThemeData? dialogTheme,
  DataTableThemeData? tableTheme,
  DividerThemeData? dividerTheme,
  IconThemeData? iconTheme,
  SuperInteractiveStateThemeData? interactiveStateTheme,
  List<ThemeExtension<dynamic>>? extensions,
});
```

- `.light()` always yields `Brightness.light`; `.dark()` always
  `Brightness.dark`.
- `copyWith` now returns a `SuperMaterialThemeData` (preserving the concrete
  type, `superTheme` and `mode`) and **merges** extensions rather than replacing
  them. Forwarded `ThemeData` parameters are typed `dynamic` so the override
  stays valid across Flutter's `XxxTheme`→`XxxThemeData` component-theme
  migration.

#### `superTheme` field + theme-extension synchronization

- New `final SuperThemeData superTheme;` field on `SuperMaterialThemeData`.
- The same `SuperThemeData` instance is registered in `ThemeData.extensions`, so
  `Theme.of(context).extension<SuperThemeData>()` and `theme.superTheme` always
  agree.
- Caller-supplied extensions are merged in (never dropped), `SuperThemeData` and
  `SuperInteractiveStateThemeData` are de-duplicated, and the field + extension
  stay in sync through `copyWith`.

#### Context lookups

```dart
static SuperMaterialThemeData? maybeOf(BuildContext context); // null if not a Super theme
static SuperMaterialThemeData  of(BuildContext context);      // always valid
static SuperMaterialThemeData  fromThemeData(ThemeData theme); // safe wrap
```

`of` (and `fromThemeData`) preserve an ambient plain `ThemeData`'s colors,
component themes and any registered `SuperThemeData` extension instead of
discarding application-level configuration.

#### Responsive device mode

- `SuperMaterialThemeData.light` / `.dark` take `SuperDeviceMode mode`
  (default `SuperDeviceMode.mobile`), driving responsive **spacing, sizing,
  padding, margin, typography and input-decoration** from the centralized
  `SuperMetrics` tokens. All three device configurations remain reachable via the
  static `SuperMetrics.*Responsive` / `SuperResponsive<T>` containers while the
  active mode's values are exposed as the live tokens.
- The generated `TextTheme` is scaled per mode (mobile ~+6 %, tablet ~+2 %,
  desktop baseline) with per-role line-height / letter-spacing.
- The generated `InputDecorationTheme` adjusts content padding, density
  (`isDense` on desktop), field height, label/hint/error/helper styles, border
  radius and icon constraints per mode.

### Changed

- `pubspec.yaml`: version → `1.1.0`; minimum raised to `dart >=3.8.0`,
  `flutter >=3.32.0` (targets the ~3.32 Material 3 `ThemeData` surface).
- `lib/src/core/core.dart` barrel now also exports `super_device_mode.dart`,
  `super_metrics.dart` and `super_interactive_state_theme.dart`, surfacing
  `SuperDeviceMode`, `SuperResponsive`, `SuperMetrics`,
  `SuperSpacing/Sizing/Padding/Margin` and `SuperInteractiveStateThemeData`.
- The internal top-level `lerpDouble` helper in `super_metrics.dart` was made
  private (`_lerpDouble`) so exporting the file through the public barrel no
  longer collides with `dart:ui`'s `lerpDouble` in consumer packages.

### Related packages

The three toolkit packages that own a `ThemeExtension` gained a
`.fromMaterialTheme(SuperMaterialThemeData)` bridge and prefer it in `.of()`
(explicit extension → `SuperMaterialThemeData` → fallback):
`SuperTabBarThemeData`, `AutoSuggestionsBoxThemeData`,
`NavigationSidebarThemeData`. The five extension-less packages
(`super_form_field`, `super_map`, `super_tree`, `super_table_field`,
`super_naviagtion_page`) already derive from the material theme transitively via
the auto-registered `SuperThemeData`.

### Migration from 1.0.0

Fully backward compatible. Existing `SuperMaterialThemeData.light()` /
`.dark()` calls and `ThemeData(extensions: const [SuperThemeData.light])` wiring
are unchanged. To adopt responsiveness, pass `mode:` (or omit for the
mobile default). `Theme.of(context)` now returns a `SuperMaterialThemeData` when
one is installed — use `SuperMaterialThemeData.of(context)` /
`maybeOf(context)` for typed access.

---

## [1.0.0] — 2026-07-14

### Added

#### SuperPalette

New `SuperPalette` class with six built-in palettes, each providing 10 ordered
color shades (50–900) and derived semantic accessors.

**Built-in palettes:**

| Palette | `shade500` | Notes |
|---|---|---|
| `SuperPalette.bluePalette` | `#4A7CFF` | Default GeniusLink accent = `SuperTokens.accent` |
| `SuperPalette.purplePalette` | `#7C5CFC` | Violet / indigo |
| `SuperPalette.greenPalette` | `#1DB88A` | GeniusLink success = `SuperTokens.success` |
| `SuperPalette.goldenPalette` | `#F59E0B` | Warm amber / gold |
| `SuperPalette.grayPalette` | `#64748B` | Neutral grays — mirrors GeniusLink surface ramp |
| `SuperPalette.monochromePalette` | `#737373` | Pure black / white |

**Semantic getters per palette:** `primary`, `primaryDark`, `onPrimary`,
`onPrimaryDark`, `error`, `errorDark`, `success`, `warning` (last three are
cross-palette GeniusLink brand tokens, identical across all palettes).

**Surface token accessors:** `lightBg / darkBg`, `lightSurface / darkSurface`,
`lightInputBg / darkInputBg`, `lightHover / darkHover`,
`lightBorder / darkBorder`, `lightBorderStr / darkBorderStr`,
`lightFg1…lightFg4 / darkFg1…darkFg4` — all matching the GeniusLink neutral
ramp. All six palettes share the same neutral surfaces; only the accent/primary
color varies between them.

**ColorScheme generation:** `toLightColorScheme()` and `toDarkColorScheme()`
produce a complete Material 3 `ColorScheme` from the palette. In dark mode,
`primary` becomes `shade300` for legibility against dark surfaces.

`SuperPalette.values` — ordered list of all six built-in palettes.

#### SuperMaterialThemeData

New `SuperMaterialThemeData` abstract class with two static factory methods:

```dart
SuperMaterialThemeData.light({SuperPalette palette = SuperPalette.bluePalette})
SuperMaterialThemeData.dark({SuperPalette palette = SuperPalette.bluePalette})
```

The generated `ThemeData` (`useMaterial3: true`) configures:

- Full `ColorScheme` derived from the palette
- `textTheme` wired to Manrope / Inter / JetBrains Mono
- `AppBarTheme`, `scaffoldBackgroundColor`
- `CardTheme` — 8 px radius, hairline border, no surface tint
- `ElevatedButtonTheme`, `OutlinedButtonTheme`, `TextButtonTheme`,
  `FilledButtonTheme`, `IconButtonTheme`
- `InputDecorationTheme` — 4 px radius, `fieldComfortable` height
- `NavigationBarTheme`, `NavigationRailTheme`, `DrawerTheme`
- `DialogTheme`, `BottomSheetTheme`
- `ChipTheme`, `TabBarTheme`, `SegmentedButtonTheme`
- `PopupMenuTheme`, `MenuTheme`, `TooltipTheme`, `SnackBarTheme`
- `DividerTheme`, `ListTileTheme`, `ExpansionTileTheme`
- `DataTableTheme` — hover row, audit-grade label style
- `SwitchTheme`, `CheckboxTheme`, `RadioTheme`, `SliderTheme`
- `ProgressIndicatorTheme`, `FloatingActionButtonTheme`
- `ScrollbarTheme` — 4 px thumb, primary-tinted on hover/drag
- `IconTheme`, `PrimaryIconTheme`

Registers `SuperThemeData` as a `ThemeExtension` — every Super component that
calls `SuperThemeData.of(context)` adapts to the active palette and brightness
without additional setup.

All colors are derived from the `ColorScheme` or the palette's neutral-surface
constants — no hardcoded color values in the generated `ThemeData`.

#### Example app

New `example/` Flutter app demonstrating:

- Live palette switching across all six palettes
- Light / Dark / System mode toggle
- Generated `ColorScheme` role swatches
- All palette shade swatches (50–900)
- Common Material components (buttons, inputs, cards, chips, switches,
  checkboxes, sliders, navigation bar, data table, typography ramp)

### Changed

- `pubspec.yaml`: version bumped to `1.0.0`; minimum Flutter raised to
  `>=3.16.0` to leverage full Material 3 component theming APIs.
- `lib/src/core/core.dart` barrel: exports `super_palette.dart` and
  `super_material_theme.dart`.
- `lib/super_core.dart` library doc: updated with v1.0.0 usage examples.

### Migration from 0.x

`SuperThemeData`-based wiring continues to work unchanged. To adopt the new
Material-native palette system, replace your `ThemeData(extensions: ...)` setup
with:

```dart
MaterialApp(
  theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
  darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
);
```

`SuperThemeData` is registered automatically by `SuperMaterialThemeData`, so
`SuperThemeData.of(context)` continues to work in all Super components.

---

## [0.1.0] — 2026-06-19

### Added

- Extracted the shared GeniusLink foundation into its own package.
- `SuperTokens`, `SuperThemeData`, `SuperText`, `SuperFormat`, `SuperMarker`.
- Design-system widgets: `SectionCard`, `SectionHeader`, `StatusPill`,
  `SuperButton`, `Hairline`, `FieldShell`.
- `SuperTokens` gains form-field size metrics (`fieldComfortable`,
  `fieldCompact`, `stepperSize`, `trailingIcon`).
- `SuperThemeData` gains `tint` / `tintOnBg` / `tintFill` / `selectionFill`
  tint helpers.
- `SuperFormat` gains the null-safe `number(...)` helper.
- `super_auto_suggestion_box`, `super_form_field`, `super_map`,
  `super_table_field` and `super_tree` now depend on this package.
