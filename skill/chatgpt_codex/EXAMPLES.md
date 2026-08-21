# super_core · Examples (v3.4.0)

Runnable, copy-pasteable snippets. All assume `import
'package:super_core/super_core.dart';`.

---

## Marker visibility (v3.4.0)

Use `showMarker: false` to remove only the colored marker/rail while preserving
the rest of the header.

The marker automatically matches the rendered header content height, so title-only,
title + subtitle, and taller header compositions do not need a manual rail height.

```dart
SuperSectionCard(
  title: 'Customer balance',
  subtitle: 'Current posting period',
  showMarker: false,
  icon: Icons.account_balance_wallet_outlined,
  collapsible: true,
  child: const BalanceSummary(),
);
```

## 1 · Minimal app with light + dark + system mode

```dart
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: SuperMaterialThemeData.light(
          palette: SuperPalette.bluePalette,
          textTheme: SuperTextTheme(),
          primaryTextTheme: SuperTextTheme(),
        ),
        darkTheme: SuperMaterialThemeData.dark(
          palette: SuperPalette.bluePalette,
          textTheme: SuperTextTheme(),
          primaryTextTheme: SuperTextTheme(),
        ),
        themeMode: ThemeMode.system,
        home: const Scaffold(body: Center(child: Text('Hello'))),
      );
}
```

## 2 · Runtime palette switching

```dart
class _AppState extends State<App> {
  SuperPalette _palette = SuperPalette.bluePalette;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: SuperMaterialThemeData.light(
          palette: _palette,
          textTheme: SuperTextTheme(),
          primaryTextTheme: SuperTextTheme(),
        ),
        darkTheme: SuperMaterialThemeData.dark(
          palette: _palette,
          textTheme: SuperTextTheme(),
          primaryTextTheme: SuperTextTheme(),
        ),
        home: Home(onPick: (p) => setState(() => _palette = p)),
      );
}

// A picker:
Wrap(
  children: [
    for (final p in SuperPalette.values)
      ChoiceChip(
        label: Text(p.name),
        selected: p == _palette,
        onSelected: (_) => widget.onPick(p),
      ),
  ],
);
```

## 3 · Responsive theme driven by width

```dart
class ResponsiveThemedApp extends StatelessWidget {
  const ResponsiveThemedApp({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final mode = SuperDeviceMode.forWidth(constraints.maxWidth);
          return MaterialApp(
            theme: SuperMaterialThemeData.light(
              mode: mode,
              textTheme: SuperTextTheme(
                isDesktop: mode == SuperDeviceMode.desktop,
              ),
              primaryTextTheme: SuperTextTheme(
                isDesktop: mode == SuperDeviceMode.desktop,
              ),
            ),
            darkTheme: SuperMaterialThemeData.dark(
              mode: mode,
              textTheme: SuperTextTheme(
                isDesktop: mode == SuperDeviceMode.desktop,
              ),
              primaryTextTheme: SuperTextTheme(
                isDesktop: mode == SuperDeviceMode.desktop,
              ),
            ),
            home: const Dashboard(),
          );
        },
      );
}
```

## 4 · Reading Super tokens in a widget

```dart
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final s = SuperThemeData.of(context); // surfaces + responsive metrics
    return Container(
      padding: s.padding.card,
      decoration: BoxDecoration(
        color: s.surface,
        border: Border.all(color: s.border),
        borderRadius: BorderRadius.circular(s.tokens.radiusCard),
        boxShadow: s.cardShadow,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: s.fg1),
        child: child,
      ),
    );
  }
}
```

## 5 · Overriding one component theme, keeping the rest

```dart
SuperMaterialThemeData.light(
  palette: SuperPalette.goldenPalette,
  mode: SuperDeviceMode.desktop,
  textTheme: SuperTextTheme(isDesktop: true),
  primaryTextTheme: SuperTextTheme(isDesktop: true),
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  cardTheme: const CardThemeData(elevation: 3),
);
```

## 6 · Merging your own extension via copyWith

```dart
final typography = SuperTextTheme();
final theme = SuperMaterialThemeData.dark(
  textTheme: typography,
  primaryTextTheme: typography,
).copyWith(
  extensions: const [MyFeatureThemeData.dark], // merged with SuperThemeData
);
assert(theme is SuperMaterialThemeData);                 // type preserved
assert(theme.extension<SuperThemeData>() != null);       // Super ext preserved
assert(theme.extension<MyFeatureThemeData>() != null);   // caller ext preserved
```

## 7 · maybeOf vs of

```dart
// Guarded branch:
final maybe = SuperMaterialThemeData.maybeOf(context);
if (maybe != null) {
  // definitely running under a Super theme
}

// Always-valid tokens (wraps a plain ThemeData, preserving its config):
final t = SuperMaterialThemeData.of(context);
final accent = t.colorScheme.primary;
final gap = t.superTheme.spacing.lg;
```

## 8 · Component package bridges

```dart
// Explicit derivation (rarely needed — each widget's own of() does this):
final tab  = SuperTabBarThemeData.fromMaterialTheme(SuperMaterialThemeData.of(context));
final box  = AutoSuggestionsBoxThemeData.fromMaterialTheme(SuperMaterialThemeData.of(context));
final side = NavigationSidebarThemeData.fromMaterialTheme(SuperMaterialThemeData.of(context));

// Extension-less packages just read SuperThemeData:
final s = SuperThemeData.of(context);
```

## 9 · Authoring a responsive value

```dart
const railWidth = SuperResponsive<double>(mobile: 0, tablet: 72, desktop: 240);

@override
Widget build(BuildContext context) {
  final w = railWidth.resolve(SuperDeviceMode.of(context));
  return SizedBox(width: w, child: const NavRail());
}
```

## 10 · Manual (legacy) SuperThemeData wiring

```dart
MaterialApp(
  theme:     ThemeData(extensions: const [SuperThemeData.light]),
  darkTheme: ThemeData(extensions: const [SuperThemeData.dark]),
);
final s = SuperThemeData.of(context); // falls back to .dark when unregistered
```

## 11 · Design-system widgets (v3.1.0)

```dart
// SuperSectionCard — surfaceContainerLow, shadow-only; interactive + selectable:
SuperSectionCard(
  header: const SuperSectionHeader(title: 'Downtown Central Store'),
  child: const Text('Shadow-only card — border appears on hover/selected.'),
);
SuperSectionCard(
  color: context.superTheme.surface, // explicit background override
  selected: id == _selected,
  onTap: () => setState(() => _selected = id),
  child: const Text('Selectable row'),
);

// Expandable SuperSectionCard:
SuperSectionCard(
  header: const SuperSectionHeader(title: 'Downtown Central Store'),
  expandedChild: const Text('Balance SAR 48,200.00 across 3 sub-accounts.'),
  // expandDirection: Axis.horizontal, initiallyExpanded, isExpanded, onExpansionChanged…
  child: const Text('Tap the card or chevron to reveal details.'),
);

// AccentSectionCard (new in v2.4.0) — 3px bar + tinted header:
AccentSectionCard(
  title: 'Bank Account',
  icon: const Icon(Icons.account_balance_outlined),
  accentColor: Colors.indigo,
  child: const AccountForm(),
);

// SuperSectionCard (consolidated in v3.0.0):
SuperSectionCard(
  title: 'Account Details',
  subtitle: 'BASIC INFO',
  accentColor: Colors.blue,
  collapsible: true,
  child: const AccountDetailsForm(),
);

// SuperSectionCard1 (new in v3.1.0) - compact accent-title treatment:
SuperSectionCard1(
  title: 'Basic Accent Section',
  subtitle: 'Tap to collapse',
  icon: Icons.article_outlined,
  collapsible: true,
  footerBrand: 'SuperCore themed surface',
  footerActions: const [SuperFooterLink('Details')],
  child: const AccountDetailsForm(),
);

// SuperSectionCard2 (new in v3.1.0) - rail-and-chip treatment:
SuperSectionCard2(
  title: 'Ledger Balance',
  subtitle: 'Rail and icon-chip treatment',
  icon: Icons.account_balance_outlined,
  dividerAfterHeader: true,
  child: const BalanceSummary(),
);

// Layout primitives (v3.0.0):
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

// Dialogs — SuperDialog was removed in v2; use themed showDialog / AlertDialog:
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
if (ok == true) delete();

// SuperSnackBar — one call per tone:
SuperSnackBar.info(context, 'Draft saved.', actionLabel: 'View', onAction: () {});
SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');
SuperSnackBar.warning(context, '3 entries require review before closing.');
SuperSnackBar.danger(context, 'Transfer failed — accounts out of balance.');

// SuperAppBar — iOS-style back chevron, headlineSm title, labelSm subtitle:
Scaffold(
  appBar: SuperAppBar(
    title: const Text('Create Store'),
    subtitle: const Text('STORES & PRODUCTS • STORES'),
    subtitlePosition: SubtitlePosition.above, // or .below (default)
    maxActions: 3, // extras collapse into a ⋮ menu; omit for per-device 3/4/5
    actions: [SuperIconButton(icon: Icons.help_outline, onPressed: () {})],
  ),
  body: const SizedBox.shrink(),
);

// SuperSliverAppBar — same features inside a CustomScrollView:
CustomScrollView(slivers: [
  SuperSliverAppBar(
    pinned: true,
    expandedHeight: 200,
    title: const Text('Journal'),
    subtitle: const Text('BANKING • LOCAL TRANSFERS'),
    flexibleSpace: const FlexibleSpaceBar(background: ColoredBox(color: Colors.black12)),
    actions: [SuperIconButton(icon: Icons.filter_list, onPressed: () {})],
  ),
  // … content slivers …
]);
```

## 11b · Dynamic tokens + custom font (v2.0.0)

```dart
// Override brand tokens on the theme:
SuperMaterialThemeData.light(
  textTheme: SuperTextTheme(),
  primaryTextTheme: SuperTextTheme(),
  tokens: const SuperTokensData(radiusCard: 12, space4: 20),
);
// Read the active tokens at a call site:
final tokens = SuperThemeData.of(context).tokens;
SizedBox(height: tokens.space4);
color: SuperMarker.ledger.resolve(tokens);
// where const is mandatory (enum arg / static const / default param), use a
// brand-value literal instead — there are no static token constants:
const SizedBox(height: 16); // space4

// Swap the font family (keeps the GeniusLink type ramp when merging):
SuperMaterialThemeData.light(
  fontFamily: 'IBM Plex Sans',
  textTheme: SuperTextTheme(),
  primaryTextTheme: SuperTextTheme(),
);
SuperMaterialThemeData.light(
  textTheme: myTextTheme,
  primaryTextTheme: myTextTheme,
);
```

## 11c · SuperTextTheme — typography (v2.4.0)

`SuperText` is **removed**. Use `context.superTextTheme.<field>` instead.

```dart
// Reading named type-ramp fields:
final t = context.superTheme;           // SuperThemeData (surfaces/tokens)
final tt = context.superTextTheme;      // SuperTextTheme from material theme

Text('Account Name', style: tt.titleMd.copyWith(color: t.fg1));
Text('SECTION LABEL', style: tt.labelSm.copyWith(color: t.fg3, letterSpacing: 1.2));
Text('Body copy', style: tt.bodySm.copyWith(color: t.fg2));
Text('SAR 48,200.00', style: tt.mono.copyWith(color: t.fg1));

// Named fields:   displayLg · headlineSm · titleMd · bodyLg · bodySm
//                 labelMd · labelSm · mono · eyebrow
// Convenience:    heading (= titleMedium) · body (= bodyMedium) ·
//                 label (= labelMedium) · caption (= bodySmall) ·
//                 button (= labelLarge) · pill (= labelSmall) · h1 (= titleLarge)

// Strongly typed access through SuperMaterialThemeData:
final mtt = SuperMaterialThemeData.of(context).textTheme;
Text('Colored heading', style: mtt.headlineSm);
```

## 12 · Complete ColorScheme, Scaffold & system bars (v1.3.0)

```dart
// The generated ColorScheme now fills every Material 3 role — the fixed accent
// roles and the full surface-container ramp:
final cs = Theme.of(context).colorScheme;
cs.primaryFixed; cs.primaryFixedDim; cs.onPrimaryFixed; cs.onPrimaryFixedVariant;
cs.surfaceDim; cs.surfaceBright;
cs.surfaceContainerLowest; cs.surfaceContainer; cs.surfaceContainerHighest;

// v3.5.1: Scaffold stays on ColorScheme.surface in both light and dark.
// Container-style components use ColorScheme.surfaceContainer, and inputs keep
// the dedicated input fill. SuperMaterialThemeData wires this hierarchy for you.
Scaffold(
  body: Card(child: child), // Card uses the generated surfaceContainer role.
);

// The card surface (white / near-black) is SuperThemeData.surface — UNCHANGED
// in 1.3.0. If you relied on colorScheme.surface meaning the card color, switch:
final cardBg = SuperThemeData.of(context).surface;   // or cs.surfaceContainerLowest

// App bar rides the card surface (distinct from the Scaffold) and its
// systemOverlayStyle paints the status bar + navigation bar the same color,
// picking icon brightness automatically. Just use AppBar — nothing extra:
Scaffold(appBar: AppBar(title: const Text('Journals')), body: child);

// Precedence is unchanged (explicit > palette-generated > Flutter default):
SuperMaterialThemeData.dark(
  textTheme: SuperTextTheme(),
  primaryTextTheme: SuperTextTheme(),
  appBarTheme: const AppBarTheme(centerTitle: true), // replaces the generated one
);
```
