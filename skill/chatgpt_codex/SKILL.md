# super_core — ChatGPT / Codex agent instructions (v2.1.0)

Use these instructions whenever you build, theme, or modify Flutter code that
touches `super_core` — the shared **GeniusLink** design-system foundation for the
Super toolkit — or any package that depends on it.

---

## Package

```
name:    super_core
version: 2.1.0
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

## What changed in 2.1.0 (additive — one token break)

1. **`SuperColorX`** (extension on `Color`): `fromHex`/`tryFromHex`/`toHex`; HSL
   `lighten`/`darken`/`saturate`/`desaturate`/`mix`/`tone`/`tintOver`; WCAG 2.1
   `contrastRatio`/`meetsAA`/`meetsAAA`/`onColor`/`bestForegroundFrom`.
2. **`SuperSemanticColors`** `ThemeExtension` — six intents
   (`info`/`success`/`warning`/`danger`/`accent`/`neutral`), each a
   `SuperSemanticColor` (`solid`/`onSolid`/`subtle`/`onSubtle`/`border`) resolved
   per brightness. Auto-registered; read `SuperSemanticColors.of(context)`. New
   `info` token (sky blue `#0EA5E9`) on `SuperTokensData`; `StatusPill` gains
   `PillTone.info`.
3. **Ten palettes** — `tealPalette`/`rosePalette`/`indigoPalette`/`slatePalette`
   added. Optional per-palette semantic overrides (`infoColor`/`successColor`/
   `warningColor`/`dangerColor`, applied only when no explicit `tokens:`); shade
   lookup `palette.shades` / `palette.shade(500)` / `palette[5]`. Dark accent now
   from shade400 (vivid + AA); deeper Scaffold backgrounds.
4. **Section family** — `SuperSectionHeader` (`style1`/`style2`, `leading`/
   `trailing`), `SuperSectionFooter` + `SuperFooterLink`, `SuperSection` (header +
   body (`child`/`children`) + footer; `collapsible`, `selected`/`onTap`,
   `dividerAfterHeader`, `card:false`). Themed by `SuperSectionHeaderThemeData` /
   `SuperSectionFooterThemeData` / `SuperSectionThemeData` (registered; widgets
   read `X.of(context)`, widget params win).
5. **`SuperSlider`** + `SuperSliderController` — responsive content carousel
   (`children`/`itemBuilder`, `visibleItems`, `peek`, `autoPlay`, `loop`,
   arrows + indicator, RTL, `onIndexChanged`).
6. **Token break:** v2.0 `SuperTokensData.default*` static mirrors and
   `SuperMarker.<x>.defaultColor` removed — read tokens from the theme. See
   `skill/migration_v2_to_v2.1/`.

## What changed in 2.0.0 (BREAKING — read first)

1. **`SuperTokens` → `SuperTokensData` (dynamic).** The old static
   `SuperTokens` class is removed. Tokens are instance fields on the immutable
   `SuperTokensData` carried by the theme (`SuperThemeData.tokens`,
   `SuperMaterialThemeData.tokens`); override via
   `SuperMaterialThemeData.light(tokens: const SuperTokensData(radiusCard: 12))`.
   Read values dynamically with `SuperThemeData.of(context).tokens.x`; there are
   no static token constants (use a brand-value literal where `const` is
   mandatory). `SuperMarker` colors resolve via `marker.resolve(tokens)`.
2. **Custom fonts.** `.light`/`.dark` accept `fontFamily`, plus `textTheme` +
   `mergeTextTheme` (default `true` → adopt the provided textTheme's font over
   the default GeniusLink ramp; `false` → use the textTheme wholesale).
3. **`SuperAppBar` + `SuperSliverAppBar`** are full forks of `AppBar` /
   `SliverAppBar` with a positionable `subtitle` (`SubtitlePosition`) and
   responsive action overflow past `maxActions` (per-device default 3/4/5).
   Defaults from `SuperAppBarTheme extends AppBarTheme`.
4. **`SuperCard`** is expandable (vertical/horizontal) with `leading`/`trailing`
   slots; defaults from `SuperCardTheme extends CardThemeData`.
5. **`SuperDialog` removed** — use themed `showDialog` / `AlertDialog`.
6. Dependents require `super_core: ">=2.0.0 <3.0.0"`. See
   `skill/migration_v1_to_v2/`.

## What changed in 1.3.0

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
`tealPalette`, `rosePalette`, `indigoPalette`, `slatePalette`, `grayPalette`,
`monochromePalette` (ten). Iterate `SuperPalette.values`. Each has 10 shades +
semantic getters (`info`/`success`/`warning`/`error`) + shared neutral surfaces
+ optional per-palette semantic overrides + shade lookup (`palette.shades`,
`palette.shade(500)`, `palette[5]`). `toLightColorScheme()` /
`toDarkColorScheme()` build Material `ColorScheme`s (dark accent = shade400).
Custom palettes: `const SuperPalette(name: …, shade50: …, … shade900: …)`.

## Semantic colors & color utilities (v2.1)

```dart
final sem = SuperSemanticColors.of(context);
final s = sem.success;                     // solid/onSolid/subtle/onSubtle/border
Container(color: s.subtle, /* border: s.border, text: s.onSubtle */);

SuperColorX.fromHex('#4A7CFF'); c.toHex(); c.lighten(.1); c.tintOver(surface, .14);
c.contrastRatio(fg); c.meetsAA(fg); bg.onColor(); bg.bestForegroundFrom([a, b]);
```

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

Prefer these over hand-rolling GeniusLink chrome from raw `Container` / Material
widgets. All exported from the barrel; names start with `Super`.

`SectionCard` · `SectionHeader` · `StatusPill` · `SuperButton` /
`SuperIconButton` · `Hairline` · `FieldShell` and:

### `SuperCard` — general surface card (expandable in v2)

8 px radius, hairline border, theme card shadow. Optional `header`; `leading` /
`trailing` slots; `onTap` makes it interactive; `selected` draws the active
treatment. **Expandable:** pass `expandedChild` (revealed on tap or via the
chevron) with `expandDirection` (`Axis.vertical` default, or `.horizontal`);
control via `initiallyExpanded` / `isExpanded` / `onExpansionChanged`. Defaults
from `SuperCardTheme` in `ThemeData.cardTheme`.

```dart
SuperCard(
  leading: const Icon(Icons.storefront_outlined),
  header: const SectionHeader(title: 'Downtown Central Store'),
  trailing: const StatusPill('ACTIVE', tone: PillTone.success),
  expandedChild: const StoreDetailTable(),   // revealed on tap / chevron
  child: const StoreSummary(),
);
```

### Dialogs — use themed `showDialog` / `AlertDialog`

`SuperDialog` was **removed in v2.0.0**. Flutter's `showDialog` + `AlertDialog`
are already themed by `SuperMaterialThemeData` (radius, colors, typography).

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

Statics over the ambient `ScaffoldMessenger`. `SuperSnackBarTone`
(`info` / `success` / `warning` / `danger`) drives the leading glyph + accent
(danger dwells 6 s). `build(...)` returns the `SnackBar` without showing it.

```dart
SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');
SuperSnackBar.danger(context, 'Transfer failed — accounts out of balance.');
SuperSnackBar.info(context, 'Draft saved.', actionLabel: 'View', onAction: open);
```

### `SuperAppBar` / `SuperSliverAppBar` — forked app bars

Full forks of `AppBar` / `SliverAppBar` (every property customizable) plus a
positionable `subtitle` (`SubtitlePosition.above` / `.below`) and responsive
action overflow: extras past `maxActions` collapse into a ⋮ menu (per-device
default 3/4/5, overridable via `maxActions` / `maxMobileActions` /
`maxTabletActions` / `maxDesktopActions`).

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

### `SuperSectionHeader` / `SuperSectionFooter` / `SuperSection` (v2.1)

`SuperSectionHeader` — section/page header, two styles: `style1` (marker-bar +
title/subtitle, optional `eyebrow` + inline `titleArabic`) and `style2` (flush
marker-tab + tinted icon-chip `leading` + ALL-CAPS title + `trailing` chevron).
`SuperSectionFooter` + `SuperFooterLink` — hairline + ALL-CAPS brand string +
action links (`emphasized` → accent). `SuperSection` — card shell composing an
optional header + body (`child` or spaced `children`) + optional footer;
`collapsible` (animated), `selected`/`onTap`, `dividerAfterHeader`, `markerColor`,
`card:false`. Configurable via `SuperSectionHeaderThemeData` /
`SuperSectionFooterThemeData` / `SuperSectionThemeData` (registered by the
material theme; widgets read `X.of(context)`, widget params win).

```dart
SuperSection(
  title: 'Financial', subtitle: 'Linked control account and terms',
  headerStyle: SuperSectionHeaderStyle.style2, leading: const Icon(Icons.sync_alt),
  collapsible: true,
  footerBrand: '© 2024 GeniusLink ERP',
  footerActions: [SuperFooterLink('Audit Log', onTap: open, emphasized: true)],
  child: const AccountTerms(),
);
```

### `SuperSlider` — responsive content carousel (v2.1)

ERP KPI strips / e-commerce product carousels. Static `children` or lazy
`itemBuilder` + `itemCount`; responsive `visibleItems` (`SuperResponsive<int>`,
default 1/2/3), edge `peek`, snapping paged scroll, `autoPlay` (pauses on
hover/drag), `loop`, brand arrows + animated indicator, RTL, `onIndexChanged`,
and an optional `SuperSliderController` (`next`/`previous`/`animateTo`).

```dart
SuperSlider(
  height: 140, peek: 24, autoPlay: true, loop: true,
  children: [for (final k in kpis) KpiCard(k)],
);
```

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
constraint to `>=2.0.0 <3.0.0` when it uses a 2.0.0 API. v2.0.0 is a breaking
release: `SuperTokens` (static) is gone — read tokens from
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
