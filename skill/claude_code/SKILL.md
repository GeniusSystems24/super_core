---
name: super-core
description: >
  How to understand, use, maintain, and extend the super_core Flutter package
  (v3.3.0) — the shared GeniusLink design-system foundation for the Super
  toolkit. super_core ships SuperPalette (ten palettes), SuperMaterialThemeData
  (a ThemeData SUBCLASS that generates a complete Material 3 theme from a palette
  + a SuperDeviceMode), the SuperThemeData theme extension (surfaces + responsive
  metrics + dynamic tokens), SuperMetrics / SuperResponsive responsive tokens,
  SuperTokensData dynamic brand tokens, SuperSemanticColors + SuperColorX color
  utilities, SuperTextTheme (a TextTheme subclass powered by Google Fonts), and
  reusable confirmation/field View + Dialog primitives alongside the other
  design-system widgets. Use this skill whenever you build, theme, or modify
  anything in super_core or in a package that depends on it.
---

# super_core — v3.3.0

`super_core` is the single source of truth for the GeniusLink visual identity.
Every Super package (`super_tab_bar`, `super_auto_suggestion_box`,
`super_form_field`, `super_map`, `super_naviagtion_page`,
`super_navigation_sidebar`, `super_table_field`, `super_tree`) reads its colors,
type, spacing, and component themes from here so the whole toolkit looks like one
product.


## What changed in 3.3.0 (explicit Super typography)

1. **`SuperMaterialThemeData.light` / `.dark` require typography.** Pass
   `required SuperTextTheme textTheme` and
   `required SuperTextTheme primaryTextTheme` on every construction.
2. **Typography is no longer generated inside the Material theme.** The old
   nullable `TextTheme` inputs, private `_textTheme` generator, and
   `mergeTextTheme` path are removed.
3. **`SuperThemeData.textTheme` is removed.** Read typography from
   `context.superTextTheme` or `SuperMaterialThemeData.of(context).textTheme`.
   **Never use** `context.superTheme.textTheme`,
   `SuperThemeData.of(context).textTheme`, or `.textTheme` on any
   `SuperThemeData` value; those APIs do not exist in v3.3.0.
4. **Responsive type ramps are explicit.** Build
   `SuperTextTheme(isDesktop: mode == SuperDeviceMode.desktop)` whenever the
   responsive mode changes.
5. **No font-family inference.** `SuperMaterialThemeData` does not inspect
   `SuperTextTheme` to derive token font metadata. The old `_familyOf` helper is
   removed. Configure typography with `bodyFont` / `otherFont`; pass
   `fontFamily` only when an explicit token-level family override is required.

## What changed in 3.2.1 (distinct action footer)

1. **The shared View action area is now a dedicated footer surface.**
   `SuperConfirmView` and `SuperFieldView` use `SuperThemeData.bg` for the
   action footer and `SuperThemeData.border` for its top hairline.
2. **Never copy reference-image colors into these footers.** Let the active
   Super theme resolve light/dark and palette-specific surfaces.
3. **Keep dialogs thin.** `SuperConfirmDialog` and `SuperFieldDialog` inherit
   this footer from their View component; do not duplicate the action layout.


## What changed in 3.2.0 (reusable confirmation + field views/dialogs)

1. **`SuperConfirmView` added.** Reusable confirmation hierarchy for inline
   surfaces: title, description, optional content, semantic intent icon, and
   confirm/cancel actions.
2. **`SuperConfirmDialog` added.** Thin modal wrapper around
   `SuperConfirmView`. Prefer `SuperConfirmDialog.show(...)` for standard modal
   confirmation; it returns `true` only for confirmation and `false` for cancel
   or barrier dismissal.
3. **`SuperFieldView` added.** Reusable form/custom-input layout with optional
   title, description, and actions.
4. **`SuperFieldDialog` added.** Thin modal wrapper around `SuperFieldView`.
   `SuperFieldDialog.show<T>(...)` returns whatever value the caller pops.
5. **Architecture rule:** shared hierarchy and behavior belong in the `View`;
   modal presentation, viewport constraints, and navigation lifecycle belong in
   the `Dialog`. Never fork the same UI between both.
6. **Styling rule:** use the ambient Super/Material themes and `SuperButton`;
   use `isDestructive: true` for destructive confirmation rather than custom
   colors/buttons.
7. **Example:** `example/lib/dialog_views_example_screen.dart` demonstrates all
   four components, including destructive confirmation and modal results.

## What changed in 3.1.0 (section-card variants)

1. **`SuperSectionCard1` added.** Compact accent-title section card with
   optional collapse, expansion callbacks, selected state, footer support,
   divider, custom surface fields, and `SuperCardTheme` /
   `SuperSectionThemeData` integration.
2. **`SuperSectionCard2` added.** Rail-and-chip section card with default
   collapsible behavior, optional footer, divider, selected state, deprecated
   compatibility aliases, and theme-driven animation, spacing, border, and
   radius.
3. **Section widgets moved under `widgets/section/`.** Public usage still imports
   `package:super_core/super_core.dart`; do not depend on `src` paths.
4. **`SuperCardTheme.borderColor` is generated** from
   `ColorScheme.outlineVariant` by `SuperMaterialThemeData`.

## What changed in 3.0.0 (breaking consolidation + layout)

1. **Layout primitives added.** Use `SuperBreakpoint`, `SuperBreakpoints`,
   `SuperBreakpointProvider`, `SuperGrid`, `SuperGridCell`, `SuperGridScope`, and
   `SuperScaffold` from `package:super_core/super_core.dart`.
2. **Section/card consolidation.** `SectionCard`, `SuperSection`, and
   `SuperCard` are removed. Use `SuperSectionCard` for plain cards, headed
   sections, collapsible sections, selectable/tappable cards, and expandable
   detail cards.
3. **Header consolidation.** `SectionHeader` is removed. Use
   `SuperSectionHeader` for both marker-bar and compact row headers.
4. **Spacing system carries forward.** Read spacing, radii, insets, and control
   heights from `context.superTheme.spacing`; do not revive old static token
   access or hard-coded section/card padding.
5. **Migration guide.** Use `skill/migration_v2.4.0_to_v3.0.0/` for before/after
   replacements and layout examples.

**What changed in 2.4.0 (additive + breaking removals — read Migration):**

1. **`SuperTextTheme extends TextTheme`** replaces the removed `SuperText` static
   class. `SuperTextTheme(tokens, {isDesktop, isArabic})` populates
   all 15 Material `TextTheme` slots via Google Fonts (`GoogleFonts.manrope()` /
   `GoogleFonts.inter()` / `GoogleFonts.notoNaskhArabic()`). Nine named fields
   (`displayLg`, `headlineSm`, `titleMd`, `bodyLg`, `bodySm`, `labelMd`,
   `labelSm`, `mono`, `eyebrow`) plus convenience getters (`heading`, `body`,
   `label`, `caption`, `button`, `pill`, `h1`). Read via
   `context.superTextTheme.<field>`. `colorize(fg1, fg3)` applies the `fg*`
   ramp; `superCopyWith({...})` preserves the type.
   - In v3.3.0 the ramp is owned by `SuperMaterialThemeData`; use
     `context.superTextTheme` for component-level access.
   - **Breaking:** `SuperText` (static class) is **removed**. Migrate every
     `SuperText.<field>` → `context.superTextTheme.<field>`.
2. **Surface colors updated** to match GeniusLink reference tokens: light
   background `#E6E8EB` (was `#E9EDF3`), light surface `#F5F6F8` (was
   `#F8FAFD`), dark background `#0E141E` (was `#09131D`).
3. **Card shadows** replaced with single-layer diffuse shadows:
   dark `BoxShadow(0x1F000000, blur 28, dy 6)` / light `BoxShadow(0x0A000000,
   blur 32, dy 4)`.
4. **`AccentSectionCard`** — new widget with a 3 px leading accent bar and a
   tinted header strip. Exported from the barrel.
5. **`SectionCard` redesign** — background `surfaceContainerLow`, shadow-only
   (no default border), collapsible support (`collapsible`, `initiallyExpanded`),
   `accentColor`, `icon`. `leading` / `trailing` **removed**.
6. **`SuperCard` redesign** — `background` renamed to `color`, all standard
   Material `Card` props added, border transparent at rest. `leading` /
   `trailing` **removed**.
7. **`SuperAppBar` / `SuperSliverAppBar` chrome** — auto back button now
   `Icons.arrow_back_ios_new_rounded` in a plain `IconButton`; route guard uses
   `parentRoute?.impliesAppBarDismissal`; title falls back to
   `context.superTextTheme.headlineSm`; subtitle falls back to `context.superTextTheme.labelSm` with
   `letterSpacing: 1.2`.
8. **`google_fonts: ^6.2.1`** added as a package dependency.

**What changed in 2.3.0 (compact card density):**

Cards, sections and tiles use tighter responsive insets — every padding value
comes from the responsive `SuperMetrics` scales so one theme override retunes
the whole app density. See the 2.3.0 changelog entry for the full token delta.

**What changed in 2.1.0 (additive — backward compatible, plus one token break):**

1. **Color utilities — `SuperColorX`** (extension on `Color`): `fromHex` /
   `tryFromHex` / `toHex`; HSL tonal ops `lighten` / `darken` / `saturate` /
   `desaturate` / `mix` / `tone` / `tintOver`; and WCAG 2.1 helpers
   `contrastRatio` / `meetsAA` / `meetsAAA` / `onColor` / `bestForegroundFrom`.
2. **Structured semantic colors — `SuperSemanticColors`** `ThemeExtension`: six
   intents (`info`, `success`, `warning`, `danger`, `accent`, `neutral`), each a
   `SuperSemanticColor` with `solid` / `onSolid` / `subtle` / `onSubtle` /
   `border` resolved per brightness (`onSubtle` picked by contrast). Auto-
   registered by `SuperMaterialThemeData`; read `SuperSemanticColors.of(context)`.
   A new `info` token (sky blue `#0EA5E9`) joins `success`/`warning`/`danger` on
   `SuperTokensData`; `StatusPill` gains `PillTone.info` and sources its fills
   from the semantic set.
3. **Ten palettes.** `tealPalette`, `rosePalette`, `indigoPalette`,
   `slatePalette` join the original six. `SuperPalette` gains optional
   per-palette semantic overrides (`infoColor`/`successColor`/`warningColor`/
   `dangerColor`, folded in only when no explicit `tokens:` is passed) and shade
   lookup (`palette.shades`, `palette.shade(500)`, `palette[5]`).
4. **Dark accent fix.** `toDarkColorScheme()` derives `primary`/`secondary`/
   `tertiary` from **shade400** (was shade300) so the accent stays vivid on
   near-black while keeping AA legibility. Scaffold backgrounds deepened for more
   card contrast (dark `#0A0B0E`, light `#EBEEF4`).
5. **Section family widgets.** `SuperSectionHeader` (two styles — `style1`
   marker-bar form header / `style2` flush marker-tab + icon-chip row header;
   `leading` + `trailing` slots), `SuperSectionFooter` + `SuperFooterLink`, and
   `SuperSection` (a card shell that optionally composes a header + footer around
   a `child`/`children` body; `collapsible`, `selected`/`onTap`,
   `dividerAfterHeader`, `markerColor`, `card:false`). Configurable via three new
   `ThemeExtension`s — `SuperSectionHeaderThemeData`,
   `SuperSectionFooterThemeData`, `SuperSectionThemeData` (registered by
   `SuperMaterialThemeData`; widgets read `X.of(context)` and fall back to the
   GeniusLink hard defaults; a widget-level param wins over the theme value).
6. **`SuperSlider`** + `SuperSliderController` — a responsive content carousel
   (ERP KPI strips / e-commerce product carousels): static `children` or lazy
   `itemBuilder`, responsive items-per-view (`SuperResponsive<int>`), edge
   `peek`, snapping paged scroll, autoplay (pauses on hover/drag), `loop`, brand
   arrows + animated indicator, RTL, `onIndexChanged`.
7. **Token break:** the v2.0 `SuperTokensData.default*` static-const mirrors and
   `SuperMarker.<x>.defaultColor` are **removed** — read tokens from the theme.
   Guide: `skill/migration_v2_to_v2.1/`.

**What changed in 2.0.0 (BREAKING — read this first):**

1. **`SuperTokens` (static) → `SuperTokensData` (dynamic).** The old
   `abstract final class SuperTokens` of `static const`s is **gone**. Brand
   tokens are now instance fields on the immutable `SuperTokensData` carried by
   the theme (`SuperThemeData.tokens`, `SuperMaterialThemeData.tokens`), so a
   theme can override any of them through the `tokens:` constructor argument
   while still supplying the required `textTheme` and `primaryTextTheme`. Read
   values dynamically with `SuperThemeData.of(context).tokens.x`. There are
   NO static token constants — where `const` is mandatory (enum arg / static
   const / default param) use a brand-value literal. `SuperMarker` colors resolve
   via `marker.resolve(tokens)`.
2. **Custom fonts.** Current v3.3.0 code builds a `SuperTextTheme` with the
   desired `bodyFont` / `otherFont` and supplies it explicitly as both required
   typography parameters. `SuperMaterialThemeData` never infers token font
   metadata from that ramp; pass `fontFamily` explicitly only when the token
   family must also be overridden. The old `mergeTextTheme` behavior is
   historical only.
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
│       │   ├── super_palette.dart               # SuperPalette (10 palettes, ColorScheme gen)
│       │   ├── super_material_theme.dart         # SuperMaterialThemeData (extends ThemeData)
│       │   ├── super_theme.dart                  # SuperThemeData (ThemeExtension + responsive layer + textTheme getter)
│       │   ├── super_metrics.dart                # SuperMetrics / SuperSpacing/Sizing/Padding/Margin
│       │   ├── super_device_mode.dart            # SuperDeviceMode enum + SuperResponsive<T>
│       │   ├── super_interactive_state_theme.dart# SuperInteractiveStateThemeData (hover/focus/…)
│       │   ├── super_tokens.dart                 # SuperTokensData dynamic tokens + SuperMarker
│       │   └── super_text_styles.dart            # SuperTextTheme extends TextTheme (Google Fonts)
│       ├── constants/  errors/  extensions/  typedefs/  usecases/  utils/
│       └── widgets/                 # SectionCard, AccentSectionCard, SectionHeader, StatusPill,
│                                    # SuperButton, Hairline, FieldShell, SuperSnackBar,
│                                    # SuperConfirmView/Dialog, SuperFieldView/Dialog,
│                                    # SuperAppBar, SuperSliverAppBar, SuperSectionHeader,
│                                    # SuperSectionFooter, SuperListTile, SuperGridTile, SuperSlider
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
- Brand tokens are instance fields of `SuperTokensData` in `super_tokens.dart`.
  The active bundle rides the theme (`SuperThemeData.tokens`). Swappable surfaces
  live in `SuperThemeData`.
- **Typography** lives in `super_text_styles.dart` as `SuperTextTheme extends
  TextTheme` and is required by `SuperMaterialThemeData`. Read branded styles via
  `context.superTextTheme` or `SuperMaterialThemeData.of(context).textTheme`.
  Do not read typography from `SuperThemeData`.

---

## Using `SuperMaterialThemeData`

Install one light and one dark theme on the `MaterialApp`. Because
`SuperMaterialThemeData` is a `ThemeData`, it drops straight into `theme:` /
`darkTheme:`.

```dart
import 'package:super_core/super_core.dart';

final typography = SuperTextTheme();

MaterialApp(
  theme: SuperMaterialThemeData.light(
    palette: SuperPalette.bluePalette,
    textTheme: typography,
    primaryTextTheme: typography,
  ),
  darkTheme: SuperMaterialThemeData.dark(
    palette: SuperPalette.bluePalette,
    textTheme: typography,
    primaryTextTheme: typography,
  ),
  themeMode: ThemeMode.system,
  home: const HomePage(),
);
```

Each call combines the required explicit `SuperTextTheme` with a fully
configured Material 3 `ColorScheme` (including the fixed accent roles +
surface-container ramp),
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
  String? fontFamily,           // token font-family metadata override
  required SuperTextTheme textTheme,
  required SuperTextTheme primaryTextTheme,
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
final typography = SuperTextTheme(isDesktop: true);

SuperMaterialThemeData.light(
  palette: SuperPalette.greenPalette,
  mode: SuperDeviceMode.desktop,
  textTheme: typography,
  primaryTextTheme: typography,
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
final typography = SuperTextTheme();
final t = SuperMaterialThemeData.dark(
  textTheme: typography,
  primaryTextTheme: typography,
).copyWith(
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

Ten built-in palettes, each 10 shades (`shade50…shade900`) + semantic getters
(`primary`, `primaryDark`, `onPrimary`, `error`, `info`, `success`, `warning`,
and the GeniusLink neutral surface tokens `lightBg`/`darkSurface`/`darkFg1`/…):

`bluePalette` (default) · `purplePalette` · `greenPalette` · `goldenPalette` ·
`tealPalette` · `rosePalette` · `indigoPalette` · `slatePalette` · `grayPalette` ·
`monochromePalette`. Iterate `SuperPalette.values`.

All palettes share the same neutral surfaces — only the accent varies — so
switching palette never changes the precision-instrument feel. Each may carry
optional per-palette semantic overrides (`infoColor` / `successColor` /
`warningColor` / `dangerColor`) that `SuperMaterialThemeData` folds into the
tokens **only when no explicit `tokens:` is passed**. Shade lookup:
`palette.shades` (0–9 ramp), `palette.shade(500)` (nearest Material step),
`palette[5]`.

---

## Semantic colors & color utilities (v2.1.0)

**`SuperSemanticColors`** — the structured status-color bundle. Prefer it over
raw token solids for any pill / banner / snackbar / section marker:

```dart
final sem = SuperSemanticColors.of(context);
final s = sem.success;               // or sem.byIntent(SuperSemanticIntent.success)
Container(
  decoration: BoxDecoration(color: s.subtle, border: Border.all(color: s.border)),
  child: Text('POSTED', style: TextStyle(color: s.onSubtle)),
);
Container(color: s.solid, child: Text('BADGE', style: TextStyle(color: s.onSolid)));
```

Six intents (`info`/`success`/`warning`/`danger`/`accent`/`neutral`); each
`SuperSemanticColor` carries `solid` / `onSolid` / `subtle` / `onSubtle` /
`border`, derived per brightness from the token solids over the card surface
(`onSubtle` chosen by WCAG contrast). `SuperMaterialThemeData` registers one
automatically; a caller-supplied instance is preserved.

**`SuperColorX`** — color helpers on any `Color`:

```dart
SuperColorX.fromHex('#4A7CFF');          // parse (tryFromHex for null-safe)
c.toHex();                                // '#4A7CFF'
c.lighten(0.1); c.darken(0.1); c.mix(other, 0.3); c.tintOver(surface, 0.14);
c.contrastRatio(other);                   // WCAG 2.1 ratio (1..21)
c.meetsAA(fg); c.meetsAAA(fg);            // pass/fail
bg.onColor();                             // best of near-black / white on bg
bg.bestForegroundFrom([a, b, c]);         // highest-contrast candidate
```

Tonal ops run in HSL; contrast builds on `Color.computeLuminance()`.

---

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

- Pass it to the constructor together with required typography. Default mode is
  `SuperDeviceMode.mobile`. For desktop use
  `SuperTextTheme(isDesktop: true)`; mobile/tablet use the standard ramp.
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
        ? SuperMaterialThemeData.dark(
            mode: mode,
            textTheme: typography,
            primaryTextTheme: typography,
          )
        : SuperMaterialThemeData.light(
            mode: mode,
            textTheme: typography,
            primaryTextTheme: typography,
          ),
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

Ready-made GeniusLink components (all exported from the barrel). Compose these
instead of restyling raw `Container` / Material widgets.

| Widget | What it is | Key API |
|---|---|---|
| `SuperSectionCard` | Consolidated section/card surface replacing `SectionCard`, `SuperSection`, and `SuperCard`. | `title` / `header` - `child`/`children` - `footerBrand`/`footerActions` - `collapsible` - `expandedChild` - `selected`/`onTap` - `color` - `elevation` - `shape` |
| `SuperSectionHeader` | Section/page header, two styles. | `title` - `titleArabic` - `subtitle` - `eyebrow` - `marker` - `icon` - `leading` / `trailing` - `style` (`style1`/`style2`) |
| `SuperSectionFooter` | ALL-CAPS footer row + `SuperFooterLink`. | `brand` - `actions` - `showDivider` |
| `SuperGrid` / `SuperGridCell` | Responsive column grid. | `scope` - `overrideBreakpoint` - `mobile`/`tablet`/`desktop`/`large` spans and order |
| `SuperBreakpointProvider` | Provides a controlled local breakpoint. | `breakpoint` - `defaultWidth` - `child` |
| `SuperScaffold` | Responsive page-frame wrapper. | `maxWidth` - `padding` - `backgroundColor` - `child` |
| `AccentSectionCard` | Card with 3 px leading accent bar + tinted header (v2.4). | `title` - `icon` - `trailing` - `accentColor` - `child` - `bodyPadding` - `headerPadding` - `backgroundColor` |
| `SuperAppBar` | `PreferredSizeWidget` fork of `AppBar` (all props). Back button: `arrow_back_ios_new_rounded`. | `title` - `subtitle` + `subtitlePosition` - `actions` (overflow past `maxActions`) - `leading` - `bottom` - `flexibleSpace` |
| `SuperSliverAppBar` | Fork of `SliverAppBar` (all props). | same subtitle/overflow - `pinned` / `floating` / `snap` / `stretch` - `expandedHeight` - `flexibleSpace` |
| `SuperSnackBar` | Floating toast over `ScaffoldMessenger`. | `.info/.success/.warning/.danger(ctx, msg)` - `.build(...)` - `SuperSnackBarTone` |
| `SuperConfirmView` | Reusable non-modal confirmation hierarchy. | `title` - `description` - `content` - `confirmLabel`/`cancelLabel` - `onConfirm`/`onCancel` - `showCancel` - `isDestructive` |
| `SuperConfirmDialog` | Thin modal wrapper around `SuperConfirmView`. | `.show(...) -> Future<bool>` - same confirmation content/labels - `confirmEnabled` - `maxWidth` - barrier/root navigator options |
| `SuperFieldView` | Reusable title/description + form/custom-input content + actions. | `child` - `title` - `description` - `actions` - `padding` |
| `SuperFieldDialog` | Thin modal wrapper around `SuperFieldView`. | `.show<T>(...) -> Future<T?>` - `child` - `title` - `description` - `actions` - `maxWidth` |
| `SuperListTile` | GeniusLink list row with density presets + states. | `density` - `selected` - `badge` - `marker` - `leadingIcon` - `subtitle` - `trailingActions` - `loading` |
| `SuperGridTile` | Dashboard / catalog card with hover-reveal actions. | `header`/`child`/`footer` - `media` - `badge` - `overlay` - `actions` - `aspectRatio` - `loading` |
| `SuperSlider` | Responsive content carousel. | `children`/`itemBuilder` - `visibleItems` - `peek` - `autoPlay` - `loop` - `controller` - `onIndexChanged` |

> `SuperDialog` is not part of the public package API. For confirmation or
> field-entry flows, use the v3.2.0 View/Dialog primitives above. For generic
> one-off dialogs that do not fit those patterns, use Flutter's themed
> `showDialog` / `AlertDialog`.
>
> `SuperText` was **removed in 2.4.0** - use `context.superTextTheme.<field>`.
>
> `SectionCard`, `SectionHeader`, `SuperSection`, and `SuperCard` were
> **removed in 3.0.0** - use `SuperSectionCard` and `SuperSectionHeader`.

For the v3.2.1 View/Dialog family:

- inline confirmation → `SuperConfirmView`
- modal confirmation → `SuperConfirmDialog.show(...)`
- inline form/custom input → `SuperFieldView`
- modal form/custom input → `SuperFieldDialog.show<T>(...)`
- localize labels/copy at the call site; ambient `Directionality` handles RTL/LTR
- keep the default responsive dialog width unless the use case needs `maxWidth`
- keep shared UI/behavior in the View and dialog lifecycle in the Dialog

```dart
// Expandable, selectable card with a generated header:
SuperSectionCard(
  title: 'Downtown Central Store',
  subtitle: 'Store ID: STR-0042',
  marker: SuperMarker.identity,
  headerTrailing: const StatusPill('ACTIVE', tone: PillTone.success),
  expandedChild: const StoreDetailTable(),
  child: const StoreSummary(),
);

// Responsive page frame + grid:
SuperScaffold(
  maxWidth: 1120,
  child: SuperGrid(
    scope: SuperGridScope.current,
    children: const [
      SuperGridCell(mobile: 4, tablet: 4, desktop: 3, child: KpiCard()),
      SuperGridCell(mobile: 4, tablet: 4, desktop: 9, child: DetailsPanel()),
    ],
  ),
);

// Modal confirmation: thin dialog wrapper around reusable confirmation UI.
final confirmed = await SuperConfirmDialog.show(
  context,
  title: 'Delete Store?',
  description: 'This action cannot be undone.',
  confirmLabel: 'Delete',
  isDestructive: true,
  icon: Icons.delete_outline,
);

// Inline confirmation: same shared hierarchy, no modal lifecycle.
SuperConfirmView(
  title: 'Post journal entry?',
  description: 'Review the final totals before posting.',
  content: const JournalEntrySummary(),
  confirmLabel: 'Post',
  onConfirm: postEntry,
  onCancel: cancelReview,
);

// Reusable field layout; use SuperFieldDialog.show<T> for the modal form.
SuperFieldView(
  title: 'Exchange rate',
  actions: [SuperButton(label: 'Save', onPressed: saveRate)],
  child: const ExchangeRateFields(),
);

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

A new widget follows the same recipe as the existing ones: read surface,
spacing, and token values from `context.superTheme`, but read typography
**separately** from `context.superTextTheme`. Never access `.textTheme` through
`SuperThemeData` or `context.superTheme`. Drive motion from
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
  **`## [3.1.0]`**.
- **`README.md`** — update the symbol table and any example whose API changed.
- **`skill/claude_code/SKILL.md`** — update the version header, "What changed"
  summary, architecture block, and widget table.
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
