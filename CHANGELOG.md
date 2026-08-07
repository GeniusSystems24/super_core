# Changelog

All notable changes to **super_core** are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/); versioning is
[SemVer](https://semver.org/).

---

## [3.2.1] - 2026-08-07

Action-footer visual separation for reusable View/Dialog components.

### Changed

- `SuperConfirmView` and `SuperFieldView` now render their actions in a
  visually distinct footer surface, inherited automatically by
  `SuperConfirmDialog` and `SuperFieldDialog`.
- The footer uses the active `SuperThemeData.bg` surface with the existing
  `SuperThemeData.border` hairline instead of introducing component-specific
  colors, so light/dark themes and palette overrides remain consistent.
- Action-footer horizontal insets continue to follow the View padding while
  vertical spacing uses the responsive `SuperSpacing` scale.

---

## [3.2.0] - 2026-08-07

Reusable confirmation and field view/dialog primitives.

### Added

- `SuperConfirmView` for reusable confirmation title, description, optional
  content, semantic intent icon, and confirm/cancel actions.
- `SuperConfirmDialog` as a thin modal wrapper around `SuperConfirmView`, with
  boolean dialog results, destructive intent support, and configurable width.
- `SuperFieldView` for reusable form/custom-input layouts with optional title,
  description, and actions.
- `SuperFieldDialog` as a thin modal wrapper around `SuperFieldView`.
- Widget tests covering View/Dialog composition, callbacks, RTL content, dark
  theme usage, and modal lifecycle.
- Example screen demonstrating all four View/Dialog components, including
  inline usage, modal results, and destructive confirmation.

### Changed

- Public exports now include the four reusable View/Dialog components.
- Dialog components rely on the package `DialogThemeData`, `SuperThemeData`,
  responsive spacing/sizing, typography, semantic colors, and `SuperButton`
  instead of introducing parallel component styling.
- Agent skill documentation now targets v3.2.0 and documents when to use the
  reusable View/Dialog pairs, their lifecycle boundaries, and destructive
  confirmation guidance.

---

## [3.1.2] - 2026-07-29

Typography factory cleanup and Arabic example simplification.

### Changed

- `SuperTextTheme.fromTokens` no longer requires a positional
  `SuperTokensData`; callers now use named arguments only.
- `SuperTextTheme.fromTokens` now accepts optional `bodyFont` and `otherFont`
  `TextStyle` seeds before applying the Super type ramp metrics.
- `SuperMaterialThemeData`, `SuperThemeData.textTheme`, and the example app now
  use the simplified typography factory signature.

### Migration

Replace positional-token calls with named arguments:

```dart
// Before
SuperTextTheme.fromTokens(tokens, isArabic: true);

// After
SuperTextTheme.fromTokens(isArabic: true);
```

To seed custom faces, pass `bodyFont:` and `otherFont:`:

```dart
SuperTextTheme.fromTokens(
  bodyFont: const TextStyle(fontFamily: 'Inter'),
  otherFont: const TextStyle(fontFamily: 'Manrope'),
);
```

---

## [3.1.1] - 2026-07-28

Arabic / RTL example coverage and section-card expansion fixes.

### Added

- Shared Arabic / RTL example content across the theme demo, widget gallery,
  layout components, section components, and create-account example screens.
- Create-account example fields for Arabic account data using RTL direction.
- Section-card tests covering non-collapsible visibility, RTL rail resolution,
  and keep-alive expansion state.

### Changed

- `SuperSectionCard1` and `SuperSectionCard2` now keep expansion state alive in
  scrollable lists.
- `collapsible` now strictly controls whether the card can collapse, while
  `initiallyExpanded` only seeds the default state for collapsible cards.
- `SuperSectionCard2` uses directional padding and border radius for RTL/LTR
  layouts and keeps non-collapsible bodies visible.
- The example app enables Arabic-aware Super text theme merging.

---

## [3.1.0] - 2026-07-28

Section-card variants and package skill documentation refresh.

### Added

- **`SuperSectionCard1`** - compact accent-title section card with optional
  collapse, expansion callback, selected state, footer support, custom
  surface controls, and `SuperCardTheme` / `SuperSectionThemeData` integration.
- **`SuperSectionCard2`** - rail-and-chip section card with default collapsible
  behavior, optional footer, divider, selected state, deprecated compatibility
  aliases, and theme-driven animation and spacing.
- Section-card gallery examples covering `SuperSectionCard`,
  `SuperSectionCard1`, `SuperSectionCard2`, standalone section headers, footers,
  dividers, custom accents, and expansion callbacks.

### Changed

- Section widgets are now grouped under `lib/src/core/widgets/section/` and
  re-exported through the package barrel.
- `SuperMaterialThemeData` now seeds `SuperCardTheme.borderColor` from
  `ColorScheme.outlineVariant`, so section-card variants can share the same
  themed resting border.
- Agent skill instructions under `skill/` now describe the current 3.1.0
  section-card API surface.

---

## [3.0.0] - 2026-07-27

Layout primitives and section/card API consolidation. This release also includes
the previously implemented responsive spacing-system updates, so card, field,
page, section, and control metrics continue to resolve from
`SuperThemeData.of(context).spacing`.

### Added

- **Super layout components** ported from the legacy GeniusLink UI kit and
  renamed to Super APIs: `SuperBreakpoint`, `SuperBreakpoints`,
  `SuperBreakpointProvider`, `SuperGrid`, `SuperGridCell`, `SuperGridScope`, and
  `SuperScaffold`.
- **`SuperSectionCard`** - the single section/card surface that replaces
  `SectionCard`, `SuperSection`, and `SuperCard`. It supports generated or
  custom headers, footers, `child`/`children`, collapsible bodies, selected/tap
  states, expandable detail content, Material-card fill/elevation/shape options,
  and theme-driven spacing.
- **Example screen** - `example/lib/layout_components_screen.dart` demonstrates
  `SuperScaffold`, breakpoint resolution, provider-controlled breakpoints, and
  responsive `SuperGrid` layouts.
- **Migration skill** - `skill/migration_v2.4.0_to_v3.0.0/` documents the
  v2.4.0-to-v3.0.0 migration with before/after examples.

### Changed

- **`SuperSectionHeader`** is now the only section-header widget. It absorbs the
  old `SectionHeader` compatibility shape (`accentColor`, `icon`, `trailing`)
  and keeps the two-style `SuperSectionHeaderStyle` API.
- Examples now use `SuperSectionCard`, `SuperSectionHeader`, and the active
  `context.superTheme.spacing` APIs.
- Public exports now include the layout folder and no longer export the removed
  section/card implementation files.

### Removed

- `SectionCard`
- `SectionHeader`
- `SuperSection`
- `SuperCard`
- Direct imports for `section_card.dart`, `section_header.dart`,
  `super_section.dart`, and `super_card.dart`

### Migration

Replace removed classes with the consolidated APIs:

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

For nSuperTextTheme

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

See `skill/migration_v2.4.0_to_v3.0.0/` for the full migration guide.

---

## [2.4.0] — 2026-07-27

Design-system visual alignment: surface colors, card shadows, typography, and
app-bar chrome are brought into full fidelity with the GeniusLink reference
design tokens. `SuperTextTheme` replaces the former `SuperText` static class,
becoming a real `TextTheme` subclass powered by Google Fonts. Cards shed their
default borders and `leading`/`trailing` slots, gain Material `Card` parity, and
a new `AccentSectionCard` widget is added. App bars adopt the iOS-style rounded
back chevron and `headlineSm` title weight.

### Added

- **`SuperTextTheme extends TextTheme`** (`super_text_styles.dart`) — a full
  `TextTheme` subclass that populates all 15 Material slots and additionally
  exposes nine named fields (`displayLg`, `headlineSm`, `titleMd`, `bodyLg`,
  `bodySm`, `labelMd`, `labelSm`, `mono`, `eyebrow`) and convenience getters
  (`heading`, `body`, `label`, `caption`, `button`, `pill`, `h1`).
  - `SuperTextTheme.fromTokens(tokens, {isDesktop, isArabic})` — factory driven
    by Google Fonts: `GoogleFonts.manrope()` (display), `GoogleFonts.inter()`
    (body/label), `GoogleFonts.notoNaskhArabic()` (Arabic script).
  - `colorize(Color fg1, Color fg3)` — returns a `SuperTextTheme` with heading
    and body/label slots tinted by the two foreground ramp values.
  - `superCopyWith({...})` — preserves the concrete type while overriding any
    of the nine named fields.
  - `SuperThemeData.textTheme` getter — returns a colorless `SuperTextTheme`
    (for component-level use before `fg*` colors are applied).
- **`AccentSectionCard`** — new card widget with a 3 px leading accent bar and a
  tinted header strip. Props: `title`, `icon`, `trailing`, `accentColor`, `child`,
  `bodyPadding`, `headerPadding`, `backgroundColor`. Background defaults to
  `colorScheme.surfaceContainerLow`; shadow from `t.cardShadow`. Exported through
  the barrel.
- **`google_fonts: ^6.2.1`** added as a package dependency. `SuperTextTheme` uses
  it exclusively — no asset font files required.

### Changed

#### Theme colors

- **`SuperPalette`** light/dark surface constants updated to match the GeniusLink
  reference tokens (`GeniusColorTokens`):
  - Light background: `#E9EDF3` → `#E6E8EB`
  - Light surface (card): `#F8FAFD` → `#F5F6F8`
  - Dark background: `#09131D` → `#0E141E`
- **`SuperThemeData`** static preset literals updated to match.

#### Card shadows

- `SuperThemeData.cardShadowDark` — replaced with a single diffuse shadow:
  `BoxShadow(color: 0x1F000000, blurRadius: 28, offset: Offset(0, 6))`.
- `SuperThemeData.cardShadowLight` — replaced with a single soft shadow:
  `BoxShadow(color: 0x0A000000, blurRadius: 32, offset: Offset(0, 4))`.

#### `SuperText` removed — migrate to `t.textTheme.*`

- **`SuperText`** static class is **removed**. All usages across the library and
  example files are migrated to `context.superTheme.textTheme.<field>`:
  - `SuperText.body` → `t.textTheme.body`
  - `SuperText.caption` → `t.textTheme.caption`
  - `SuperText.label` → `t.textTheme.label`
  - `SuperText.button` → `t.textTheme.button`
  - `SuperText.heading` → `t.textTheme.heading`
  - `SuperText.eyebrow` → `t.textTheme.eyebrow`
  - `SuperText.pill` → `t.textTheme.pill`
  - `SuperText.mono` → `t.textTheme.mono`
  - `SuperText.h1` → `t.textTheme.h1`

#### `SectionCard` redesign

- Background changed from `surface` to `colorScheme.surfaceContainerLow`;
  hairline border removed (shadow-only resting state).
- Shadow sourced from `t.cardShadow` (tokens-driven, dark/light adaptive).
- Removed `leading` and `trailing` props.
- Added `accentColor`, `icon`, `collapsible`, `initiallyExpanded` props.
- Animated chevron (`Icons.keyboard_arrow_down_rounded`) when `collapsible: true`;
  body animates with `AnimatedAlign(heightFactor: …)`.
- Title uses `t.textTheme.titleMd`; subtitle uses `t.textTheme.labelSm` with
  `letterSpacing: 1.2` (ALL-CAPS).

#### `SuperCard` redesign

- Removed `leading` and `trailing` props.
- Renamed `background` → `color` (parity with Material `Card`).
- Added all standard Material `Card` properties: `shadowColor`,
  `surfaceTintColor`, `elevation`, `shape`, `borderOnForeground`,
  `clipBehavior`, `semanticContainer`.
- Border logic: transparent at rest → `t.border` on hover → `cs.primary` when
  selected. `elevation == 0` → no shadow; explicit `shadowColor` → proportional
  shadow; otherwise `t.cardShadow`.
- `SuperCardTheme` defaults: `color: cs.surfaceContainerLow`, shape has no
  default `side` (hairline border removed at rest).

#### `SuperAppBar` / `SuperSliverAppBar` — reference design alignment

- **Back button**: the auto-implied back button now renders
  `Icons.arrow_back_ios_new_rounded` inside a plain `IconButton` (was Flutter's
  `BackButton` with the platform-default `arrow_back` icon).
- **Route guard**: auto-leading now checks
  `parentRoute?.impliesAppBarDismissal` instead of `parentRoute?.canPop`, which
  correctly suppresses the back button when the route is the root.
- **Title style**: the default title `TextStyle` falls back to
  `t.textTheme.headlineSm` (Manrope 24/700) instead of Material's `titleLarge`.
- **Subtitle style**: the default subtitle `TextStyle` falls back to
  `t.textTheme.labelSm` with `letterSpacing: 1.2` instead of `bodySmall`.
- `SuperSliverAppBar` inherits all of the above (it delegates to `SuperAppBar`).

### Migration

`SuperText` is the only removed API. Replace every `SuperText.<field>` with
`context.superTheme.textTheme.<field>` (or `t.textTheme.<field>` where `t` is
the local `SuperThemeData`). The `import` of `super_text_styles.dart` can be
removed from any file that previously imported it for `SuperText` alone.

`SuperCard`'s `background` parameter was renamed to `color` and `leading` /
`trailing` were removed; update any call sites.

`SectionCard`'s `leading` and `trailing` were removed; update any call sites.

---

## [2.3.0] — 2026-07-26

Compact card density. Cards, sections and tiles lost their oversized insets: the
responsive **`SuperMetrics`** scales are one step tighter, the card interior is a
single even inset (the 40px bottom tail is gone), and every card widget now
resolves its padding from the theme instead of hard-coding a token — so one
theme override retunes the whole app's density.

### Changed

- **Theme surface stack** — light/dark defaults now follow the provided mobile
  references: Scaffold + app bar share the page background, cards sit on a
  softly lifted surface, and fields/search controls use the highest field
  surface (`#FFFFFF` light, `#1B2738` dark).
- **FAB theme** — default floating action buttons now use the brand blue
  `#4A7CFF` in both light and dark themes, white icons/text, and the mobile
  reference's compact 54px rounded-square shape.
- **`SuperMetrics.padding.card`** — `16 / 20 / 24 24 24 40` →
  `14 / 16 / 18` (mobile / tablet / desktop), an even inset on all sides.
- **`SuperMetrics.padding.page`** — mobile `16` → `12`; tablet `32/28` →
  `20/16`; desktop `80/40` → `48/24`.
- **`SuperMetrics.padding.field`** — mobile `14/14` → `12/10`; tablet
  `14/12` → `12/10`; desktop `16/10` → `14/8`.
- **`SuperMetrics.padding.control`** — mobile `16/14` → `14/10`; tablet
  `16/12` → `16/10`.
- **`SuperMetrics.spacing`** — `sm` 8 → 6 (mobile/tablet), `md` 12/14/16 →
  10/12/12, `lg` 16/20/24 → 14/16/16, `xl` 20/28/32 → 20/22/24,
  `section` 20/28/32 → **12/14/16**.
- **`SuperMetrics.margin.section`** — `20/28/32` → `12/14/16`;
  `margin.page` tablet `40` → `24`, desktop `120` → `64`.
- **`SuperMetrics.sizing`** — `fieldComfortable` 48/44/42 → **44/42/40**,
  `fieldCompact` 42/42/42 → **38/38/36**. Control, icon-button and touch-target
  sizes are unchanged (mobile hit targets stay ≥ 44px).
- **`SectionCard`**, **`SuperCard`**, **`SuperSection`** — interior padding now
  defaults to `SuperThemeData.padding.card` (responsive) instead of
  `EdgeInsets.all(space6)` / `fromLTRB(24, 24, 24, 40)`. `SuperSection` no longer
  adds a taller bottom inset when it has no footer.
- **Header → body gap** — `SectionCard` / `SuperSection` use `spacing.xl`
  (20–24) instead of `space8` (32); `SuperSection` footer gap uses `spacing.lg`;
  `SuperCard` slot gap uses `spacing.md` instead of `space4`.
- **`SuperCardTheme`** installed by `SuperMaterialThemeData` — `padding` is
  `m.padding.card`, `gap` is `m.spacing.md`.
- **Section markers** — `SuperTokensData.markerHeight` 40 → 34; a title-only
  header draws an 18px bar (was 20) and sits `space3` from the title (was
  `space4`). `SuperSectionHeader` style2: bar height 36 → 28, icon chip 30 → 26.
  `SuperTileMarker.height` default 40 → 28.
- **`SuperTileDensity`** — `compact` minHeight 40 → 36, `comfortable` 56 → 48,
  `expanded` 72 → 60, with one step less interior padding and gap each.
- **`SuperSectionFooter`** — vertical padding `space4` → `space3`, action
  spacing `space6` → `space4`.

### Added

- **`SuperCard.background`** — per-card background override that wins over
  `SuperCardTheme.color` while preserving the selected-card tint behavior.
- **Example** — `example/lib/create_account_screen.dart`: the GeniusLink mobile
  "Create Account" form (segmented type selector, group select, parent-account
  search, bilingual name fields, main-account switch, notes) built only from
  `SuperAppBar` + `SuperSectionCard` + `SuperSectionHeader.style2` + `FieldShell`,
  with every inset read from `SuperMetrics`. Reachable from the theme demo's
  app bar.

### Migration

Nothing to change — the new values are defaults. To restore the old roomier
density, override the metrics on the theme:

```dart
SuperMaterialThemeData.light(
  cardTheme: const SuperCardTheme(padding: EdgeInsets.all(24)),
  // or per widget: SectionCard(padding: …), SuperSection(padding: …)
);
```

---

## [2.1.0] — 2026-07-18

Color-system enhancement plus one **breaking** cleanup: the last static token
values are removed so the theme is the only source of brand tokens (see
_Changed (breaking)_). All new APIs are exported through the `super_core` barrel.

### Changed (breaking)

- **No static token values remain.** v2.0.0 kept a `static const` mirror of
  every `SuperTokensData` field (`SuperTokensData.defaultAccent`,
  `defaultSpace4`, …) and a `SuperMarker.<x>.defaultColor`, for `const` call
  sites. These are **all removed** — brand tokens can only be read dynamically
  from the ambient theme (`SuperThemeData.of(context).tokens.x` /
  `context.superTheme.tokens.x`). The default values now live solely as the
  literals in the `SuperTokensData` constructor; `SuperTokensData.fallback` (the
  default *instance*) is unchanged.
  - Migration: `SuperTokensData.default<Field>` → `context.superTheme.tokens.<field>`
    (drop the enclosing `const`); where `const` is mandatory (enum arg, static
    const, default parameter, `initState`) use a brand-value literal.
    `SuperMarker.<x>.defaultColor` → `SuperMarker.<x>.resolve(tokens)`. All Super
    toolkit packages + examples were migrated. Full guide:
    `skill/migration_v2_to_v2.1/`.

### Added

#### SuperListTile & SuperGridTile — enterprise tile family

- New `SuperListTile` — a GeniusLink list row refactored from Flutter's
  `ListTile` baseline: density presets (`SuperTileDensity.compact` /
  `comfortable` / `expanded`), selection + hover/focus/press/disabled states,
  status `badge`, `marker` bar, `leadingIcon` / multiple `leadingWidgets`,
  `subtitle` + `supporting` block, `trailing` / `trailingActions`, configurable
  `showSeparator`, `loading` skeleton, keyboard activation, RTL and
  `contextMenuBuilder`. Core `ListTile` slots (leading/title/subtitle/trailing/
  onTap/selected/enabled/dense) are preserved.
- New `SuperGridTile` — a GeniusLink dashboard / catalog card refactored from
  `GridTile`: `header` / `child` / `footer` slots, `media` banner, `badge` +
  `overlay`, hover-revealed `actions`, selection + hover/press/focus/disabled
  states (lift + shadow on hover), `aspectRatio`, `loading` placeholder, RTL,
  keyboard activation and `contextMenuBuilder`.
- Shared internals (`super_tile_common.dart`) — `SuperTileDensity`,
  `SuperTileMetrics`, `SuperTileVisualState`, `superTileFill` / `superTileBorder`,
  `SuperTileMarker`, `SuperTileShimmer` — so both tiles resolve density and
  interaction states from one source. All exported through the barrel and
  showcased in the component gallery.

#### Structured semantic colors — `SuperSemanticColors`

- New `SuperSemanticColor` — a single intent expanded into the roles a status
  surface needs: `solid`, `onSolid`, `subtle` (opaque tint over the card
  surface), `onSubtle`, and `border`. `SuperSemanticColor.fromBase` derives the
  whole set from one solid + surface + brightness, choosing `onSubtle` by WCAG
  contrast.
- New `SuperSemanticColors` `ThemeExtension` — six intents (`info`, `success`,
  `warning`, `danger`, `accent`, `neutral`) plus `byIntent(SuperSemanticIntent)`.
  `SuperMaterialThemeData` registers one automatically (derived from the active
  palette, brightness and token semantics); read it with
  `SuperSemanticColors.of(context)`. A caller-supplied instance is preserved.

#### `info` semantic color

- `SuperTokensData` gains `info` (default sky blue `#0EA5E9`, distinct from the
  royal-blue `accent`), threaded through `copyWith` / `lerp` / equality.
- `SuperPalette` gains an `info` getter. `StatusPill` gains `PillTone.info`.

#### Per-palette semantic colors

- `SuperPalette` gains optional `infoColor` / `successColor` / `warningColor` /
  `dangerColor` overrides (all default null → the GeniusLink brand semantics).
  `SuperPalette.applySemanticsTo(tokens)` folds them in; `SuperMaterialThemeData`
  applies palette semantics **only when the caller passes no explicit `tokens:`**
  (explicit tokens > palette semantics > brand default).

#### Four new palettes

- `SuperPalette.tealPalette`, `rosePalette`, `indigoPalette`, `slatePalette` —
  `SuperPalette.values` now lists **ten** palettes (order: blue, purple, green,
  golden, teal, rose, indigo, slate, gray, monochrome).

#### Color utilities & WCAG helpers — `SuperColorX`

- New `SuperColorX` extension on `Color`: `SuperColorX.fromHex` / `tryFromHex`,
  `toHex`; HSL tonal ops `lighten` / `darken` / `saturate` / `desaturate` /
  `mix` / `tone` / `tintOver`; and WCAG 2.1 helpers `contrastRatio`, `meetsAA`,
  `meetsAAA`, `onColor` (best of dark/light) and `bestForegroundFrom`.

#### Shade lookup on `SuperPalette`

- `palette.shades` (0–9 ramp), `palette.shade(int step)` (nearest of 50…900) and
  `palette[index]`.

#### Section header / footer widgets

- New `SuperSectionHeaderThemeData`, `SuperSectionFooterThemeData` and
  `SuperSectionThemeData` `ThemeExtension`s carry the configurable defaults for
  `SuperSectionHeader` / `SuperSectionFooter` / `SuperSection` (marker + chip
  dimensions, text styles, gaps, card surface / border / radius / padding,
  selected tint, expand duration + curve, etc). `SuperMaterialThemeData`
  registers a default instance of each; widgets read `X.of(context)` and fall
  back to the GeniusLink hard defaults for any null field — a widget-level
  parameter still wins over the theme value.

- New `SuperSlider` + `SuperSliderController` — a professional, reusable
  horizontal carousel for ERP (KPI strips, store tiles) and e-commerce
  (product / banner carousels). Static `children` or lazy `itemBuilder`;
  responsive items-per-view (`SuperResponsive<int>`, default 1/2/3), edge
  `peek`, `gap`, `height`/`aspectRatio`, snapping paged scroll, autoplay
  (pauses on hover/drag), `loop`, brand chevron arrows, an animated page
  indicator, RTL support, and an `onIndexChanged` callback.

- New `SuperSectionHeader` — a superset of `SectionHeader` adding an ALL-CAPS
  breadcrumb eyebrow, an inline Arabic title translation (tertiary blue), the
  marker bar, subtitle, `leading` + `trailing` slots, and two styles
  (`SuperSectionHeaderStyle.style1` marker-bar form header / `style2` tinted
  icon-chip + ALL-CAPS row header).
- New `SuperSection` — a section-card shell that optionally composes a
  `SuperSectionHeader` (via `header` or the convenience fields) and a
  `SuperSectionFooter` (via `footer` or `footerBrand`/`footerActions`) around a
  body `child` or a spaced `children` list. Supports `collapsible` (animated
  header toggle with chevron), `selected`/`onTap` (accent border + tint),
  `dividerAfterHeader`, `markerColor`, `background`, `gap`; `card: false` gives a
  borderless variant.
- New `SuperSectionFooter` + `SuperFooterLink` — the GeniusLink footer row
  (hairline rule, ALL-CAPS brand string on the leading edge, action links on the
  trailing edge; wraps on narrow widths). Both exported through the barrel and
  showcased in the example app.

### Changed

- Dark mode accent no longer reads washed-out: `toDarkColorScheme()` now derives
  `primary` / `secondary` / `tertiary` from **shade400** (was shade300 for
  primary/tertiary), restoring the vivid electric-royal-blue brand identity while
  keeping AA legibility (accent-on-surface ~5.5:1, `shade900` on-color on filled
  controls ~4.6:1). `primaryContainer` / `tertiaryContainer` deepened to shade800
  and `inversePrimary` to shade500 to match. `SuperPalette.primaryDark` → shade400.
- `StatusPill` now sources its fill/text from `SuperSemanticColors` for
  consistent, contrast-checked tinting (visually equivalent; additive tone).
- `pubspec.yaml`: version → `2.1.0`; barrel exports `super_color_utils.dart` and
  `super_semantic_colors.dart`.

### Migration from 2.0.0

Fully backward compatible — additive only.

---

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
  `SuperTokensData` provides `copyWith` + `lerp`. There are **no** static token
  constants — every consumer reads tokens dynamically from the ambient theme
  (`SuperThemeData.of(context).tokens.x`); the defaults live only as the literals
  in the `SuperTokensData` constructor (`SuperTokensData.fallback` is the default
  instance).
  - Migration: `SuperTokens.x` → `SuperThemeData.of(context).tokens.x`, dropping
    `const` on the enclosing widget; where `const` is mandatory (enum arg /
    static const / default param) use a brand-value literal. `SuperMarker.ledger`
    no longer exposes a color — use `SuperMarker.ledger.resolve(tokens)`.
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
  (fully dynamic; drop `const`, or use a brand-value literal where `const` is
  mandatory). The Super toolkit packages and their examples were migrated this way.
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
