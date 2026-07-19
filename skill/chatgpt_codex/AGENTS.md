# super_core — ChatGPT / Codex agent instructions (v2.0.0)

Use these instructions whenever you build, theme, or modify Flutter code that
touches `super_core` — the shared **GeniusLink** design-system foundation for the
Super toolkit — or any package that depends on it.

---

## Package

```
name:    super_core
version: 2.0.0
import:  package:super_core/super_core.dart
sdk:     dart >=3.8.0    flutter >=3.32.0
```

## When to use

Apply this skill when the user asks for:
- "theme the app with the GeniusLink / Super design system"
- "light and dark theme", "palette switching", "brand colors"
- "responsive spacing / sizing / typography for mobile, tablet, desktop"
- reading Super surface tokens (`bg`, `surface`, `fg1…fg4`, `border`) in a widget
- building or modifying any `super_*` package theme

## What changed in 2.0.0 (BREAKING — read first)

1. **`SuperTokens` → `SuperTokensData` (dynamic).** The old static class is
   removed; tokens are instance fields on `SuperTokensData` carried by the theme
   (`SuperThemeData.tokens` / `SuperMaterialThemeData.tokens`); override via
   `SuperMaterialThemeData.light(tokens: const SuperTokensData(...))`. Read live
   values dynamically with `SuperThemeData.of(context).tokens.x`; no static
   token constants remain (literal where `const` is mandatory). `SuperMarker`
   colors resolve via `marker.resolve(tokens)`.
2. **Custom fonts** — `fontFamily` + `textTheme` + `mergeTextTheme` on
   `.light`/`.dark`.
3. **`SuperAppBar` + `SuperSliverAppBar`** fork `AppBar` / `SliverAppBar` with
   `subtitle` + `subtitlePosition` and responsive action overflow past
   `maxActions` (`SuperAppBarTheme`).
4. **`SuperCard`** is expandable (v/h) with `leading`/`trailing`
   (`SuperCardTheme`).
5. **`SuperDialog` removed** — use themed `showDialog` / `AlertDialog`.
6. Dependents require `super_core: ">=2.0.0 <3.0.0"`; see
   `skill/migration_v1_to_v2/`.

## What changed in 1.3.0 (read first)

1. **Complete `ColorScheme`** — `toLightColorScheme()` / `toDarkColorScheme()`
   fill every Material 3 role: the **fixed** accent roles (`primaryFixed`/`Dim`,
   `onPrimaryFixed`/`Variant`, secondary + tertiary) and the **surface-container
   ramp** (`surfaceDim`, `surfaceBright`, `surfaceContainerLowest…Highest`).
   `ColorScheme.surface` is now the page background.
2. **Complete `ThemeData`** — every remaining property gets a GeniusLink default
   (top-level colors; `visualDensity` / `materialTapTargetSize` /
   `splashFactory` / `applyElevationOverlayColor`; and the previously-null
   component themes: `actionIcon`, `badge`, `banner`, `bottomAppBar`,
   `bottomNavigationBar`, `carouselView`, `datePicker`, `dropdownMenu`,
   `menuBar`, `menuButton`, `searchBar`, `searchView`, `textSelection`,
   `timePicker`, `toggleButtons`). Precedence unchanged.
3. **Scaffold = `ColorScheme.surface`** (page background); cards ride the
   brighter `surfaceContainer` ramp so panels stay separated.
4. **App bar** = elevated card surface (distinct from Scaffold); its
   `systemOverlayStyle` syncs the **status bar + navigation bar** to the
   app-bar color with auto icon-brightness (light & dark). `SuperAppBar` too.
5. Host-derived fields (`platform`, `cupertinoOverrideTheme`,
   `pageTransitionsTheme`, `typography`) stay Flutter defaults unless overridden.

## What changed in 1.1.0 (read first)

1. `SuperMaterialThemeData` **extends `ThemeData`** — it IS a Material theme.
   `Theme.of(context) is SuperMaterialThemeData` is `true`.
2. It has a `SuperThemeData superTheme` field AND registers that same instance in
   `ThemeData.extensions` (kept in sync, de-duplicated).
3. Light/dark constructors take `SuperDeviceMode mode` → responsive spacing,
   sizing, padding, margin, typography, input-decoration.
4. `SuperMaterialThemeData.maybeOf(context)` / `.of(context)` context lookups.
5. `SuperTabBarThemeData`, `AutoSuggestionsBoxThemeData`,
   `NavigationSidebarThemeData` gained `.fromMaterialTheme(theme)`.

---

## Theme setup (required)

```dart
import 'package:super_core/super_core.dart';

MaterialApp(
  theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
  darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
  themeMode: ThemeMode.system,
);
```

One call generates the full Material 3 theme (a complete ColorScheme — fixed
roles + surface-container ramp — typography, every button, inputs, navigation,
dialogs, sheets, cards, chips, tabs, tables, switches, menus, tooltips,
snackbars, scrollbars, FAB, date/time pickers, search, badges, toggle buttons)
from the palette + mode. Scaffold = `ColorScheme.surface`; the app bar rides the
card surface and syncs the status & navigation bars via `systemOverlayStyle`.

## Constructor surface

```dart
SuperMaterialThemeData.light({           // .dark({…}) is identical
  SuperPalette palette = SuperPalette.bluePalette,
  SuperDeviceMode mode = SuperDeviceMode.mobile,
  SuperTokensData? tokens,      // dynamic brand-token overrides
  String? fontFamily,           // swap the primary font family
  bool mergeTextTheme = true,   // adopt a textTheme's font over the default ramp
  TextTheme? textTheme,
  AppBarTheme? appBarTheme,      // SuperAppBarTheme for subtitle/overflow defaults
  NavigationBarThemeData? navigationBarTheme,
  ButtonThemeData? buttonTheme,
  InputDecorationTheme? formFieldTheme,
  CardThemeData? cardTheme,      // SuperCardTheme for expand/slot defaults
  DialogThemeData? dialogTheme,
  DataTableThemeData? tableTheme,
  DividerThemeData? dividerTheme,
  IconThemeData? iconTheme,
  SuperInteractiveStateThemeData? interactiveStateTheme,
  List<ThemeExtension<dynamic>>? extensions,
});
```

**Precedence: explicit arg > palette-generated > Flutter default.**
`.light()` ⇒ `Brightness.light`; `.dark()` ⇒ `Brightness.dark`.

## Context lookups

```dart
SuperMaterialThemeData? m = SuperMaterialThemeData.maybeOf(context); // null if not a Super theme
SuperMaterialThemeData  t = SuperMaterialThemeData.of(context);      // always valid (wraps a plain ThemeData, preserving its config)
```

## SuperThemeData (theme extension)

Carries surfaces (`bg`, `surface`, `inputBg`, `hover`, `border`, `borderStrong`,
`fg1…fg4`), `brightness`, `mode`, `metrics`, `interactiveStates`. Implements
`copyWith` + `lerp`.

```dart
final s = Theme.of(context).extension<SuperThemeData>()!; // standard API
final s = SuperThemeData.of(context);                     // falls back to .dark
final s = SuperMaterialThemeData.of(context).superTheme;  // via material theme
// s.spacing / s.sizing / s.padding / s.margin  → active responsive tokens
```

## SuperPalette

`bluePalette` (default), `purplePalette`, `greenPalette`, `goldenPalette`,
`grayPalette`, `monochromePalette`. Iterate `SuperPalette.values`. Each has 10
shades + semantic getters + shared neutral surfaces. `toLightColorScheme()` /
`toDarkColorScheme()` build Material `ColorScheme`s. Custom palettes: `const
SuperPalette(name: …, shade50: …, … shade900: …)`.

## SuperDeviceMode + responsive tokens

```dart
enum SuperDeviceMode { mobile, tablet, desktop }               // default: mobile
SuperDeviceMode.forWidth(width);  SuperDeviceMode.of(context); // tablet≥600, desktop≥1024

final m = SuperMetrics.of(mode);
m.spacing.md; m.sizing.control; m.padding.card; m.margin.section;
SuperMetrics.spacingResponsive.desktop;                        // all configs reachable
const g = SuperResponsive<double>(mobile: 16, tablet: 24, desktop: 32);  g.resolve(mode);
```

Spacing GROWS with viewport; control heights SHRINK (mobile keeps ≥44 px
targets). Typography scales per mode (mobile ~+6 %, tablet ~+2 %, desktop
baseline). `InputDecorationTheme` padding/density/height/border/icon constraints
follow the mode. Caller `textTheme:` / `formFieldTheme:` override wholesale.

## Deriving package themes

- Packages WITH their own extension (`SuperTabBarThemeData`,
  `AutoSuggestionsBoxThemeData`, `NavigationSidebarThemeData`) expose
  `.fromMaterialTheme(SuperMaterialThemeData)` and prefer it in `.of()`.
- Packages WITHOUT one (`super_form_field`, `super_map`, `super_tree`,
  `super_table_field`, `super_naviagtion_page`) read `SuperThemeData.of(context)`
  directly — already derived, since `SuperMaterialThemeData` registers it.

New package → add a `fromMaterialTheme` factory if it needs bespoke tokens,
else just read `SuperThemeData`. Never duplicate palette/responsive math.

---

## Design-system widgets (v2.0.0)

Prefer these over hand-rolling GeniusLink chrome. All exported from the barrel;
names start with `Super`.

`SectionCard` · `SectionHeader` · `StatusPill` · `SuperButton` /
`SuperIconButton` · `Hairline` · `FieldShell` and:

### `SuperCard` — general surface card (expandable in v2)

Optional `header`; `leading` / `trailing` slots; `onTap` (interactive);
`selected` (active treatment). **Expandable:** `expandedChild` +
`expandDirection` (`Axis.vertical`/`.horizontal`), controlled via
`initiallyExpanded` / `isExpanded` / `onExpansionChanged`. Defaults from
`SuperCardTheme`.

```dart
SuperCard(
  leading: const Icon(Icons.storefront_outlined),
  header: const SectionHeader(title: 'Downtown Central Store'),
  trailing: const StatusPill('ACTIVE', tone: PillTone.success),
  expandedChild: const StoreDetailTable(),
  child: const StoreSummary(),
);
```

### Dialogs — themed `showDialog` / `AlertDialog`

`SuperDialog` was removed in v2.0.0; `AlertDialog` is themed by
`SuperMaterialThemeData`.

```dart
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
```

### `SuperSnackBar` — floating toast

```dart
SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');
SuperSnackBar.danger(context, 'Transfer failed — accounts out of balance.');
SuperSnackBar.info(context, 'Draft saved.', actionLabel: 'View', onAction: open);
```

### `SuperAppBar` / `SuperSliverAppBar` — forked app bars

Forks of `AppBar` / `SliverAppBar` with `subtitle` + `subtitlePosition`
(`.above`/`.below`) and responsive action overflow past `maxActions`
(per-device 3/4/5; `maxMobileActions` / `maxTabletActions` /
`maxDesktopActions`).

```dart
Scaffold(
  appBar: SuperAppBar(
    title: const Text('Create Store'),
    subtitle: const Text('STORES & PRODUCTS • STORES'),
    subtitlePosition: SubtitlePosition.above,
    actions: [SuperIconButton(icon: Icons.help_outline, onPressed: () {})],
  ),
);

CustomScrollView(slivers: [
  SuperSliverAppBar(
    pinned: true, expandedHeight: 200,
    title: const Text('Journal'),
    subtitle: const Text('BANKING • LOCAL TRANSFERS'),
    flexibleSpace: const FlexibleSpaceBar(background: LedgerHeaderArt()),
  ),
]);
```

New widget → read `context.superTheme` (its `.tokens` + `SuperText`), never
hardcode colors/spacing, export through `lib/src/core/core.dart`.

---

## copyWith

Returns `SuperMaterialThemeData`, keeps `superTheme`/`mode`, MERGES extensions
(no duplicates, caller extensions preserved). Forwarded `ThemeData` params are
declared `dynamic` to stay a valid override across Flutter's `XxxTheme` →
`XxxThemeData` migration — pass normal Material types.

```dart
final t = SuperMaterialThemeData.dark().copyWith(
  extensions: const [MyFeatureThemeData.dark],  // merged, not replaced
);
```

---

## Conventions

- Public types are `Super*`; theme-data classes end in `ThemeData`; export
  through `lib/src/core/core.dart` only.
- Every public member gets a `///` doc; reference symbols with `[Brackets]`.
- `dart format` (80 col, trailing commas). Theme classes `@immutable` + `const`
  + `copyWith` + `lerp`. Use `color.withValues(alpha: x)`, never `withOpacity`.
- One responsive value defined ONCE in `super_metrics.dart`.

## Backward compatibility

Additive first; `@Deprecated('Use X. Removed after vN.')` for ≥1 minor before
removal. `ThemeData(extensions: const [SuperThemeData.light])` and
`SuperThemeData.of(context)` must keep working. Bump a dependent's `super_core`
constraint to `>=2.0.0 <3.0.0` when it uses a 2.0.0 API. v2.0.0 is breaking:
`SuperTokens` (static) is gone — read tokens from
`SuperThemeData.of(context).tokens` (no static token constants remain) — and
`SuperDialog` is removed.

## Commands

```bash
flutter pub get
dart format .
dart format --output=none --set-exit-if-changed .   # CI check
flutter analyze                                       # no new errors
flutter test
```

## Gotchas / limitations

1. Targets the **~3.32** ThemeData surface: component `*Data` types are the
   field types, but `appBarTheme` is `AppBarTheme` and `inputDecorationTheme` is
   `InputDecorationTheme`. Min `flutter >=3.32.0`, `dart >=3.8.0`.
2. `SuperMaterialThemeData` chains `ThemeData.raw`; if Flutter changes `raw`'s
   required params, update the private `_fromBase` constructor.
3. Passing an explicit component theme REPLACES the generated one — it is not
   merged field-by-field.
4. Fonts are declared but `.ttf`s are not bundled; add them under
   `assets/fonts/` and uncomment `fonts:` for pixel-exact rendering.
5. Don't export internal helpers (private lerp helpers stay private).

## Reference

- Examples: `EXAMPLES.md` in this folder.
- Source: `lib/src/core/theme/`.
- README: `../../README.md` · Changelog: `../../CHANGELOG.md`.
