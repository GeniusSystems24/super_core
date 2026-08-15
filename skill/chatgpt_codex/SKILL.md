# super_core — ChatGPT / Codex agent instructions (v3.4.0)

Use these instructions whenever you build, theme, or modify Flutter code that
touches `super_core` — the shared **GeniusLink** design-system foundation for the
Super toolkit — or any package that depends on it.

---

## Package

```
name:    super_core
version: 3.4.0
import:  package:super_core/super_core.dart
sdk:     dart >=3.8.0    flutter >=3.32.0
deps:    google_fonts >=6.2.1 <7.0.0
```

## When to use

Apply this skill when the user asks for:
- "theme the app with the GeniusLink / Super design system"
- "light and dark theme", "palette switching", "brand colors"
- "responsive spacing / sizing / typography for mobile, tablet, desktop"
- reading Super surface tokens (`bg`, `surface`, `fg1…fg4`, `border`) in a widget
- building or modifying any `super_*` package theme
- reusable confirmation UI, confirmation dialogs, field/form views, or field dialogs


## What changed in 3.4.0 (section marker visibility)

1. **Section markers are independently optional.** `SuperSectionCard`,
   `SuperSectionCard1`, and `SuperSectionCard2` expose `showMarker`, defaulting
   to `true`.
2. **`showMarker` affects only the colored marker/rail.** With
   `showMarker: false`, keep title/subtitle text, icon/leading content, trailing
   content, and collapse/expand controls visible. Do not use it as a header
   label visibility switch.
3. **Header/title helpers match the cards.** `SuperSectionHeader`,
   `SuperSectionTitle1`, and `SuperSectionTitle2` expose the same `showMarker`
   option.
4. **Migration from the earlier local patch:** replace `showHeaderLabel` with
   `showMarker`. The semantics are now marker-only.
5. **Marker height is content-driven.** The visible marker stretches to the
   rendered header content height; do not reintroduce fixed marker heights in
   section-card headers.

## What changed in 3.3.0 (explicit Super typography)

1. **Typography is required on `SuperMaterialThemeData`.** Every `light` and
   `dark` call must provide `required SuperTextTheme textTheme` and
   `required SuperTextTheme primaryTextTheme`.
2. **No internal typography generator.** The nullable `TextTheme` inputs,
   `_textTheme` helper, and `mergeTextTheme` behavior are removed. Supply the
   complete Super type ramp explicitly.
3. **`SuperThemeData.textTheme` is removed.** Read branded styles from
   `context.superTextTheme` or `SuperMaterialThemeData.of(context).textTheme`.
   **Do not generate** `context.superTheme.textTheme`,
   `SuperThemeData.of(context).textTheme`, or `.textTheme` on any
   `SuperThemeData` value; those forms are invalid in v3.3.0.
4. **Responsive typography is caller-owned.** When `mode` changes, construct a
   matching `SuperTextTheme(isDesktop: mode == SuperDeviceMode.desktop)`.
5. **`copyWith` preserves Super typography.** Typography overrides on
   `SuperMaterialThemeData.copyWith` must also be `SuperTextTheme`.
6. **No font-family inference.** `SuperMaterialThemeData` does not inspect
   `SuperTextTheme` to derive token font metadata. The `_familyOf` helper is
   removed. Configure the ramp with `bodyFont` / `otherFont`; use `fontFamily`
   only as an explicit token-level override.

## What changed in 3.2.1 (distinct action footer)

1. **View actions use a dedicated footer surface.** `SuperConfirmView` and
   `SuperFieldView` place their actions on `SuperThemeData.bg`, separated
   from the main content by the standard `SuperThemeData.border` hairline.
2. **Do not hard-code footer colors.** Feature code should rely on this shared
   layout so light/dark themes and palette overrides remain automatic.
3. **Dialog wrappers inherit the same footer.** `SuperConfirmDialog` and
   `SuperFieldDialog` still compose their View counterparts; do not recreate
   the action area in a feature-specific dialog.


## What changed in 3.2.0 (reusable confirmation + field views/dialogs)

1. **`SuperConfirmView` added.** Use it when confirmation UI is embedded in a
   page, card, sheet, pane, or other non-modal surface. It owns the title,
   description, optional content, semantic intent icon, and confirm/cancel
   actions.
2. **`SuperConfirmDialog` added.** This is the modal wrapper around
   `SuperConfirmView`; prefer `SuperConfirmDialog.show(...)` for standard modal
   confirmation flows. It resolves to `true` only on confirmation and `false`
   on cancel or barrier dismissal.
3. **`SuperFieldView` added.** Use it for reusable form/custom-input content
   with optional title, description, and actions outside a dialog.
4. **`SuperFieldDialog` added.** This is the modal wrapper around
   `SuperFieldView`; `SuperFieldDialog.show<T>(...)` returns the value popped by
   the dialog. The caller owns field state, validation, actions, and result
   values.
5. **Views own shared UI; dialogs own presentation/lifecycle.** Never copy a
   View's title/content/action layout into its Dialog wrapper. Add shared
   behavior to the View and keep the Dialog thin.
6. **Design-system-only styling.** These components use ambient
   `SuperThemeData`, `DialogThemeData`, `ColorScheme`, responsive spacing/sizing,
   typography, and `SuperButton`. Use `isDestructive: true` for destructive
   confirmation instead of hand-styling a red action.
7. **Example coverage added.** See
   `example/lib/dialog_views_example_screen.dart` for inline views, modal
   results, destructive confirmation, and field-dialog usage.

## What changed in 3.1.0 (section-card variants)

1. **`SuperSectionCard1` added.** Use it for compact accent-title sections with
   optional collapse, expansion callbacks, selected state, footers, divider,
   custom surface fields, and ambient `SuperCardTheme` / `SuperSectionThemeData`
   integration.
2. **`SuperSectionCard2` added.** Use it for rail-and-chip sections with default
   collapsible behavior, optional footer, divider, selected state, and
   theme-driven animation, spacing, border, and radius.
3. **Section widgets moved under `widgets/section/`.** Continue importing from
   `package:super_core/super_core.dart`; do not rely on `src` paths.
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

## What changed in 2.4.0 (additive + breaking removals)

1. **`SuperTextTheme extends TextTheme`** replaces the removed `SuperText` static
   class. Factory `SuperTextTheme(tokens, {isDesktop, isArabic})`
   populates all 15 Material `TextTheme` slots via Google Fonts:
   `GoogleFonts.manrope()` (display/headline), `GoogleFonts.inter()`
   (body/label), `GoogleFonts.notoNaskhArabic()` (Arabic). Nine named fields:
   `displayLg`, `headlineSm`, `titleMd`, `bodyLg`, `bodySm`, `labelMd`,
   `labelSm`, `mono`, `eyebrow`. Convenience getters: `heading`, `body`, `label`,
   `caption`, `button`, `pill`, `h1`. In v3.3.0 read the active ramp via
   `context.superTextTheme.<field>`. `colorize(fg1, fg3)` applies fg tints and
   `superCopyWith({...})` preserves the type.
   - **Breaking:** `SuperText` (static class) **removed**. Replace
     `SuperText.<field>` with `context.superTextTheme.<field>`.
2. **Surface colors** updated to match GeniusLink reference tokens: light bg
   `#E6E8EB`, light surface `#F5F6F8`, dark bg `#0E141E`.
3. **Card shadows** — single-layer diffuse: dark `BoxShadow(0x1F000000, blur 28,
   dy 6)` / light `BoxShadow(0x0A000000, blur 32, dy 4)`.
4. **`AccentSectionCard`** — new widget: 3 px leading accent bar + tinted header
   strip. Props: `title`, `icon`, `trailing`, `accentColor`, `child`,
   `bodyPadding`, `headerPadding`, `backgroundColor`.
5. **`SectionCard` redesign** — background `surfaceContainerLow`, shadow-only (no
   default border). Added: `accentColor`, `icon`, `collapsible`,
   `initiallyExpanded`. **Removed:** `leading`, `trailing`.
6. **`SuperCard` redesign** — `background` → `color`; full Material `Card` parity
   (`shadowColor`, `surfaceTintColor`, `elevation`, `shape`, `borderOnForeground`,
   `clipBehavior`, `semanticContainer`); border transparent at rest.
   **Removed:** `leading`, `trailing`.
7. **`SuperAppBar`/`SuperSliverAppBar` chrome** — auto back button uses
   `Icons.arrow_back_ios_new_rounded` in a plain `IconButton`; route guard checks
   `parentRoute?.impliesAppBarDismissal`; title falls back to
   `context.superTextTheme.headlineSm`; subtitle falls back to `context.superTextTheme.labelSm` with
   `letterSpacing: 1.2`.
8. **`google_fonts: ^6.2.1`** added as a package dependency.

## What changed in 2.3.0 (compact density)

Cards, sections and tiles use tighter responsive insets — every padding value
comes from `SuperMetrics` so one theme override retunes the whole app:
`padding.card` 14/16/18 px, `spacing.section` 12/14/16 px,
`sizing.fieldComfortable` 44/42/40 px (mobile/tablet/desktop). See the 2.3.0
changelog entry for the full token delta.

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
   `SuperMaterialThemeData.light` accepts `tokens:` alongside the required
   `SuperTextTheme` values. Read tokens dynamically with
   `SuperThemeData.of(context).tokens.x`; there are no static token constants
   (use a brand-value literal where `const` is mandatory). `SuperMarker` colors
   resolve via `marker.resolve(tokens)`.
2. **Custom fonts.** In v3.3.0 construct the required `SuperTextTheme` with
   `bodyFont` / `otherFont` seeds and pass it as both `textTheme` and
   `primaryTextTheme`. Font metadata is not inferred from that ramp; pass
   `fontFamily` explicitly only when token-level font metadata must change. The
   former `mergeTextTheme` path no longer exists.
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
  String? fontFamily,           // token font-family metadata override
  required SuperTextTheme textTheme,
  required SuperTextTheme primaryTextTheme,
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
targets). `InputDecorationTheme` padding/density/height/border/icon constraints
follow the mode. Typography is explicit: rebuild `SuperTextTheme` for the active
mode (desktop uses `isDesktop: true`). Caller `formFieldTheme:` overrides
wholesale.

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

## Design-system widgets (v3.2.1)

Prefer these over hand-rolling GeniusLink chrome from raw `Container` / Material
widgets. All exported from the barrel; names start with `Super`.

`SuperSectionCard` - consolidated section/card surface.
`SuperSectionCard1` - compact accent-title section card.
`SuperSectionCard2` - rail-and-chip section card.
`SuperSectionHeader` - marker-bar or compact row header.
`SuperSectionFooter` / `SuperFooterLink` - branded footer actions.
`AccentSectionCard`, `StatusPill`, `SuperButton` / `SuperIconButton`,
`Hairline`, `FieldShell`, `SuperSnackBar`, `SuperConfirmView`,
`SuperConfirmDialog`, `SuperFieldView`, `SuperFieldDialog`, `SuperAppBar`,
`SuperSliverAppBar`, `SuperListTile`, `SuperGridTile`, `SuperSlider`, and the
layout primitives.

### `SuperSectionCard` - consolidated surface

Use `SuperSectionCard` instead of the removed `SectionCard`, `SuperSection`, and
`SuperCard`. It supports optional generated headers, custom headers, footers,
`child` or spaced `children`, collapse, selectable/tappable states, Material-card
`color`/`elevation`/`shape` options, and expandable detail content.

```dart
SuperSectionCard(
  title: 'Downtown Central Store',
  subtitle: 'Store ID: STR-0042',
  marker: SuperMarker.identity,
  expandedChild: const StoreDetailTable(),
  child: const StoreSummary(),
);
```

### `SuperSectionCard1` / `SuperSectionCard2` - specialized section surfaces

Use `SuperSectionCard1` for the compact accent-title treatment and
`SuperSectionCard2` for the rail-and-chip treatment. Both variants support
footer generation, expansion callbacks, selected state, divider, custom fill,
clip, margin, and themed animation.

```dart
SuperSectionCard1(
  title: 'Basic Accent Section',
  subtitle: 'Tap to collapse',
  icon: Icons.article_outlined,
  collapsible: true,
  footerBrand: 'SuperCore themed surface',
  footerActions: const [SuperFooterLink('Details')],
  child: const AccountDetailsForm(),
);

SuperSectionCard2(
  title: 'Ledger Balance',
  subtitle: 'Rail and icon-chip treatment',
  icon: Icons.account_balance_outlined,
  dividerAfterHeader: true,
  child: const BalanceSummary(),
);
```

### Layout primitives (v3.0.0)

```dart
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
```

### `AccentSectionCard` - accent-bar section card (new in v2.4.0)

3 px leading accent bar + tinted header strip. Best for sidebar / grouped
sections where the accent communicates the section intent.

```dart
AccentSectionCard(
  title: 'Bank Account',
  icon: const Icon(Icons.account_balance_outlined),
  accentColor: Colors.blue,
  child: const AccountForm(),
);
```

### Confirmation and field views/dialogs (v3.2.1)

Use the View component whenever the same content must work outside a modal. Use
the matching Dialog only for modal presentation and lifecycle. Do not duplicate
View layout or action styling in feature-specific dialogs.

```dart
// Inline confirmation content.
SuperConfirmView(
  title: 'Post journal entry?',
  description: 'Review the final totals before posting.',
  content: const JournalEntrySummary(),
  confirmLabel: 'Post',
  onConfirm: postEntry,
  onCancel: cancelReview,
);

// Modal confirmation. Returns false for cancel/barrier dismissal.
final confirmed = await SuperConfirmDialog.show(
  context,
  title: 'Delete store?',
  description: 'This action cannot be undone.',
  confirmLabel: 'Delete',
  isDestructive: true,
  icon: Icons.delete_outline,
);

// Inline fields/custom input.
SuperFieldView(
  title: 'Exchange rate',
  description: 'Enter the rate used for this transaction.',
  actions: [
    SuperButton(label: 'Save', onPressed: saveRate),
  ],
  child: const ExchangeRateFields(),
);

// Modal fields. The caller controls actions and the returned value.
final rate = await SuperFieldDialog.show<double>(
  context,
  title: 'Exchange rate',
  child: ExchangeRateEditor(
    onSave: (value) => Navigator.of(context).pop(value),
  ),
);
```

Selection rules:

- **Confirmation, inline/non-modal** → `SuperConfirmView`.
- **Confirmation, modal** → `SuperConfirmDialog` / `SuperConfirmDialog.show`.
- **Fields/custom input, inline/non-modal** → `SuperFieldView`.
- **Fields/custom input, modal** → `SuperFieldDialog` / `SuperFieldDialog.show<T>`.
- Use localized `title`, `description`, `confirmLabel`, and `cancelLabel`; ambient
  `Directionality` handles RTL/LTR.
- Prefer the default responsive dialog width. Override `maxWidth` only when the
  use case genuinely needs a different content width.
- Use `isDestructive: true` for destructive confirmation; do not introduce
  custom danger colors or raw `FilledButton` styling.

`SuperDialog` is not part of the public package API. For generic one-off dialogs
that do not fit the confirmation/field patterns, use Flutter's themed
`showDialog` / `AlertDialog`.

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

GeniusLink-specific chrome (v2.4.0): auto back button →
`Icons.arrow_back_ios_new_rounded` in a plain `IconButton`; route guard →
`parentRoute?.impliesAppBarDismissal`; title default style →
`context.superTextTheme.headlineSm` (Manrope 700); subtitle default style →
`context.superTextTheme.labelSm` with `letterSpacing: 1.2`.

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

### `SuperSectionHeader` / `SuperSectionFooter` / `SuperSectionCard` (v2.5)

`SuperSectionHeader` handles both former header shapes: style1 marker-bar form
headers and style2 compact row headers. `SuperSectionCard` composes the header,
body, and optional footer, and is the only section/card surface in v3.0.0.

```dart
SuperSectionCard(
  title: 'Financial',
  subtitle: 'Linked control account and terms',
  headerStyle: SuperSectionHeaderStyle.style2,
  icon: Icons.sync_alt,
  collapsible: true,
  footerBrand: 'GeniusLink ERP',
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
final typography = SuperTextTheme();
final t = SuperMaterialThemeData.dark(
  textTheme: typography,
  primaryTextTheme: typography,
).copyWith(
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
`SuperThemeData.of(context)` must keep working.

**v2.4.0 breaking removals:** `SuperText` (static class) removed — replace every
`SuperText.<field>` with `context.superTextTheme.<field>`. In v3.3.0,
`SuperThemeData.textTheme` is also removed. `SuperCard`
`leading`/`trailing` removed; `background` renamed `color`. `SectionCard`
`leading`/`trailing` removed. Bump dependent constraints to `>=2.4.0 <3.0.0`.

**v2.0.0 breaking:** `SuperTokens` (static) removed — read tokens from
`SuperThemeData.of(context).tokens` (no static constants remain). `SuperDialog`
removed. Bump to `>=2.0.0 <3.0.0`.

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
