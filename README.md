# Super Core

`super_core` is the shared Flutter design-system foundation for the GeniusLink
Super toolkit. It provides a complete Material 3 theme, responsive design
tokens, reusable layout primitives, semantic colors, formatters, and common UI
components for mobile, tablet, and desktop applications.

The package is intended to be the visual single source of truth for packages
such as `super_form_field`, `super_table_field`, `super_tree`,
`super_auto_suggestion_box`, and the rest of the Super component family.

## Features

- Complete light and dark Material 3 themes through
  `SuperMaterialThemeData`.
- Ten built-in color palettes with full light and dark `ColorScheme` support.
- Theme extensions for surfaces, typography, semantic colors, interaction
  states, section styling, and dynamic brand tokens.
- Responsive mobile, tablet, and desktop metrics.
- A 4/8/12-column responsive grid with per-breakpoint ordering and visibility.
- Reusable page, section, tile, button, app-bar, slider, snackbar, and
  overlay-toast components.
- LTR and RTL-aware layout helpers.
- Dependency-light number, currency, byte, and identifier formatters.
- Shared failures, result types, validators, and use-case abstractions.

## Theme behavior in 3.5.1

Version `3.5.1` keeps the existing GeniusLink neutral palette and makes the page/component hierarchy explicit in both light and dark modes:

- `Scaffold` and page canvas use `ColorScheme.surface` (`#EAEAEA` light / `#101010` dark).
- Cards, dialogs, sheets, menus, navigation surfaces, pickers, search views, and other container-style Material surfaces use `ColorScheme.surfaceContainer` (`#F2F2F2` light / `#181818` dark).
- Inputs retain the dedicated input fill (`#FFFFFF` light / `#242424` dark), so editable controls remain distinguishable from both the page and container surfaces.
- `SuperInteractiveStateThemeData.of(context)` now derives its fallback from the active `ColorScheme`, and `SuperThemeData.light` / `.dark` carry brightness-correct interactive-state presets.
- Explicit `scaffoldBackgroundColor`, component-theme, and `interactiveStateTheme` overrides continue to take precedence.

This preserves the established `bg -> surface -> input` relationship while keeping contrast subtle and comfortable for long sessions.

## Getting started

### Requirements

| Requirement | Minimum version |
| --- | --- |
| Dart | `3.8.0` |
| Flutter | `3.32.0` |

### Installation

Add the package to your application:

```console
flutter pub add super_core
```

For a local workspace or monorepo, use a path dependency instead:

```yaml
dependencies:
  super_core:
    path: ../super_core
```

Import the public barrel file:

```dart
import 'package:super_core/super_core.dart';
```

## Usage

### Quick start

Configure both light and dark themes at the application boundary:

```dart
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = SuperTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: SuperMaterialThemeData.light(
        palette: SuperPalette.purplePalette,
        textTheme: typography,
        primaryTextTheme: typography,
      ),
      darkTheme: SuperMaterialThemeData.dark(
        palette: SuperPalette.purplePalette,
        textTheme: typography,
        primaryTextTheme: typography,
      ),
      home: const DashboardScreen(),
    );
  }
}
```

`SuperMaterialThemeData` extends Flutter's `ThemeData`. Standard Material
widgets therefore receive the generated theme automatically, while Super
widgets can also read the registered design-system extensions.

## Reading theme values

Use the `BuildContext` extension inside widgets:

```dart
@override
Widget build(BuildContext context) {
  final theme = context.superTheme;
  final typography = context.superTextTheme;
  final colorScheme = Theme.of(context).colorScheme;
  final semanticColors = SuperSemanticColors.of(context);

  return Container(
    padding: theme.spacing.cardPadding,
    decoration: BoxDecoration(
      color: theme.surface,
      border: Border.all(color: theme.border),
      borderRadius: theme.spacing.cardBorderRadius,
    ),
    child: Text(
      'Balanced',
      style: typography.body.copyWith(
        color: semanticColors.success.onSubtle,
      ),
    ),
  );
}
```

Common theme accessors include:

| API | Purpose |
| --- | --- |
| `context.superTheme` | Super surfaces, foregrounds, spacing, sizing, tokens, and text styles |
| `Theme.of(context).colorScheme` | Material 3 color roles generated from the active palette |
| `SuperSemanticColors.of(context)` | Info, success, warning, danger, accent, and neutral roles |
| `SuperMaterialThemeData.of(context)` | The complete Super Material theme |

Read context-dependent theme values inside `build` or another method with a
valid `BuildContext`. Do not store them as global constants.

## Theme system reference

Everything under `lib/src/core/theme` is exported by
`package:super_core/super_core.dart`. The following reference documents every
public theme component and its responsibility.

| Source file | Public APIs | Responsibility |
| --- | --- | --- |
| `super_material_theme.dart` | `SuperMaterialThemeData` | Generates the complete light or dark Material 3 theme and registers all Super theme extensions. |
| `super_theme.dart` | `SuperThemeData` | Exposes resolved surfaces, foregrounds, shadows, tokens, metrics, typography, and interaction states. |
| `super_palette.dart` | `SuperPalette` | Defines the selectable 50–900 accent ramps, neutral surfaces, and Material `ColorScheme` generation. |
| `super_tokens.dart` | `SuperTokensData`, `SuperMarker` | Stores dynamic brand colors, font families, motion values, and section-marker intent. |
| `super_semantic_colors.dart` | `SuperSemanticIntent`, `SuperSemanticColor`, `SuperSemanticColors` | Expands semantic intents into solid, foreground, subtle, and border roles. |
| `super_color_utils.dart` | `SuperColorX` | Adds color parsing, conversion, tonal adjustment, mixing, and contrast helpers. |
| `super_device_mode.dart` | `SuperDeviceMode`, `SuperResponsive<T>` | Resolves mobile, tablet, and desktop theme values. |
| `super_spacing.dart` | `SuperSpacing` | Defines responsive spacing, radii, control heights, padding, margins, and constraints. |
| `super_metrics.dart` | `SuperSizing`, `SuperMetrics` | Combines spacing with responsive icon, field, hit-target, and content-column sizing. |
| `super_text_styles.dart` | `SuperTextTheme` | Provides the Material text theme plus named GeniusLink typography roles. |
| `super_interactive_state_theme.dart` | `SuperInteractiveStateThemeData` | Resolves hover, focus, pressed, selected, dragged, and disabled overlays. |
| `super_app_bar_theme.dart` | `SubtitlePosition`, `SuperAppBarTheme` | Extends Flutter's app-bar theme with subtitle placement and responsive action limits. |
| `super_card_theme.dart` | `SuperCardTheme` | Extends Flutter's card theme with section-card layout and expand/collapse defaults. |
| `super_section_theme.dart` | `SuperSectionHeaderThemeData`, `SuperSectionFooterThemeData`, `SuperSectionThemeData` | Configures section headers, footers, containers, spacing, borders, and animation. |

### `SuperMaterialThemeData`

`SuperMaterialThemeData` extends Flutter's `ThemeData`. Use its `light` and
`dark` factories as the application themes. Both factories generate the
Material `ColorScheme`, component themes, spacing, semantic colors, interaction
states, and Super theme extensions from the same palette and device mode.
Typography is explicit in v3.3.0: both factories require `SuperTextTheme` values
for `textTheme` and `primaryTextTheme`.

```dart
final typography = SuperTextTheme();

MaterialApp(
  theme: SuperMaterialThemeData.light(
    palette: SuperPalette.bluePalette,
    mode: SuperDeviceMode.mobile,
    textTheme: typography,
    primaryTextTheme: typography,
  ),
  darkTheme: SuperMaterialThemeData.dark(
    palette: SuperPalette.bluePalette,
    mode: SuperDeviceMode.mobile,
    textTheme: typography,
    primaryTextTheme: typography,
  ),
);
```

Use `SuperMaterialThemeData.of(context)` when a non-null Super theme is
required. `maybeOf(context)` returns `null` when the ambient `ThemeData` is not
a `SuperMaterialThemeData`. `fromThemeData(theme)` wraps an existing Flutter
theme with compatible Super defaults, while `copyWith(...)` preserves the
Super-specific fields when applying overrides.

### `SuperThemeData`

`SuperThemeData` is the central `ThemeExtension` used by Super components. It
contains:

- surface roles: `bg`, `surface`, `inputBg`, `hover`, `border`, and
  `borderStrong`;
- foreground roles: `fg1`, `fg2`, `fg3`, and `fg4`;
- `brightness`, `tokens`, `mode`, `metrics`, and `interactiveStates`;
- derived `spacing`, `sizing`, and `cardShadow` values;
- `cardShadowLight`, `cardShadowDark`, and `popShadow` presets;
- `selectionFill`, `tintFill`, `tint`, and `tintOnBg` color helpers.

```dart
final superTheme = SuperThemeData.of(context);
final typography = context.superTextTheme;

Container(
  padding: superTheme.spacing.cardPadding,
  decoration: BoxDecoration(
    color: superTheme.surface,
    border: Border.all(color: superTheme.border),
    borderRadius: superTheme.spacing.cardBorderRadius,
    boxShadow: superTheme.cardShadow,
  ),
  child: Text(
    'Account details',
    style: typography.body.copyWith(color: superTheme.fg1),
  ),
);
```

`SuperThemeData.light` and `SuperThemeData.dark` are fallback presets. Normal
applications should install `SuperMaterialThemeData` so the extension is
resolved from the selected palette and responsive mode.

### `SuperPalette`

`SuperPalette` represents one selectable accent palette. Each palette includes
shades `50` through `900`, optional semantic overrides, shared neutral surface
roles for light and dark themes, and `toLightColorScheme()` /
`toDarkColorScheme()` generators.

Useful members include `primary`, `primaryDark`, `onPrimary`, `shades`,
`shade(step)`, indexed shade access, `applyTo(tokens)`, and
`applySemanticsTo(tokens)`.

The built-in values are:

```dart
SuperPalette.bluePalette;
SuperPalette.purplePalette;
SuperPalette.greenPalette;
SuperPalette.goldenPalette;
SuperPalette.tealPalette;
SuperPalette.rosePalette;
SuperPalette.indigoPalette;
SuperPalette.slatePalette;
SuperPalette.grayPalette;
SuperPalette.monochromePalette;
```

Use `SuperPalette.values` when presenting all built-in choices.

### `SuperTokensData` and `SuperMarker`

`SuperTokensData` stores dynamic brand-level tokens that are not part of the
responsive spacing scale:

- accent colors: `accent`, `accentHover`, and `accentPressed`;
- semantic solids: `info`, `success`, `warning`, and `danger`;
- font families: `displayFont`, `bodyFont`, `monoFont`, and `arabicFont`;
- marker geometry: `markerWidth` and `markerHeight`;
- motion: `durFast`, `durBase`, `durExpand`, `curveStandard`, and `curveOut`.

```dart
final customTokens = SuperTokensData.fallback.copyWith(
  accent: const Color(0xFF5B3FD6),
  bodyFont: 'Inter',
  arabicFont: 'NotoNaskhArabic',
  durExpand: const Duration(milliseconds: 220),
);

final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.light(
  tokens: customTokens,
  textTheme: typography,
  primaryTextTheme: typography,
);
```

`SuperMarker` expresses section intent through `identity`, `ledger`, and
`notes`. Resolve the active marker color with `marker.resolve(tokens)` or
`tokens.markerColor(marker)`.

### `SuperSemanticColors`

`SuperSemanticColors` is a brightness-aware `ThemeExtension` containing six
intents: `info`, `success`, `warning`, `danger`, `accent`, and `neutral`.
Each intent is a `SuperSemanticColor` with five roles:

| Role | Use |
| --- | --- |
| `solid` | Icons, emphasis text, active borders, and filled surfaces |
| `onSolid` | Foreground drawn over `solid` |
| `subtle` | Low-emphasis status surface |
| `onSubtle` | Foreground drawn over `subtle` |
| `border` | Border for a subtle semantic container |

```dart
final semantics = SuperSemanticColors.of(context);
final status = semantics.byIntent(SuperSemanticIntent.warning);

Container(
  color: status.subtle,
  child: Text(
    'Pending review',
    style: TextStyle(color: status.onSubtle),
  ),
);
```

Use `SuperSemanticColor.fromBase(...)` to derive a complete role set from one
base color and `SuperSemanticColors.fromSuperTheme(...)` to derive all intents
from a `SuperThemeData` instance.

### `SuperColorX`

`SuperColorX` extends Flutter's `Color` with design-system utilities:

```dart
final accent = SuperColorX.fromHex('#4A7CFF');
final parsed = SuperColorX.tryFromHex('4A7CFF');
final hex = accent.toHex();
final lighter = accent.lighten(0.10);
final darker = accent.darken(0.10);
final muted = accent.desaturate(0.20);
final mixed = accent.mix(Colors.white, 0.25);
final readable = accent.onColor();
final passesAA = accent.meetsAA(readable);
```

The extension also provides `saturate`, `tone`, `tintOver`, `contrastRatio`,
`meetsAAA`, and `bestForegroundFrom`.

### `SuperDeviceMode` and `SuperResponsive<T>`

`SuperDeviceMode` defines three form factors using logical-width breakpoints:

| Mode | Minimum width |
| --- | ---: |
| `mobile` | `0` |
| `tablet` | `600` |
| `desktop` | `1024` |

Use `SuperDeviceMode.forWidth(width)` or `SuperDeviceMode.of(context)` to
resolve a mode. The `isMobile`, `isTablet`, and `isDesktop` getters are
available for mode-specific behavior.

`SuperResponsive<T>` stores one value for each mode. It supports
`resolve(mode)`, `map(...)`, and `SuperResponsive.all(value)`.

```dart
const horizontalPadding = SuperResponsive<double>(
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

final padding = horizontalPadding.resolve(SuperDeviceMode.of(context));
```

### `SuperSpacing`

`SuperSpacing` is the responsive spacing and geometry bundle. It includes:

- spacing tokens: `space1`, `space2`, `space3`, `space4`, `space5`, `space6`,
  `space8`, `space10`, and `space12`;
- radii: `radiusControl`, `radiusMd`, `radiusCard`, and `radiusPill`;
- `controlHeight`;
- `cardPadding`, `controlPadding`, `fieldPadding`, and `pagePadding`;
- `cardMargin`, `sectionMargin`, and `pageMargin`;
- derived padding, `BorderRadius`, `Size`, and `BoxConstraints` helpers.

```dart
final spacing = context.superTheme.spacing;

Padding(
  padding: spacing.pagePadding,
  child: SizedBox(
    height: spacing.controlHeight,
    child: const Text('Responsive control'),
  ),
);
```

Use `SuperSpacing.mobile`, `.tablet`, `.desktop`, or
`SuperSpacing.of(mode)`. `SuperSpacing.responsive` keeps all three presets in a
single `SuperResponsive<SuperSpacing>` value.

### `SuperSizing` and `SuperMetrics`

`SuperSizing` contains control-adjacent values that are separate from spacing:
`iconButton`, `icon`, `fieldComfortable`, `fieldCompact`, and `contentColumn`.
Mobile uses larger touch targets, while desktop uses denser pointer-oriented
controls.

`SuperMetrics` combines the active `SuperSpacing` and `SuperSizing` for one
`SuperDeviceMode`.

```dart
final metrics = SuperMetrics.of(SuperDeviceMode.of(context));

IconButton(
  constraints: BoxConstraints.tightFor(
    width: metrics.sizing.iconButton,
    height: metrics.sizing.iconButton,
  ),
  iconSize: metrics.sizing.icon,
  onPressed: () {},
  icon: const Icon(Icons.refresh),
);
```

The const presets are `SuperMetrics.mobile`, `.tablet`, and `.desktop`.
`SuperMetrics.sizingResponsive` exposes the three sizing configurations.

### `SuperTextTheme`

`SuperTextTheme` extends Flutter's `TextTheme`, populates all Material text
slots, and adds named styles:

- `displayLg`, `headlineSm`, and `titleMd`;
- `bodyLg` and `bodySm`;
- `labelMd` and `labelSm`;
- `mono` and `eyebrow`;
- aliases: `h1`, `heading`, `body`, `label`, `caption`, `button`, and `pill`.

```dart
final textTheme = context.superTextTheme;

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Account statement', style: textTheme.titleMd),
    Text('10001', style: textTheme.mono),
  ],
);
```

`SuperTextTheme(...)` builds a responsive type ramp from default
Google Fonts faces, or from optional `bodyFont` and `otherFont` `TextStyle`
seeds. Use `isDesktop` for tighter desktop metrics and `isArabic` to switch
both body and display faces to `NotoNaskhArabic`.

```dart
final textTheme = SuperTextTheme(
  bodyFont: const TextStyle(fontFamily: 'Inter'),
  otherFont: const TextStyle(fontFamily: 'Manrope'),
  isDesktop: SuperDeviceMode.of(context).isDesktop,
);
```

Use `colorize(fg1, fg3)` for a pre-colored copy and `superCopyWith(...)` to
replace Super-specific styles while retaining the full Material text theme.

### `SuperInteractiveStateThemeData`

`SuperInteractiveStateThemeData` defines the overlay treatment for
`WidgetState.hovered`, `focused`, `pressed`, `selected`, `dragged`, and
`disabled`. It also carries the active `accent` and `hoverSurface` colors.

```dart
final states = SuperInteractiveStateThemeData.of(context);

InkWell(
  overlayColor: states.overlayColor(),
  onTap: () {},
  child: const Text('Open'),
);
```

Use `opacity(state)` when manually resolving one state and
`fromColorScheme(colorScheme)` to derive the theme from Material colors. The
`light` and `dark` constants are brightness-specific presets; `standard` remains
a backwards-compatible alias of the dark preset. `of(context)` is preferred in
widgets because its fallback follows the ambient `ColorScheme` brightness.

### `SuperAppBarTheme`

`SuperAppBarTheme` extends Flutter's `AppBarThemeData`, so it can be passed
directly to `ThemeData.appBarTheme`. In addition to standard app-bar fields, it
adds:

- `subtitlePosition` and `subtitleTextStyle`;
- `maxActions` as a global override;
- `maxMobileActions`, `maxTabletActions`, and `maxDesktopActions`.

The default responsive action limits are 3 on mobile, 4 on tablet, and 5 on
desktop. Use `maxActionsFor(mode)` to resolve the active limit.

```dart
final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.light(
  textTheme: typography,
  primaryTextTheme: typography,
  appBarTheme: const SuperAppBarTheme(
    subtitlePosition: SubtitlePosition.below,
    maxMobileActions: 2,
    maxTabletActions: 4,
    maxDesktopActions: 5,
  ),
);
```

Use `SuperAppBarTheme.of(context)` to read it,
`fromAppBarTheme(...)` to wrap a regular Flutter app-bar theme,
`copyWithSuper(...)` to replace fields, and `mergeWith(...)` to merge another
Super app-bar theme.

### `SuperCardTheme`

`SuperCardTheme` extends Flutter's `CardThemeData` and adds defaults consumed by
`SuperSectionCard`:

- `expandDirection`, `expandDuration`, and `expandCurve`;
- `toggleOnTap` and `showExpandIcon`;
- interior `padding` and content `gap`;
- `borderColor` and `selectedBorderColor`.

```dart
final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.light(
  textTheme: typography,
  primaryTextTheme: typography,
  cardTheme: const SuperCardTheme(
    toggleOnTap: true,
    showExpandIcon: true,
    expandDuration: Duration(milliseconds: 200),
  ),
);
```

Use `SuperCardTheme.of(context)` to read it,
`SuperCardTheme.fromCardTheme(...)` to preserve a standard Flutter card theme,
and `copyWith(...)` to override either stock or Super-specific fields.

### Section theme data

`super_section_theme.dart` provides three independent theme extensions:

- `SuperSectionHeaderThemeData` controls the default marker, marker geometry,
  style-2 rail geometry, icon-chip geometry, text styles, internal gap, and
  trailing-icon size.
- `SuperSectionFooterThemeData` controls the divider, brand and link styles,
  emphasized color, letter spacing, vertical padding, spacing, and run spacing.
- `SuperSectionThemeData` controls the section-card shell: card mode,
  background, normal and selected borders, selection tint, radius, padding,
  content/header/footer gaps, header divider, and expand animation.

```dart
final extensions = <ThemeExtension<dynamic>>[
  const SuperSectionHeaderThemeData(
    defaultMarker: SuperMarker.identity,
    markerWidth: 4,
  ),
  const SuperSectionFooterThemeData(
    showDivider: true,
  ),
  const SuperSectionThemeData(
    card: true,
    dividerAfterHeader: true,
  ),
];

final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.light(
  textTheme: typography,
  primaryTextTheme: typography,
  extensions: extensions,
);
```

Each class provides an `of(context)` accessor, `copyWith(...)`, and `lerp(...)`
for smooth theme transitions.

## Color palettes

The package includes the following palettes:

```dart
SuperPalette.bluePalette;
SuperPalette.purplePalette;
SuperPalette.greenPalette;
SuperPalette.goldenPalette;
SuperPalette.tealPalette;
SuperPalette.rosePalette;
SuperPalette.indigoPalette;
SuperPalette.slatePalette;
SuperPalette.grayPalette;
SuperPalette.monochromePalette;
```

Use `SuperPalette.values` when building a palette selector.

### Runtime palette switching

Keep the selected palette in application state and rebuild `MaterialApp` when
it changes:

```dart
class ThemedApp extends StatefulWidget {
  const ThemedApp({super.key});

  @override
  State<ThemedApp> createState() => _ThemedAppState();
}

class _ThemedAppState extends State<ThemedApp> {
  SuperPalette _palette = SuperPalette.bluePalette;
  final SuperTextTheme _typography = SuperTextTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SuperMaterialThemeData.light(
        palette: _palette,
        textTheme: _typography,
        primaryTextTheme: _typography,
      ),
      darkTheme: SuperMaterialThemeData.dark(
        palette: _palette,
        textTheme: _typography,
        primaryTextTheme: _typography,
      ),
      home: PaletteSettingsScreen(
        palettes: SuperPalette.values,
        selectedPalette: _palette,
        onChanged: (palette) {
          setState(() => _palette = palette);
        },
      ),
    );
  }
}
```

## Responsive themes

`SuperDeviceMode` controls typography, control dimensions, spacing, and other
responsive metrics used by the generated theme.

```dart
class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mode = SuperDeviceMode.forWidth(constraints.maxWidth);
        final typography = SuperTextTheme(
          isDesktop: mode == SuperDeviceMode.desktop,
        );

        return MaterialApp(
          theme: SuperMaterialThemeData.light(
            palette: SuperPalette.bluePalette,
            mode: mode,
            textTheme: typography,
            primaryTextTheme: typography,
          ),
          darkTheme: SuperMaterialThemeData.dark(
            palette: SuperPalette.bluePalette,
            mode: mode,
            textTheme: typography,
            primaryTextTheme: typography,
          ),
          home: const DashboardScreen(),
        );
      },
    );
  }
}
```

The default mode is `SuperDeviceMode.mobile`. Rebuild the application theme when
the active device mode changes, especially for resizable desktop and web
windows. Because typography is now injected explicitly, rebuild the matching
`SuperTextTheme` as well when switching between desktop and non-desktop ramps.

For a value that varies by device mode, use `SuperResponsive<T>`:

```dart
const panelWidth = SuperResponsive<double>(
  mobile: 280,
  tablet: 360,
  desktop: 440,
);

final width = panelWidth.resolve(SuperDeviceMode.of(context));
```

## Responsive layout

### Page frame

`SuperScaffold` complements Flutter's `Scaffold`. It adds responsive page
margins and can constrain the content width.

```dart
Scaffold(
  appBar: const SuperAppBar(
    title: Text('Accounts'),
    subtitle: Text('Chart of accounts'),
  ),
  body: SuperScaffold(
    maxWidth: 1200,
    child: const AccountsContent(),
  ),
);
```

### Grid

`SuperGrid` uses four columns on mobile, eight on tablet, and twelve on desktop
and large screens.

```dart
SuperGrid(
  scope: SuperGridScope.current,
  children: const [
    SuperGridCell(
      mobile: 4,
      tablet: 4,
      desktop: 3,
      child: BalanceCard(),
    ),
    SuperGridCell(
      mobile: 4,
      tablet: 4,
      desktop: 9,
      child: AccountDetailsPanel(),
    ),
  ],
);
```

Set a span to `0` to hide a cell at that breakpoint. Use the `mobileOrder`,
`tabletOrder`, `desktopOrder`, and `largeOrder` properties to change visual
order without duplicating widgets.

### Local breakpoints

Use `SuperBreakpointProvider` for previews, dialogs, drawers, and nested panes
that need a breakpoint independent from the full window width:

```dart
SuperBreakpointProvider(
  breakpoint: SuperBreakpoint.tablet,
  child: const SuperGrid(
    scope: SuperGridScope.provider,
    children: [
      SuperGridCell(
        mobile: 4,
        tablet: 8,
        child: PreviewPanel(),
      ),
    ],
  ),
);
```

## Section surfaces

Use `SuperSectionCard` as the default section container. It supports a title,
subtitle, marker, icon, one child or a list of children, footer actions,
selection, tapping, and expand/collapse behavior.

```dart
SuperSectionCard(
  title: 'Opening balance',
  subtitle: 'Balances carried into the current period',
  marker: SuperMarker.ledger,
  icon: Icons.account_balance_wallet_outlined,
  collapsible: true,
  footerBrand: 'GeniusLink ERP',
  footerActions: [
    SuperFooterLink('Details', onTap: showDetails),
    SuperFooterLink(
      'Post',
      emphasized: true,
      onTap: postBalance,
    ),
  ],
  child: const OpeningBalanceForm(),
);
```

### Marker visibility (v3.4.0)

All three section-card variants expose `showMarker`, which defaults to `true`.
Set it to `false` when the colored vertical marker/rail should be omitted while
keeping the rest of the header intact: title, subtitle, icon/leading content,
trailing content, and collapse/expand controls remain visible.

```dart
SuperSectionCard(
  title: 'Opening balance',
  subtitle: 'Balances carried into the current period',
  showMarker: false,
  child: const OpeningBalanceForm(),
);

SuperSectionCard1(
  title: 'Compact section',
  showMarker: false,
  child: const DetailsPanel(),
);

SuperSectionCard2(
  title: 'Ledger balance',
  showMarker: false,
  child: const BalanceSummary(),
);
```

The standalone `SuperSectionHeader`, `SuperSectionTitle1`, and
`SuperSectionTitle2` helpers expose the same option.

The marker height is adaptive: it stretches to the actual rendered header content height instead of using a fixed rail height.

Use the specialized variants only when their visual treatment is required:

| Widget | Recommended use |
| --- | --- |
| `SuperSectionCard` | Default application section and expandable card |
| `SuperSectionCard1` | Compact section with a leading accent bar |
| `SuperSectionCard2` | Compact rail-and-icon section treatment |
| `AccentSectionCard` | Simple accent-oriented content surface |
| `SuperSectionHeader` | Standalone section header |
| `SuperSectionFooter` | Standalone section footer with action links |

## Common widgets

### Buttons and status

```dart
Wrap(
  spacing: context.superTheme.spacing.space2,
  children: [
    SuperButton(
      label: 'Save',
      icon: const Icon(Icons.save_outlined),
      onPressed: save,
    ),
    SuperButton(
      label: 'Cancel',
      variant: SuperButtonVariant.secondary,
      onPressed: cancel,
    ),
    const StatusPill(
      'Active',
      tone: PillTone.success,
    ),
  ],
);
```

### Reusable confirmation and field surfaces

Use the View components when the content belongs inline, in a card, or in a
sheet. Use the matching Dialog wrapper for modal presentation; the Dialog does
not duplicate the View implementation. When actions are present, the shared
layout renders them in a distinct design-system footer surface using the active
Super theme, so no feature-specific footer colors are needed.

```dart
SuperConfirmView(
  title: 'Post journal entry',
  description: 'Review the entry before posting it.',
  content: const EntrySummary(),
  confirmLabel: 'Post',
  cancelLabel: 'Cancel',
  onConfirm: postEntry,
  onCancel: closePreview,
);

final confirmed = await SuperConfirmDialog.show(
  context,
  title: 'Delete store',
  description: 'This action cannot be undone.',
  confirmLabel: 'Delete',
  isDestructive: true,
);

SuperFieldView(
  title: 'Account information',
  description: 'Enter the account details.',
  actions: [
    SuperButton(label: 'Save', onPressed: saveAccount),
  ],
  child: const AccountFields(),
);
```

### List and grid tiles

```dart
SuperListTile(
  marker: SuperMarker.ledger,
  leadingIcon: Icons.account_balance_outlined,
  titleText: 'Cash account',
  subtitle: const Text('10001'),
  badge: const StatusPill('Active', tone: PillTone.success),
  trailingActions: [
    SuperIconButton(
      icon: Icons.edit_outlined,
      tooltip: 'Edit account',
      onPressed: editAccount,
    ),
  ],
  selected: isSelected,
  onTap: openAccount,
);
```

```dart
SuperGridTile(
  marker: SuperMarker.identity,
  header: const Text('Total accounts'),
  badge: const StatusPill('Live', tone: PillTone.info),
  footer: const Text('Updated now'),
  onTap: openAccounts,
  child: const Text('248'),
);
```

### Toasts

`SuperToast` is the host-based transient notification system. It follows `super_core` colors, spacing, typography, sizing, elevation and motion tokens while supporting advanced stacked-toast behavior.

Install one host near the root of the app, preferably in `MaterialApp.builder`:

```dart
MaterialApp(
  builder: (context, child) => SuperToastHost(
    child: child ?? const SizedBox.shrink(),
  ),
  home: const HomeScreen(),
);
```

Show a standard toast from any descendant context:

```dart
SuperToast.success(
  context,
  title: 'Saved',
  description: 'Your changes were saved.',
);
```

The default alignment is adaptive: touch layouts use `topCenter`, while desktop layouts use `bottomEnd`. You can use physical or direction-aware positions:

```dart
SuperToast.info(
  context,
  title: 'Synced',
  position: SuperToastPosition.bottomEnd,
);
```

Stacks collapse into a deck and, by default, expand on pointer hover or touch press. Configure this on the host:

```dart
SuperToastHost(
  style: const SuperToastHostStyle(
    maxVisible: 3,
    expandBehavior: SuperToastExpandBehavior.hoverOrPress,
  ),
  child: child,
);
```

Swipe-to-dismiss is enabled by default in the outward direction for the resolved alignment. Corner positions support both outward axes; centered positions use the vertical axis. Override or disable it per toast:

```dart
SuperToast.show(
  context,
  title: 'Custom swipe',
  swipeToDismiss: const [AxisDirection.left],
  dismissThreshold: 0.35,
);

SuperToast.show(
  context,
  title: 'Swipe disabled',
  swipeToDismiss: const [],
);
```

A `null` duration disables auto-dismiss. `Duration.zero` remains supported as a persistent-toast compatibility value. Hover/press/swipe interaction pauses auto-dismiss, and accessible navigation disables auto-dismiss automatically.

```dart
final handle = SuperToast.warning(
  context,
  title: 'Needs attention',
  duration: null,
  showCloseButton: true,
);

handle.pause();
handle.resume();
handle.dismiss();
```

Use `suffixBuilder` when trailing content needs access to its own handle, or `showRaw` when the whole surface is custom:

```dart
SuperToast.show(
  context,
  title: 'Event created',
  suffixBuilder: (context, entry) => TextButton(
    onPressed: entry.dismiss,
    child: const Text('Undo'),
  ),
);

SuperToast.showRaw(
  context,
  data: const SuperToastData(
    title: 'Custom',
    duration: null,
  ),
  builder: (context, entry) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SelectableText('Any widget can be shown here.'),
    ),
  ),
);
```

Other supported capabilities include semantic tones (`neutral`, `info`, `success`, `warning`, `danger`), RTL-aware start/end placement, custom alignments, custom per-toast style/motion, collapsed-deck geometry, `always`/`hoverOrPress`/`disabled` expansion, raw content, actions, close/tap dismissal, isolated controllers, live theme updates, semantic live regions and reduced-motion behavior.

`SuperSnackBar` remains the `ScaffoldMessenger`-based API. Use `SuperToast` when you need independent overlay-style stacking, placement, gestures and host-level toast behavior.

### Snackbars

```dart
SuperSnackBar.success(
  context,
  'The account was created successfully.',
);

SuperSnackBar.danger(
  context,
  'The account could not be saved.',
);
```

## Forms

`FieldShell` provides shared label, required, hint, error, density, and disabled
presentation around a custom control. It does not manage the input value or
validation state.

```dart
FieldShell(
  label: 'Account name',
  required: true,
  hint: 'Enter a unique account name.',
  error: validationError,
  child: TextField(
    controller: controller,
  ),
);
```

For complete form controls, use the dedicated `super_form_field` package.

## Typography

`SuperTextTheme` extends Flutter's `TextTheme` with the GeniusLink named styles.
As of v3.3.0, typography belongs to `SuperMaterialThemeData`, not
`SuperThemeData`. Read the active branded ramp with `context.superTextTheme` or
`SuperMaterialThemeData.of(context).textTheme`.

```dart
Text(
  'Account summary',
  style: context.superTextTheme.titleMd,
);
```

Both `SuperMaterialThemeData.light` and `.dark` require `textTheme` and
`primaryTextTheme`, and both parameters must be `SuperTextTheme`. The material
theme applies the appropriate foreground colors while preserving the supplied
type ramp. The old nullable `TextTheme` overrides and `mergeTextTheme` behavior
are removed. `SuperMaterialThemeData` also no longer infers token font metadata
from `SuperTextTheme`; configure the ramp with `bodyFont` / `otherFont`, and
pass `fontFamily` only when a token-level family override is intentionally
required.

```dart
final typography = SuperTextTheme(
  bodyFont: const TextStyle(fontFamily: 'Inter'),
  otherFont: const TextStyle(fontFamily: 'Manrope'),
);

final theme = SuperMaterialThemeData.light(
  textTheme: typography,
  primaryTextTheme: typography,
);
```

Arabic typography can be supplied directly:

```dart
final arabicTypography = SuperTextTheme(isArabic: true);

final theme = SuperMaterialThemeData.light(
  textTheme: arabicTypography,
  primaryTextTheme: arabicTypography,
);
```

For desktop density, construct the typography with
`isDesktop: mode == SuperDeviceMode.desktop`. Register local font assets in the
consuming application's `pubspec.yaml` when the font is bundled with the
application.

## Theme customization

The light and dark factories accept standard Flutter component-theme overrides.
Explicit values take precedence over generated palette values.

```dart
final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.light(
  palette: SuperPalette.purplePalette,
  textTheme: typography,
  primaryTextTheme: typography,
  appBarTheme: const SuperAppBarTheme(
    subtitlePosition: SubtitlePosition.below,
    maxMobileActions: 1,
    maxTabletActions: 3,
    maxDesktopActions: 5,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 2,
  ),
);
```

Dynamic brand and semantic values can be replaced with `SuperTokensData`:

```dart
final tokens = SuperTokensData.fallback.copyWith(
  accent: const Color(0xFF5B3FD6),
  accentHover: const Color(0xFF6C52DE),
  accentPressed: const Color(0xFF4930BE),
);

final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.light(
  palette: SuperPalette.purplePalette,
  tokens: tokens,
  textTheme: typography,
  primaryTextTheme: typography,
);
```

When supplying custom tokens, keep the accent tokens and the Material
`ColorScheme` intentionally aligned.

## RTL support

Super components use directional padding and Flutter's ambient
`Directionality`. Configure localization and supported locales in the
application as usual.

```dart
final typography = SuperTextTheme(isArabic: true);

MaterialApp(
  locale: const Locale('ar'),
  supportedLocales: const [
    Locale('ar'),
    Locale('en'),
  ],
  theme: SuperMaterialThemeData.light(
    textTheme: typography,
    primaryTextTheme: typography,
  ),
  darkTheme: SuperMaterialThemeData.dark(
    textTheme: typography,
    primaryTextTheme: typography,
  ),
  home: const DashboardScreen(),
);
```

Direction helpers are available on `BuildContext`:

```dart
final isRtl = context.isRtl;
final direction = context.direction;
```

## Formatting utilities

`SuperFormat` provides common formatters without an `intl` dependency:

```dart
final quantity = SuperFormat.number(12500, decimals: 0); // 12,500
final amount = SuperFormat.currency(
  12500.5,
  symbol: 'ر.ي ',
); // ر.ي 12,500.50
final size = SuperFormat.bytes(1048576); // 1.0 MB
final id = SuperFormat.truncateHash('1234567890abcdef');
```

For locale-aware dates, pluralization, and localized number formatting, use
Flutter localization APIs or the `intl` package in the consuming application.

## Public API overview

| Area | Main APIs |
| --- | --- |
| Material theme | `SuperMaterialThemeData`, `SuperThemeData`, `SuperTextTheme` |
| Palettes and colors | `SuperPalette`, `SuperSemanticIntent`, `SuperSemanticColor`, `SuperSemanticColors`, `SuperColorX` |
| Tokens and metrics | `SuperTokensData`, `SuperMarker`, `SuperSpacing`, `SuperSizing`, `SuperMetrics` |
| Component theme data | `SuperAppBarTheme`, `SuperCardTheme`, `SuperSectionHeaderThemeData`, `SuperSectionFooterThemeData`, `SuperSectionThemeData`, `SuperInteractiveStateThemeData` |
| Responsive behavior | `SuperDeviceMode`, `SuperResponsive`, `SuperBreakpoint`, `SuperBreakpoints` |
| Layout | `SuperScaffold`, `SuperGrid`, `SuperGridCell`, `SuperBreakpointProvider` |
| Sections | `SuperSectionCard`, `SuperSectionCard1`, `SuperSectionCard2`, `SuperSectionHeader`, `SuperSectionFooter` |
| Navigation surfaces | `SuperAppBar`, `SuperSliverAppBar` |
| Tiles and controls | `SuperListTile`, `SuperGridTile`, `SuperButton`, `SuperIconButton`, `SuperSlider`, `StatusPill` |
| Forms and confirmation | `SuperConfirmView`, `SuperConfirmDialog`, `SuperFieldView`, `SuperFieldDialog` |
| Feedback | `SuperToast`, `SuperSnackBar`, `Hairline`, `FieldShell` |
| Foundation | failures, typedefs, validators, use cases, and key-direction utilities |

## Example

The `example/` application demonstrates:

- light, dark, and system theme modes;
- runtime palette switching;
- Material and Super components;
- responsive layout and grid behavior;
- section-card variants;
- overlay `SuperToast` feedback and lifecycle examples;
- a responsive `HomeScreen` catalog for all example screens;
- Arabic and RTL examples.

Run it from the package root:

```console
cd example
flutter pub get
flutter run
```

## Development

Before submitting changes, run:

```console
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Keep public APIs documented with Dart documentation comments, expose supported
symbols through `lib/super_core.dart`, and add or update tests for behavior
changes.

## Additional information

- Repository: <https://github.com/GeniusSystems24/super_core>
- Issue tracker: <https://github.com/GeniusSystems24/super_core/issues>
- Homepage: <https://geniussystems24.github.io/super_core>

Use the issue tracker for reproducible bugs and focused feature requests.
Include the Flutter version, target platform, a minimal example, and relevant
logs when reporting a problem.

## License

See [LICENSE](LICENSE).
