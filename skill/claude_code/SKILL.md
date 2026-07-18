---
name: super-core
description: >
  How to understand, use, maintain, and extend the super_core Flutter package
  (v2.0.0) — the shared GeniusLink design-system foundation for the Super
  toolkit. super_core ships SuperPalette (six palettes), SuperMaterialThemeData
  (a ThemeData SUBCLASS that generates a complete Material 3 theme from a palette
  + a SuperDeviceMode), the SuperThemeData theme extension (surfaces + responsive
  metrics + dynamic tokens), SuperMetrics / SuperResponsive responsive tokens,
  SuperTokensData dynamic brand tokens, the SuperText type ramp, and
  design-system widgets. Use this skill whenever you build, theme, or modify
  anything in super_core or in a package that depends on it.
---

# super_core · v2.0.0

`super_core` is the single source of truth for the GeniusLink visual identity.
Every Super package (`super_tab_bar`, `super_auto_suggestion_box`,
`super_form_field`, `super_map`, `super_naviagtion_page`,
`super_navigation_sidebar`, `super_table_field`, `super_tree`) reads its colors,
type, spacing, and component themes from here so the whole toolkit looks like one
product.

**What changed in 2.0.0 (BREAKING — read this first):**

1. **`SuperTokens` (static) → `SuperTokensData` (dynamic).** The old
   `abstract final class SuperTokens` of `static const`s is **gone**. Brand
   tokens are now instance fields on the immutable `SuperTokensData` carried by
   the theme (`SuperThemeData.tokens`, `SuperMaterialThemeData.tokens`), so a
   theme can override any of them:
   `SuperMaterialThemeData.light(tokens: const SuperTokensData(radiusCard: 12))`.
   Read live values with `SuperThemeData.of(context).tokens.x`. Every field also
   has a `SuperTokensData.default*` compile-time constant (e.g.
   `SuperTokensData.defaultSpace4`) for `const` contexts. `SuperMarker` colors
   resolve via `marker.resolve(tokens)` (or `SuperMarker.x.defaultColor`).
2. **Custom fonts.** `.light`/`.dark` accept `fontFamily`, plus `textTheme` +
   `mergeTextTheme` (default `true`): the family from a provided `textTheme` is
   applied over the default GeniusLink ramp (sizes/weights preserved);
   `mergeTextTheme: false` uses the provided `textTheme` wholesale.
3. **`SuperAppBar` + `SuperSliverAppBar`** are full forks of `AppBar` /
   `SliverAppBar` (all properties customizable) with a positionable `subtitle`
   (`SubtitlePosition.above`/`.below`) and responsive action overflow past
   `maxActions` (per-device default 3/4/5; overridable via `maxActions` /
   `maxMobileActions` / `maxTabletActions` / `maxDesktopActions`). Defaults come
   from `SuperAppBarTheme extends AppBarTheme` (installed into
   `ThemeData.appBarTheme`).
4. **`SuperCard`** gains expand/collapse (vertical **or** horizontal) plus
   `leading` / `trailing` slots; defaults from `SuperCardTheme extends
   CardThemeData` (installed into `ThemeData.cardTheme`).
5. **`SuperDialog` removed** — use Flutter's `showDialog` / `AlertDialog`
   (already themed by `SuperMaterialThemeData`).
6. Dependent packages now require `super_core: ">=2.0.0 <3.0.0"`. Migration
   guides: `skill/migration_v1_to_v2/`.

**What changed in 1.3.0:**

1. **Complete `ColorScheme`.** `SuperPalette.toLightColorScheme()` /
   `toDarkColorScheme()` now fill every Material 3 role — the **fixed** accent
   roles (`primaryFixed`/`primaryFixedDim`/`onPrimaryFixed`/
   `onPrimaryFixedVariant`, and the secondary + tertiary equivalents) and the
   **surface-container ramp** (`surfaceDim`, `surfaceBright`,
   `surfaceContainerLowest` → `surfaceContainerHighest`).
2. **`ColorScheme.surface` is now the page background** (`#F7F8FA` / `#111318`)
   and the **Scaffold** is painted it. Cards default to the brighter
   `surfaceContainer` ramp (light `#FFFFFF` / dark `#1E2025`) so they stay
   separated. `SuperThemeData.surface` (the card color) is unchanged, so Super
   components are unaffected.
3. **Complete `ThemeData`.** Every remaining property now has a GeniusLink
   default (top-level colors; `visualDensity` / `materialTapTargetSize` /
   `splashFactory` / `applyElevationOverlayColor`; and the component themes that
   were previously null: `actionIcon`, `badge`, `banner`, `bottomAppBar`,
   `bottomNavigationBar`, `carouselView`, `datePicker`, `dropdownMenu`,
   `menuBar`, `menuButton`, `searchBar`, `searchView`, `textSelection`,
   `timePicker`, `toggleButtons`). Precedence is still explicit > palette >
   Flutter default.
4. **App bar** is painted the elevated card surface (distinct from the Scaffold)
   and its `systemOverlayStyle` syncs the **status bar + navigation bar** to the
   app-bar color with auto icon-brightness (light & dark). `SuperAppBar` too.
5. Host-derived fields (`platform`, `cupertinoOverrideTheme`,
   `pageTransitionsTheme`, `typography`) stay Flutter defaults unless overridden.

**What changed in 1.1.0:**

1. `SuperMaterialThemeData` now **extends `ThemeData`** — it *is* a Material
   theme, not a factory that returns one. `Theme.of(context) is
   SuperMaterialThemeData` is `true`.
2. It carries a `SuperThemeData superTheme` field **and** registers that same
   instance in `ThemeData.extensions`, so `Theme.of(context)
   .extension<SuperThemeData>()` and `theme.superTheme` always agree.
3. Light/dark constructors take a `SuperDeviceMode mode` (mobile/tablet/desktop)
   that drives responsive spacing, sizing, padding, margin, typography, and
   input-decoration density.
4. `SuperMaterialThemeData.maybeOf(context)` / `.of(context)` look the theme up
   from a `BuildContext`.
5. The three component packages that own a `ThemeExtension`
   (`SuperTabBarThemeData`, `AutoSuggestionsBoxThemeData`,
   `NavigationSidebarThemeData`) gained a `.fromMaterialTheme(theme)` bridge.

---

## Package architecture

```
super_core/
├── lib/
│   ├── super_core.dart              # public barrel — import THIS
│   └── src/core/
│       ├── core.dart                # internal barrel (re-exported by super_core.dart)
│       ├── theme/
│       │   ├── super_palette.dart               # SuperPalette (6 palettes, ColorScheme gen)
│       │   ├── super_material_theme.dart         # SuperMaterialThemeData (extends ThemeData)
│       │   ├── super_theme.dart                  # SuperThemeData (ThemeExtension + responsive layer)
│       │   ├── super_metrics.dart                # SuperMetrics / SuperSpacing/Sizing/Padding/Margin
│       │   ├── super_device_mode.dart            # SuperDeviceMode enum + SuperResponsive<T>
│       │   ├── super_interactive_state_theme.dart# SuperInteractiveStateThemeData (hover/focus/…)
│       │   ├── super_tokens.dart                 # SuperTokensData dynamic tokens (+ default* consts) + SuperMarker
│       │   └── super_text_styles.dart            # SuperText type ramp
│       ├── constants/  errors/  extensions/  typedefs/  usecases/  utils/
│       └── widgets/                 # SectionCard, SectionHeader, StatusPill, SuperButton, Hairline, FieldShell
├── example/                         # runnable palette / mode showcase
├── CHANGELOG.md   README.md   pubspec.yaml   analysis_options.yaml
```

Rules of the layout:

- **Everything public is exported through `lib/super_core.dart`.** Add new public
  symbols to `lib/src/core/core.dart` (never export a `src/…` path from a
  consumer).
- One responsive value is written **once**, in
  `super_metrics.dart` (`spacingResponsive` / `sizingResponsive` /
  `paddingResponsive` / `marginResponsive`). Never hard-code responsive numbers
  anywhere else.
- Brand tokens are the instance fields of `SuperTokensData` in
  `super_tokens.dart` (with `default*` compile-time mirrors). The active bundle
  rides the theme (`SuperThemeData.tokens`). Swappable surfaces live in
  `SuperThemeData`.

---

## Using `SuperMaterialThemeData`

Install one light and one dark theme on the `MaterialApp`. Because
`SuperMaterialThemeData` is a `ThemeData`, it drops straight into `theme:` /
`darkTheme:`.

```dart
import 'package:super_core/super_core.dart';

MaterialApp(
  theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
  darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
  themeMode: ThemeMode.system,
  home: const HomePage(),
);
```

That single call generates a fully configured Material 3 theme: a complete
`ColorScheme` (including the fixed accent roles + surface-container ramp),
typography, app bar, all button variants, inputs, navigation, dialogs, sheets,
cards, chips, tabs, tables, switches/checkboxes/radios/sliders, menus, tooltips,
snackbars, scrollbars, FAB, date/time pickers, search, badges, toggle buttons —
all derived from the palette and device mode. The Scaffold is painted
`ColorScheme.surface` (the page background); the app bar rides the card surface
and keeps the status & navigation bars in sync via `systemOverlayStyle`.

### Constructor parameters

```dart
SuperMaterialThemeData.light({
  SuperPalette palette = SuperPalette.bluePalette,
  SuperDeviceMode mode = SuperDeviceMode.mobile,
  SuperTokensData? tokens,      // dynamic brand-token overrides
  String? fontFamily,           // swap the primary font family
  bool mergeTextTheme = true,   // adopt a textTheme's font over the default ramp
  TextTheme? textTheme,
  AppBarTheme? appBarTheme,      // pass a SuperAppBarTheme for subtitle/overflow defaults
  NavigationBarThemeData? navigationBarTheme,
  ButtonThemeData? buttonTheme,
  InputDecorationTheme? formFieldTheme,
  CardThemeData? cardTheme,      // pass a SuperCardTheme for expand/slot defaults
  DialogThemeData? dialogTheme,
  DataTableThemeData? tableTheme,
  DividerThemeData? dividerTheme,
  IconThemeData? iconTheme,
  SuperInteractiveStateThemeData? interactiveStateTheme,
  List<ThemeExtension<dynamic>>? extensions,
});
// SuperMaterialThemeData.dark({ …identical… });
```

**Precedence (memorize this):** explicit constructor argument **>**
palette-generated value **>** Flutter default. Passing `cardTheme:` replaces the
generated card theme entirely; leaving it null uses the palette-derived one.

`.light()` always produces `Brightness.light`; `.dark()` always
`Brightness.dark`.

### Overriding one thing, keeping the rest

```dart
SuperMaterialThemeData.light(
  palette: SuperPalette.greenPalette,
  mode: SuperDeviceMode.desktop,
  // keep every generated value except a flatter app bar:
  appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
);
```

### `copyWith`

`copyWith` returns a `SuperMaterialThemeData` (not a plain `ThemeData`), keeps
`superTheme` / `mode`, and **merges** extensions (the generated `SuperThemeData`
and `SuperInteractiveStateThemeData` are re-synced, caller extensions are
preserved, no duplicates):

```dart
final t = SuperMaterialThemeData.dark().copyWith(
  extensions: const [MyFeatureThemeData.dark], // merged, NOT replaced
);
```

> The forwarded `ThemeData` parameters on `copyWith` are declared `dynamic` so
> the override stays valid across Flutter's in-flight `XxxTheme`→`XxxThemeData`
> component-theme migrations. Pass the normal Material types; `ThemeData`
> enforces them.

---

## Looking the theme up from a `BuildContext`

```dart
// Nullable — null when the ambient theme is a plain ThemeData:
final SuperMaterialThemeData? maybe = SuperMaterialThemeData.maybeOf(context);

// Non-null — always returns a valid SuperMaterialThemeData. If the ambient
// theme is a plain ThemeData, it is wrapped: existing colors, component themes
// and any registered SuperThemeData extension are preserved (nothing is
// discarded), falling back to the brightness-appropriate preset only when no
// SuperThemeData is registered.
final SuperMaterialThemeData t = SuperMaterialThemeData.of(context);
```

Use `maybeOf` when you want to branch on "is this a Super theme?"; use `of` when
you just need Super tokens and want a guaranteed result.

---

## `SuperThemeData` — the theme extension

`SuperThemeData` is a `ThemeExtension` carrying the swappable surface ramp
(`bg`, `surface`, `inputBg`, `hover`, `border`, `borderStrong`, `fg1…fg4`), the
active `brightness`, the active `SuperDeviceMode mode`, the resolved
`SuperMetrics metrics`, and `SuperInteractiveStateThemeData interactiveStates`.
It implements `copyWith` and `lerp` (surfaces interpolate; `mode` snaps at the
midpoint).

Read it three equivalent ways:

```dart
final s = Theme.of(context).extension<SuperThemeData>()!; // standard extension API
final s = SuperThemeData.of(context);                     // falls back to .dark
final s = SuperMaterialThemeData.of(context).superTheme;  // via the material theme

Container(color: s.surface, child: Text('Hi', style: TextStyle(color: s.fg1)));
```

Convenience responsive accessors live on `SuperThemeData`:
`s.spacing`, `s.sizing`, `s.padding`, `s.margin` (shortcuts for `s.metrics.*`).

Manual (pre-1.1.0) registration still works:

```dart
MaterialApp(theme: ThemeData(extensions: const [SuperThemeData.light]));
```

---

## `SuperPalette`

Six built-in palettes, each 10 shades (`shade50…shade900`) + semantic getters
(`primary`, `primaryDark`, `onPrimary`, `error`, `success`, `warning`, and the
GeniusLink neutral surface tokens `lightBg`/`darkSurface`/`darkFg1`/…):

`bluePalette` (default) · `purplePalette` · `greenPalette` · `goldenPalette` ·
`grayPalette` · `monochromePalette`. Iterate `SuperPalette.values`.

All six share the same neutral surfaces — only the accent varies — so switching
palette never changes the precision-instrument feel.

```dart
// Runtime palette switching:
SuperPalette _palette = SuperPalette.bluePalette;
// setState(() => _palette = SuperPalette.greenPalette);  → rebuild MaterialApp

// Custom palette (provide all 10 shades; surfaces come from the shared ramp):
const brand = SuperPalette(
  name: 'Brand', shade50: Color(0xFFEEF4FF), /* …shade100…900 */ shade900: Color(0xFF0B245C),
);

// A palette generates Material ColorSchemes directly:
final cs = SuperPalette.bluePalette.toDarkColorScheme();
```

---

## `SuperDeviceMode` — mobile / tablet / desktop

```dart
enum SuperDeviceMode { mobile, tablet, desktop }
```

- Pass it to the constructor: `SuperMaterialThemeData.light(mode:
  SuperDeviceMode.tablet)`. Default is `SuperDeviceMode.mobile`.
- Pick one from a width: `SuperDeviceMode.forWidth(MediaQuery.sizeOf(ctx).width)`
  or `SuperDeviceMode.of(context)` (uses ambient `MediaQuery`). Breakpoints:
  tablet ≥ 600, desktop ≥ 1024.
- The chosen mode's tokens become the **active** values on the theme; all three
  configurations stay reachable via the static `*Responsive` containers.

```dart
// Rebuild the app theme when the form factor changes:
Widget build(BuildContext context) {
  final mode = SuperDeviceMode.of(context);
  return Theme(
    data: SuperMaterialThemeData.of(context).brightness == Brightness.dark
        ? SuperMaterialThemeData.dark(mode: mode)
        : SuperMaterialThemeData.light(mode: mode),
    child: child,
  );
}
```

---

## Responsive tokens: spacing · sizing · padding · margin

`SuperMetrics` is one immutable snapshot of all four scales for a single mode.
The centralized definitions live once in `super_metrics.dart`.

```dart
final m = SuperMetrics.of(SuperDeviceMode.tablet);
m.spacing.md      // gap scale: xs sm md lg xl section
m.sizing.control  // control/field/icon/touch-target sizes
m.padding.card    // inner EdgeInsets: card control field page
m.margin.section  // outer EdgeInsets: card section page

// All three configs stay reachable:
SuperMetrics.spacingResponsive.desktop;                 // desktop spacing bundle
SuperMetrics.sizingResponsive.resolve(SuperDeviceMode.mobile);

// Author your own responsive value with the same container:
const gutter = SuperResponsive<double>(mobile: 16, tablet: 24, desktop: 32);
gutter.resolve(mode);   // active
gutter.desktop;         // specific
```

Note the deliberate inverse relationship: **spacing grows** with the viewport
while **control heights shrink** (mobile keeps ≥44 px touch targets; desktop is
denser).

---

## Responsive typography & form fields

`SuperMaterialThemeData` generates a `TextTheme` scaled per mode (mobile ~+6 %,
tablet ~+2 %, desktop baseline — with per-role line height / letter spacing) and
an `InputDecorationTheme` whose content padding, density (`isDense` on desktop),
field height, label/hint/error/helper styles, border radius, and icon
constraints all follow the mode. Caller-supplied `textTheme:` / `formFieldTheme:`
override these generated defaults wholesale.

```dart
final tt = Theme.of(context).textTheme;          // responsive ramp
final dec = Theme.of(context).inputDecorationTheme; // responsive field chrome
```

---

## Deriving related package themes from `SuperMaterialThemeData`

Two consistent patterns across the toolkit:

**1. Packages with their own `ThemeExtension`** expose a
`.fromMaterialTheme(SuperMaterialThemeData)` bridge and prefer it in `.of()`
(explicit extension → `SuperMaterialThemeData` → last-resort fallback):

```dart
final tabTheme  = SuperTabBarThemeData.fromMaterialTheme(SuperMaterialThemeData.of(context));
final boxTheme  = AutoSuggestionsBoxThemeData.fromMaterialTheme(SuperMaterialThemeData.of(context));
final sideTheme = NavigationSidebarThemeData.fromMaterialTheme(SuperMaterialThemeData.of(context));
// …but you rarely call these directly — each widget's ThemeData.of() does it for you.
```

**2. Packages without their own extension** (`super_form_field`, `super_map`,
`super_tree`, `super_table_field`, `super_naviagtion_page`) read
`SuperThemeData.of(context)` directly. Because `SuperMaterialThemeData` generates
**and registers** that `SuperThemeData` (with palette surfaces + brightness +
device-mode metrics), those packages already derive from the material theme with
zero extra wiring.

When you add a NEW component package: pick pattern 1 if it needs bespoke tokens
(add a `fromMaterialTheme` factory + prefer it in `of`), otherwise pattern 2
(just read `SuperThemeData.of(context)`). Never duplicate palette or responsive
math in the package — read it from `SuperThemeData` / `SuperMetrics`.

---

## Design-system widgets

Ready-made GeniusLink components (all `Super`-prefixed, exported from the
barrel). Compose these instead of restyling raw `Container` / Material widgets.

Pre-1.2.0: `SectionCard`, `SectionHeader`, `StatusPill`, `SuperButton` /
`SuperIconButton`, `Hairline`, `FieldShell`. Added in 1.2.0 and reshaped in
**2.0.0**:

| Widget | What it is | Key API |
|---|---|---|
| `SuperCard` | General surface card (8 px radius, hairline, card shadow). **Expandable** (v2). | `header` · `leading` / `trailing` slots · `expandedChild` + `expandDirection` (`Axis.vertical`/`.horizontal`) · `initiallyExpanded` / `isExpanded` / `onExpansionChanged` · `onTap` · `selected` |
| `SuperAppBar` | `PreferredSizeWidget` fork of `AppBar` (all props) | `title` · `subtitle` + `subtitlePosition` · `actions` (overflow past `maxActions` / per-device limits) · `leading` · `bottom` · `flexibleSpace` · … |
| `SuperSliverAppBar` | Fork of `SliverAppBar` (all props) | same subtitle/overflow features · `pinned` / `floating` / `snap` / `stretch` · `expandedHeight` · `flexibleSpace` |
| `SuperSnackBar` | Floating toast over `ScaffoldMessenger` | `.info/.success/.warning/.danger(ctx, msg, actionLabel:, onAction:)` · `.build(...)` · `SuperSnackBarTone` |

> `SuperDialog` was **removed in 2.0.0** — use Flutter's `showDialog` /
> `AlertDialog`, which `SuperMaterialThemeData` themes for you.

```dart
// Expandable, selectable card with header + slots:
SuperCard(
  leading: const Icon(Icons.storefront_outlined),
  header: const SectionHeader(title: 'Downtown Central Store'),
  trailing: const StatusPill('ACTIVE', tone: PillTone.success),
  expandedChild: const StoreDetailTable(), // revealed on tap / chevron
  child: const StoreSummary(),
);

// Themed dialog (SuperDialog is gone):
final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
  title: const Text('Delete Store'),
  content: const Text('This cannot be undone.'),
  actions: [
    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
    FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
      onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
  ],
));

// Semantic toast:
SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');

// Page app bar with a subtitle + action overflow:
Scaffold(
  appBar: SuperAppBar(
    title: const Text('Create Store'),
    subtitle: const Text('STORES & PRODUCTS • STORES'),
    subtitlePosition: SubtitlePosition.above,
    actions: [SuperIconButton(icon: Icons.help_outline, onPressed: () {})],
  ),
);
```

A new widget follows the same recipe as the existing ones: read
`context.superTheme` (its `.tokens` + `SuperText`), drive motion from
`context.superTheme.tokens.durBase` / `.curveStandard`, never hardcode
colors/spacing, and add its export to `lib/src/core/core.dart`.

---

## Public API & backward-compatibility rules

- Export new public symbols through `lib/src/core/core.dart` only.
- Prefer additive changes. **Deprecate before removing** —
  `@Deprecated('Use X. Removed after vN.')` for at least one minor cycle.
- Old wiring must keep working: `ThemeData(extensions: const
  [SuperThemeData.light])` and `SuperThemeData.of(context)` are load-bearing for
  every dependent package.
- Don't leak internal helpers into the public surface (e.g. private lerp
  helpers stay private).
- When a dependent package starts using a 1.3.0-only API, bump its `super_core`
  constraint to `^1.3.0` (path deps need no constraint) and its own version.
- **1.3.0 behavior change (intentional):** `ColorScheme.surface` and the
  Scaffold background now resolve to the page background, not the card color.
  For the card surface read `SuperThemeData.of(context).surface` (unchanged) or
  `ColorScheme.surfaceContainerLowest`.

---

## Conventions

- **Naming:** public design-system types are `Super*`
  (`SuperMaterialThemeData`, `SuperPalette`, `SuperMetrics`, `SuperDeviceMode`).
  Theme data classes end in `ThemeData`. Enums are lowerCamel values.
- **Docs:** every public member gets a `///` doc comment; reference other
  symbols with `[Brackets]`. Keep the file-top banner comment.
- **Formatting:** `dart format` (80-col). Trailing commas on multi-arg calls so
  the formatter lays them out one-per-line.
- **Immutability:** theme classes are `@immutable` with `const` constructors and
  full `copyWith` + `lerp`.
- **Color alpha:** use `color.withValues(alpha: x)` (not the deprecated
  `withOpacity`).
- **Organization:** one concept per file under `src/core/theme/`; barrels stay
  in dependency order.

---

## Common patterns (valid Dart)

```dart
// A themed section card that respects the active device mode:
Widget sectionCard(BuildContext context, Widget child) {
  final s = SuperThemeData.of(context);
  return Container(
    padding: s.padding.card,
    margin: s.margin.section,
    decoration: BoxDecoration(
      color: s.surface,
      borderRadius: BorderRadius.circular(s.tokens.radiusCard),
      border: Border.all(color: s.border),
      boxShadow: s.cardShadow,
    ),
    child: child,
  );
}

// Interactive-state overlay from the shared treatment:
InkWell(
  overlayColor: SuperInteractiveStateThemeData.of(context).overlayColor(),
  onTap: () {},
  child: /* … */,
);
```

---

## Updating docs when you change code

- **`CHANGELOG.md`** — add under the current version using Keep-a-Changelog
  sections (Added / Changed / Deprecated / Fixed). super_core is at
  **`## [2.0.0]`**.
- **`README.md`** — update the symbol table and any example whose API changed.
- **API docs** — the `///` comments ARE the API docs; keep them accurate and add
  them for every new public member.
- Bump `version:` in `pubspec.yaml` (SemVer) and dependent constraints.

---

## Commands

```bash
flutter pub get                 # resolve deps (run in super_core AND each dependent)
dart format .                   # format (run before committing)
dart format --output=none --set-exit-if-changed .   # CI format check
flutter analyze                 # static analysis — must pass with no new errors
flutter test                    # run package tests
dart doc                        # generate API docs (optional)
```

---

## Known limitations / compatibility

- **Flutter SDK:** 1.1.0 targets the **~3.32** ThemeData surface (component
  `*Data` types are the ThemeData field types, while `appBarTheme` is still
  `AppBarTheme` and `inputDecorationTheme` still `InputDecorationTheme`). Minimum
  is `flutter: ">=3.32.0"`, `sdk: ">=3.8.0"`. On much newer SDKs where
  `ThemeData.copyWith` retyped `appBarTheme`/`inputDecorationTheme` to `Object?`,
  `SuperMaterialThemeData.copyWith` remains valid because its forwarded params
  are `dynamic`.
- Subclassing `ThemeData` means `SuperMaterialThemeData` chains
  `ThemeData.raw`; if a future Flutter changes `raw`'s required parameter set,
  `_fromBase` must be updated to match.
- Fonts (Manrope / Inter / JetBrains Mono / Noto Naskh Arabic) are declared but
  the `.ttf` files are not bundled — drop them under `assets/fonts/` and
  uncomment the `fonts:` block to match the design exactly.

## Reference

- Examples: `EXAMPLES.md` in this folder.
- Source: `lib/src/core/theme/`.
- README: `../../README.md` · Changelog: `../../CHANGELOG.md` · Example app:
  `../../example/lib/`.
