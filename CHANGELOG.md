# Changelog

All notable changes to **super_core** are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/); versioning is
[SemVer](https://semver.org/).

---

## [2.0.0] — 2026-07-18

Major release. Brand tokens become **dynamic** (theme-owned), the toolkit gains
a custom-font pipeline and forked, GeniusLink-flavored app bars, `SuperCard`
becomes expandable, and `SuperDialog` is retired. **Breaking** — see Migration.

### Changed (breaking)

- **`SuperTokens` (static) → `SuperTokensData` (dynamic).** The former
  `abstract final class SuperTokens` of `static const` values is **removed**.
  Its values are now instance fields on the immutable `SuperTokensData`, carried
  by the theme via `SuperThemeData.tokens` and surfaced as
  `SuperMaterialThemeData.tokens`, so a theme can override any of them
  (`SuperMaterialThemeData.light(tokens: const SuperTokensData(radiusCard: 12))`).
  `SuperTokensData` provides `copyWith` + `lerp`, and every field keeps its
  historical value as a `default*` compile-time constant
  (`SuperTokensData.defaultSpace4`, `defaultAccent`, `defaultCurveStandard`, …)
  so `const` call sites still resolve.
  - Migration: `SuperTokens.x` → `SuperThemeData.of(context).tokens.x` (live)
    or `SuperTokensData.defaultX` (const context). `SuperMarker.ledger` no
    longer exposes a `static const` color — use `SuperMarker.ledger.resolve(tokens)`.
- **`SuperDialog` removed.** Use Flutter's `showDialog` / `AlertDialog`, which
  `SuperMaterialThemeData` already themes (radius, colors, typography).

### Added

#### Dynamic brand tokens

- `SuperTokensData` — accent + semantic palette, font families, radii, the 4px
  spacing scale, control metrics, and motion, all overridable per theme. Added
  to `SuperThemeData` (as `tokens`, lerped on theme change) and exposed on
  `SuperMaterialThemeData`.

#### Custom font family

- `SuperMaterialThemeData.light` / `.dark` gain `fontFamily`, `textTheme`, and
  `mergeTextTheme`. Precedence for the primary family: explicit `fontFamily` >
  the family carried by a provided `textTheme` (when `mergeTextTheme` is `true`)
  > the token default. When merging, the resolved family is applied **over** the
  default GeniusLink type ramp, preserving its sizes / weights / letter-spacing;
  set `mergeTextTheme: false` to use a provided `textTheme` wholesale.

#### `SuperAppBar` + `SuperSliverAppBar`

- Full forks of Flutter's `AppBar` / `SliverAppBar` — every property
  (height, colors, typography, icons, actions, leading, title, flexibleSpace,
  bottom, elevation, scrolled-under behavior, pinned/floating/snap/stretch, …)
  is customizable — plus two GeniusLink features:
  - **Subtitle** with `subtitlePosition` (`SubtitlePosition.above` / `.below`).
  - **Responsive action overflow** — at most `maxActions` inline actions before
    the rest collapse into a three-dot overflow menu. The default limit is
    resolved per device class (mobile 3 / tablet 4 / desktop 5), overridable via
    `maxActions` / `maxMobileActions` / `maxTabletActions` / `maxDesktopActions`.
- `SuperAppBarTheme extends AppBarTheme` carries `subtitlePosition`, `maxActions`
  and the per-device limits; `SuperMaterialThemeData` installs one into
  `ThemeData.appBarTheme` as the default for both app bars.

#### Expandable `SuperCard`

- `SuperCard` gains expand/collapse (revealing `expandedChild`) along the
  **vertical or horizontal** axis, toggled by tapping the card or its chevron
  (controlled via `isExpanded` / `onExpansionChanged`), plus `leading` and
  `trailing` slots.
- `SuperCardTheme extends CardThemeData` carries the expand direction / duration
  / curve, tap-to-toggle, chevron visibility, interior padding and border
  colors; `SuperMaterialThemeData` installs one into `ThemeData.cardTheme`.

### Migration from 1.x

- Replace every `SuperTokens.<name>` with `SuperThemeData.of(context).tokens.<name>`
  (dynamic) or `SuperTokensData.default<Name>` (const). The Super toolkit
  packages and their examples have been migrated to the `default*` constants.
- Replace `SuperDialog.show/confirm/alert` with `showDialog` + `AlertDialog`.
- Dependent packages now require `super_core: ">=2.0.0 <3.0.0"`.
- Step-by-step agent guides live under `skill/migration_v1_to_v2/`
  (`claude_code` and `chatgpt_codex`).

---

## [1.3.0] — 2026-07-16

### Added

#### Complete `ColorScheme` — fixed roles + surface-container ramp

`SuperPalette.toLightColorScheme()` / `toDarkColorScheme()` now populate every
remaining Material 3 role, so the generated scheme is complete and no role falls
back to a Flutter default:

- **Fixed accent roles** (identical across light & dark, per Material 3):
  `primaryFixed`, `primaryFixedDim`, `onPrimaryFixed`, `onPrimaryFixedVariant`,
  `secondaryFixed`, `secondaryFixedDim`, `onSecondaryFixed`,
  `onSecondaryFixedVariant`, `tertiaryFixed`, `tertiaryFixedDim`,
  `onTertiaryFixed`, `onTertiaryFixedVariant` — derived from the palette ramp
  (`shade100`/`shade200` fills, `shade700`/`shade900` on-colors).
- **Surface-container ramp:** `surfaceDim`, `surfaceBright`,
  `surfaceContainerLowest`, `surfaceContainerLow`, `surfaceContainer`,
  `surfaceContainerHigh`, `surfaceContainerHighest` — a monotonic elevation ramp
  tuned per brightness (light: brightest/white at *lowest*; dark:
  darkest at *lowest*, lightening upward).
- `ColorScheme.surface` is now the GeniusLink **page background** (`#F7F8FA` /
  `#111318`), and cards default to `surfaceContainerLowest` (light, `#FFFFFF`) /
  `surfaceContainer` (dark, `#1E2025`) so panels stay clearly lifted off the
  page. Super components read `SuperThemeData.surface` (the card surface), which
  is unchanged, so their appearance is unaffected.

#### Complete `ThemeData` — every remaining property gets a GeniusLink default

`SuperMaterialThemeData` now generates GeniusLink-compliant defaults for the
`ThemeData` properties that were previously left to Flutter (each still
overridable, precedence unchanged):

- **Scaffold:** `scaffoldBackgroundColor` / `canvasColor` = `ColorScheme.surface`
  (the page background). The card surface and `surfaceContainer` ramp provide the
  separation so cards/panels/fields/app bars remain distinguishable.
- **App bar:** background is the elevated **card surface** (visually distinct
  from the Scaffold) and a `systemOverlayStyle` now paints the **status bar** and
  **navigation bar** the same color as the app bar, choosing status/nav icon
  brightness automatically for contrast (light & dark overlay styles applied
  per theme). `SuperAppBar` follows the same rule.
- **Top-level colors:** `focusColor`, `highlightColor`, `hoverColor`,
  `splashColor`, `hintColor`, `primaryColor`, `primaryColorDark`,
  `primaryColorLight`, `secondaryHeaderColor`, `shadowColor`,
  `unselectedWidgetColor`.
- **General config:** `applyElevationOverlayColor` (`false` — flat surfaces),
  `splashFactory` (`InkRipple`), and mode-aware `visualDensity` /
  `materialTapTargetSize` (compact / shrink-wrap on desktop).
- **Component themes** previously left null now have GeniusLink defaults:
  `actionIconTheme`, `badgeTheme`, `bannerTheme`, `bottomAppBarTheme`,
  `bottomNavigationBarTheme`, `carouselViewTheme`, `datePickerTheme`,
  `dropdownMenuTheme`, `menuBarTheme`, `menuButtonTheme`, `searchBarTheme`,
  `searchViewTheme`, `textSelectionTheme`, `timePickerTheme`,
  `toggleButtonsTheme`, plus the deprecated `dialogBackgroundColor` /
  `indicatorColor` fallbacks.

> Host-derived fields (`platform`, `cupertinoOverrideTheme`,
> `pageTransitionsTheme`, `typography`) are intentionally left to Flutter's
> platform-appropriate defaults unless a caller overrides them.

### Changed

- `pubspec.yaml`: version → `1.3.0`.
- `super_palette.dart`: `surface` / `background` roles remapped to the page
  background; container + fixed roles added.
- `super_material_theme.dart`: `_assemble` fills all remaining `ThemeData`
  fields; new private `_systemOverlayStyle(Color)` helper; the responsive
  `InputDecorationTheme` is computed once and shared with `dropdownMenuTheme`.
- `super_app_bar.dart`: app-bar background is the card surface in both themes and
  carries a matching `systemOverlayStyle`.

### Migration from 1.2.0

Fully backward compatible. The only behavioral change is intentional and
requested: `ColorScheme.surface` (and the Scaffold background) now resolve to the
page background rather than the card white/near-black, and cards/app bars sit on
the brighter container ramp. If you relied on `Theme.of(context).colorScheme
.surface` to mean the *card* color, read `SuperThemeData.of(context).surface`
(unchanged) or `ColorScheme.surfaceContainerLowest` instead.

---

## [1.2.0] — 2026-07-16

### Added

Four `Super`-prefixed common widgets, all built from the existing GeniusLink
tokens (`SuperTokens` / `SuperThemeData` / `SuperText`) and exported through the
`lib/src/core/core.dart` barrel:

- **`SuperCard`** — the general-purpose surface card (8px radius, hairline
  border, theme card shadow, 24px interior). Distinct from `SectionCard` (the
  tall form-section unit): `SuperCard` takes an optional `header` slot and can be
  made interactive via `onTap` (pointer cursor + hover border) and `selected`
  (primary border over a faint primary tint) for the active card/row in a list.
- **`SuperDialog`** — a modal dialog surface on the overlay (popover) shadow:
  header with a section-marker bar *or* a tinted icon badge, Title-Case title +
  optional subtitle + close button, a scrollable content body, and a
  right-aligned `SuperButton` action row. Statics: `SuperDialog.show<T>(...)`,
  `SuperDialog.confirm(...)` (returns `Future<bool>`, `danger:` turns the confirm
  button + badge semantic red), and `SuperDialog.alert(...)`.
- **`SuperSnackBar`** — floating GeniusLink toast helper over the ambient
  `ScaffoldMessenger`, with the `SuperSnackBarTone` enum (info / success /
  warning / danger) driving the leading glyph + accent. Statics: `show`, `info`,
  `success`, `warning`, `danger`, and `build` (constructs the `SnackBar` without
  showing it).
- **`SuperAppBar`** — a flat, hairline-bottomed `AppBar` (implements
  `PreferredSizeWidget`) with an optional ALL-CAPS breadcrumb `eyebrow` above a
  Title-Case `title`, a `titleTrailing` slot (inline translation / status),
  `leading` / `actions` slots, and an optional `bottom` (e.g. a `TabBar`).

### Changed

- `pubspec.yaml`: version → `1.2.0`.
- `lib/src/core/core.dart` barrel now also exports `super_app_bar.dart`,
  `super_card.dart`, `super_dialog.dart` and `super_snack_bar.dart`.

### Migration from 1.1.0

Fully backward compatible — additive only. No existing API changed.

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
