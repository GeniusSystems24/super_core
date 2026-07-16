# super_core — ChatGPT / Codex agent instructions (v1.3.0)

Use these instructions whenever you build, theme, or modify Flutter code that
touches `super_core` — the shared **GeniusLink** design-system foundation for the
Super toolkit — or any package that depends on it.

---

## Package

```
name:    super_core
version: 1.3.0
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

## What changed in 1.3.0 (read first)

1. **Complete `ColorScheme`.** `toLightColorScheme()` / `toDarkColorScheme()`
   now fill every Material 3 role — the **fixed** accent roles
   (`primaryFixed`/`Dim`, `onPrimaryFixed`/`Variant`, secondary + tertiary) and
   the **surface-container ramp** (`surfaceDim`, `surfaceBright`,
   `surfaceContainerLowest…Highest`). `ColorScheme.surface` is now the page
   background; cards ride the container ramp.
2. **Complete `ThemeData`.** Every remaining `ThemeData` property gets a
   GeniusLink default (top-level colors, `visualDensity`,
   `materialTapTargetSize`, `splashFactory`, `applyElevationOverlayColor`, and
   the previously-null component themes: `actionIcon`, `badge`, `banner`,
   `bottomAppBar`, `bottomNavigationBar`, `carouselView`, `datePicker`,
   `dropdownMenu`, `menuBar`, `menuButton`, `searchBar`, `searchView`,
   `textSelection`, `timePicker`, `toggleButtons`). Precedence unchanged.
3. **Scaffold = `ColorScheme.surface`** (page background); cards/panels ride the
   brighter `surfaceContainer` ramp so they stay separated.
4. **App bar** is the elevated card surface (distinct from the Scaffold) and its
   `systemOverlayStyle` paints the **status bar + navigation bar** the app-bar
   color, picking icon brightness automatically for contrast (light & dark).
   `SuperAppBar` follows suit.
5. Host-derived fields (`platform`, `cupertinoOverrideTheme`,
   `pageTransitionsTheme`, `typography`) stay Flutter defaults unless overridden.

## What changed in 1.1.0

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

One call generates the full Material 3 theme (a complete ColorScheme — including
the fixed roles + surface-container ramp — typography, every button, inputs,
navigation, dialogs, sheets, cards, chips, tabs, tables, switches, menus,
tooltips, snackbars, scrollbars, FAB, date/time pickers, search, badges, toggle
buttons) from the palette + mode. The Scaffold is painted `ColorScheme.surface`
(page background); the app bar rides the card surface and syncs the status &
navigation bars via `systemOverlayStyle`.

## Constructor surface

```dart
SuperMaterialThemeData.light({           // .dark({…}) is identical
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

## Design-system widgets (v1.2.0)

Prefer these over hand-rolling GeniusLink chrome from raw `Container` / Material
widgets. All exported from the barrel; names start with `Super`.

`SectionCard` · `SectionHeader` · `StatusPill` · `SuperButton` /
`SuperIconButton` · `Hairline` · `FieldShell` and, added in 1.2.0:

### `SuperCard` — general surface card

8 px radius, hairline border, theme card shadow, 24 px interior. Distinct from
`SectionCard` (the tall form-section unit). Optional `header` slot; `onTap`
makes it interactive (hover → `borderStrong`); `selected` draws the
primary-border/tint active treatment.

```dart
SuperCard(
  header: const SectionHeader(title: 'Downtown Central Store'),
  onTap: () => open(store),         // omit for a static card
  selected: store == active,
  child: const StoreSummary(),
);
```

### `SuperDialog` — modal dialog

Marker-bar **or** tinted icon-badge header, title + optional subtitle + close,
scrollable body, right-aligned `SuperButton` row. Use the statics for the common
cases; `confirm` returns `Future<bool>` and `danger:` turns the confirm button +
badge semantic red (it recolors a `SuperButton` via a scoped `ColorScheme` — no
new button type).

```dart
SuperDialog.show<void>(context, builder: (ctx) => SuperDialog(
  title: 'Export Options',
  content: const _FormatList(),
  actions: [
    SuperButton(label: 'Cancel', variant: SuperButtonVariant.secondary,
        onPressed: () => Navigator.of(ctx).pop()),
    SuperButton(label: 'Export', onPressed: () => Navigator.of(ctx).pop()),
  ],
));

final ok = await SuperDialog.confirm(context,
    title: 'Delete Store', message: 'This cannot be undone.',
    confirmLabel: 'Delete', danger: true);          // Future<bool>

await SuperDialog.alert(context, title: 'Entry Posted',
    message: 'JV-2024-0042 posted.',
    icon: Icons.check_circle_outline, iconColor: SuperTokens.success);
```

### `SuperSnackBar` — floating toast

Statics over the ambient `ScaffoldMessenger`. `SuperSnackBarTone`
(`info` / `success` / `warning` / `danger`) drives the leading glyph + accent
(danger dwells 6 s). `build(...)` returns the `SnackBar` without showing it.

```dart
SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');
SuperSnackBar.danger(context, 'Transfer failed — accounts out of balance.');
SuperSnackBar.info(context, 'Draft saved.', actionLabel: 'View', onAction: open);
```

### `SuperAppBar` — page app bar (`PreferredSizeWidget`)

Flat, hairline-bottomed bar: ALL-CAPS breadcrumb `eyebrow` above a Title-Case
`title`, `titleTrailing` (inline translation / `StatusPill`), `leading` /
`actions`, optional `bottom` (e.g. a `TabBar`). Drops into `Scaffold.appBar`.

```dart
Scaffold(
  appBar: SuperAppBar(
    eyebrow: 'Stores & Products • Stores',
    title: 'Create Store',
    titleTrailing: const StatusPill('DRAFT', tone: PillTone.warning),
    actions: [SuperIconButton(icon: Icons.help_outline, onPressed: () {})],
  ),
);
```

New widget → follow the same pattern: read `context.superTheme` +
`SuperTokens` + `SuperText`, never hardcode colors/spacing, and export it
through `lib/src/core/core.dart`.

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
constraint to `^1.3.0` when it uses a 1.3.0-only API. Note the one intentional
1.3.0 behavior change: `ColorScheme.surface` (and the Scaffold background) now
resolve to the page background, not the card color — read
`SuperThemeData.of(context).surface` or `ColorScheme.surfaceContainerLowest` for
the card surface.

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
