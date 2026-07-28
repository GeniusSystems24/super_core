# Super Core

The shared **GeniusLink** design-system foundation for the Super toolkit —
the single source of truth for colors, palettes, Material themes, typography,
spacing, radii, motion, formatters, and design-system widgets.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  super_core: ^3.1.0  # monorepo path dependency
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
| `SuperPalette` | Ten swappable color palettes, each with 10 shades + semantic getters |
| `SuperMaterialThemeData` | Complete Material 3 theme — **a `ThemeData` subclass** (palette + responsive `SuperDeviceMode`) |
| `SuperDeviceMode` | `mobile` / `tablet` / `desktop` device mode + `SuperResponsive<T>` container |
| `SuperMetrics` | Responsive spacing / sizing / padding / margin token bundle |
| Layout | `SuperBreakpoint`, `SuperBreakpoints`, `SuperBreakpointProvider`, `SuperGrid`, `SuperGridCell`, `SuperGridScope`, `SuperScaffold` |
| `SuperInteractiveStateThemeData` | Hover / focus / pressed / selected overlay treatment (`ThemeExtension`) |
| `SuperTokensData` | **Dynamic** brand tokens carried by the theme (accent + semantic palette, font families, spacing, radii, motion). Read via `SuperThemeData.of(context).tokens`. |
| `SuperThemeData` | Swappable light/dark `ThemeExtension` — surfaces, borders, `fg1…fg4` text ramp, `tokens`, and `textTheme` |
| `SuperTextTheme` | `TextTheme` subclass — all 15 Material slots + 9 named fields (`displayLg`, `headlineSm`, `titleMd`, `bodyLg`, `bodySm`, `labelMd`, `labelSm`, `mono`, `eyebrow`). Powered by Google Fonts (Manrope / Inter / Noto Naskh Arabic). Read via `context.superTheme.textTheme`. |
| `SuperAppBarTheme` | `AppBarTheme` subclass — adds `subtitlePosition` + responsive `maxActions` / `maxMobileActions` / `maxTabletActions` / `maxDesktopActions` |
| `SuperCardTheme` | `CardThemeData` subclass — expand direction / duration / curve, tap-to-toggle, chevron, padding, border colors |
| `SuperSemanticColors` | Structured status-color bundle (`info`/`success`/`warning`/`danger`/`accent`/`neutral`), each with `solid`/`onSolid`/`subtle`/`onSubtle`/`border` |
| `SuperColorX` | Color-extension helpers — HSL tonal ops, WCAG 2.1 contrast, hex parse/format |
| `SuperFormat` | Intl-free number / currency / byte / serial formatters |
| `SuperMarker` | Three section-marker intents (identity / ledger / notes) |
| Widgets | `SuperSectionCard`, `SuperSectionCard1`, `SuperSectionCard2`, `SuperSectionHeader`, `SuperSectionFooter`, `AccentSectionCard`, `StatusPill`, `SuperButton`, `Hairline`, `FieldShell`, `SuperSnackBar`, `SuperAppBar`, `SuperSliverAppBar`, `SuperListTile`, `SuperGridTile`, `SuperSlider` |
| Plumbing | Failures, typedefs, usecases, key-direction + `BuildContext` helpers |

> **Migrating from v2.4?** `SectionCard`, `SuperSection`, and `SuperCard` are
> replaced by `SuperSectionCard`; `SectionHeader` is replaced by
> `SuperSectionHeader`. See `skill/migration_v2.4.0_to_v3.0.0/`.
>
> **Migrating from v1?** `SuperTokens.x` → `SuperThemeData.of(context).tokens.x`.
> `SuperDialog` is removed — use Flutter's `showDialog` / `AlertDialog`.
> See the `skill/migration_v1_to_v2/` guides.

---


## v3.1.0 Section Card Variants

`SuperSectionCard` remains the consolidated default surface introduced in
v3.0.0. Use the new variants when a screen needs one of the tighter GeniusLink
section treatments:

```dart
SuperSectionCard1(
  title: 'Basic Accent Section',
  subtitle: 'Tap to collapse',
  icon: Icons.article_outlined,
  collapsible: true,
  footerBrand: 'SuperCore themed surface',
  footerActions: const [
    SuperFooterLink('Details'),
    SuperFooterLink('Apply', emphasized: true),
  ],
  child: const AccountDetailsForm(),
);

SuperSectionCard2(
  title: 'Ledger Balance',
  subtitle: 'Rail and icon-chip treatment',
  icon: Icons.account_balance_outlined,
  accentColor: Theme.of(context).colorScheme.secondary,
  dividerAfterHeader: true,
  child: const BalanceSummary(),
);
```

Both variants read fill, border, radius, padding, margin, and animation defaults
from `SuperSectionThemeData` and `SuperCardTheme`. They also support initial
expansion with `initiallyExpanded`, expansion notifications with
`onExpansionChanged`, prebuilt footers via `footer`, or generated footers via
`footerBrand` and `footerActions`.

---

## v3.0.0 Layout and Section APIs

### Consolidated section components

Use `SuperSectionCard` for the surfaces that were previously split across
`SectionCard`, `SuperSection`, and `SuperCard`:

```dart
SuperSectionCard(
  title: 'Financial',
  subtitle: 'Linked control account and terms',
  headerStyle: SuperSectionHeaderStyle.style2,
  icon: Icons.sync_alt,
  children: const [
    AccountField(),
    TermsField(),
  ],
);

SuperSectionCard(
  color: context.superTheme.inputBg,
  selected: selected,
  onTap: onSelect,
  expandedChild: const StoreDetails(),
  child: const StoreSummary(),
);
```

Use `SuperSectionHeader` for all section headers:

```dart
SuperSectionHeader(
  title: 'Opening Balance',
  subtitle: 'Ledger totals carried into the new period',
  marker: SuperMarker.ledger,
  trailing: const StatusPill('BALANCED', tone: PillTone.success),
);
```

### Layout components

Use `SuperScaffold` as a responsive page-frame wrapper and `SuperGrid` for
column-based layouts:

```dart
Scaffold(
  appBar: const SuperAppBar(title: Text('Dashboard')),
  body: SuperScaffold(
    maxWidth: 1120,
    child: SuperGrid(
      scope: SuperGridScope.current,
      children: const [
        SuperGridCell(mobile: 4, tablet: 4, desktop: 3, child: KpiCard()),
        SuperGridCell(mobile: 4, tablet: 4, desktop: 9, child: DetailsPanel()),
      ],
    ),
  ),
);
```

Use `SuperBreakpointProvider` when previews, dialogs, or side panels need a
controlled local breakpoint:

```dart
SuperBreakpointProvider(
  breakpoint: SuperBreakpoint.tablet,
  child: SuperGrid(
    scope: SuperGridScope.provider,
    children: const [
      SuperGridCell(mobile: 4, tablet: 8, child: PreviewPanel()),
    ],
  ),
);
```

### Migrating from 2.4.0

```dart
// Before
SectionCard(title: 'Account Details', child: form);
SuperSection(title: 'Financial', children: fields);
SuperCard(color: context.superTheme.inputBg, child: summary);
SectionHeader(title: 'Opening Balance');

// After
SuperSectionCard(title: 'Account Details', child: form);
SuperSectionCard(title: 'Financial', children: fields);
SuperSectionCard(color: context.superTheme.inputBg, child: summary);
SuperSectionHeader(title: 'Opening Balance');
```

See `skill/migration_v2.4.0_to_v3.0.0/` for the full migration guide.

---

## SuperPalette

Ten built-in palettes:

| Palette | `shade500` | Notes |
|---|---|---|
| `SuperPalette.bluePalette` | `#4A7CFF` | Default GeniusLink accent |
| `SuperPalette.purplePalette` | `#7C5CFC` | Violet / indigo |
| `SuperPalette.greenPalette` | `#1DB88A` | GeniusLink success green |
| `SuperPalette.goldenPalette` | `#F59E0B` | Warm amber / gold |
| `SuperPalette.tealPalette` | — | Teal |
| `SuperPalette.rosePalette` | — | Rose |
| `SuperPalette.indigoPalette` | — | Indigo |
| `SuperPalette.slatePalette` | — | Slate |
| `SuperPalette.grayPalette` | `#64748B` | Neutral grays |
| `SuperPalette.monochromePalette` | `#737373` | Pure black / white |

Each palette exposes ten shades (`shade50` … `shade900`) and semantic
accessors: `primary`, `primaryDark`, `onPrimary`, `error`, `info`, `success`,
`warning`, plus light/dark surface tokens (`lightBg`, `darkSurface`,
`darkFg1`, …).

All palettes use the same **GeniusLink-standard neutral surfaces** — only the
accent/primary color varies. This preserves the precision-instrument feel of
the design system regardless of which palette is active.

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
s.spacing.cardPadding;   s.spacing.lg;   s.sizing.fieldComfortable;   s.spacing.sectionMargin;

// Author your own responsive value with the same container:
const gutter = SuperResponsive<double>(mobile: 16, tablet: 24, desktop: 32);
gutter.resolve(mode);
```

The generated `TextTheme` and `InputDecorationTheme` also scale per mode
(font size / line height, and field padding / density / height / border /
icon constraints). Caller `textTheme:` / `formFieldTheme:` override these
wholesale.

### Compact density (v2.3.0)

Every inset a card draws comes from the responsive scales below — cards no
longer hard-code `space6` / `space10`, so overriding the metrics (or the card
theme) retunes the whole app's density:

| Token | mobile | tablet | desktop |
|---|---|---|---|
| `spacing.cardPadding` | 14 | 16 | 18 |
| `spacing.pagePadding` | 12 | 20 / 16 | 48 / 24 |
| `spacing.fieldPadding` | 12 / 10 | 12 / 10 | 14 / 8 |
| `spacing.section` (gap between cards) | 12 | 14 | 16 |
| `spacing.xl` (header → body) | 20 | 22 | 24 |
| `spacing.md` (card slot gap) | 10 | 12 | 12 |
| `spacing.sectionMargin` | 12 | 14 | 16 |
| `sizing.fieldComfortable` | 44 | 42 | 40 |

```dart
// Roomier again, app-wide:
SuperMaterialThemeData.light(
  cardTheme: const SuperCardTheme(padding: EdgeInsets.all(24)),
);
// …or per card:
SuperSectionCard(padding: const EdgeInsets.all(20), title: 'Account Details', child: form);
```

### Runtime palette switching

```dart
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
```

### What's configured

- Complete `ColorScheme` derived from the palette — including the Material 3
  **fixed** accent roles (`primaryFixed`, `primaryFixedDim`, `onPrimaryFixed`,
  `onPrimaryFixedVariant`, and the secondary/tertiary equivalents) and the full
  **surface-container ramp** (`surfaceDim`, `surfaceBright`,
  `surfaceContainerLowest` → `surfaceContainerHighest`)
- Typography wired to Manrope / Inter / JetBrains Mono
- **Scaffold background = `ColorScheme.surface`** (the GeniusLink page
  background). Cards, panels and fields sit on lifted surface tokens so the
  screen matches the mobile light/dark surface stack.
- **App bar** painted on the same page background as the Scaffold, with a
  `systemOverlayStyle` that paints the **status bar and navigation bar** the
  same color and picks status/nav icon brightness automatically for contrast
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
Text('TOTAL', style: t.textTheme.label.copyWith(color: t.fg2));
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

GeniusLink-specific chrome (v2.4.0):

- Auto-implied **back button** uses `Icons.arrow_back_ios_new_rounded` in a
  plain `IconButton` (not Flutter's platform-default `BackButton`).
- Auto-implied button appears when `parentRoute?.impliesAppBarDismissal` is
  true; suppressed correctly on root routes.
- Default **title style** falls back to `t.textTheme.headlineSm` (Manrope 700).
- Default **subtitle style** falls back to `t.textTheme.labelSm` with
  `letterSpacing: 1.2` — matching the ALL-CAPS breadcrumb style.

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

## `SuperSectionCard`

`SuperSectionCard` is the consolidated section/card surface. It can render a
plain card, compose a `SuperSectionHeader` and `SuperSectionFooter`, collapse a
body, show selected/tap states, and reveal `expandedChild` vertically or
horizontally. Defaults come from `SuperSectionThemeData` and `SuperCardTheme`.

```dart
SuperSectionCard(
  leading: const Icon(Icons.storefront_outlined),
  header: const SuperSectionHeader(title: 'Downtown Central Store'),
  headerTrailing: const StatusPill('ACTIVE', tone: PillTone.success),
  color: context.superTheme.inputBg,
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
