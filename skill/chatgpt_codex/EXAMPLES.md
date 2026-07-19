# super_core · Examples (v1.3.0)

Runnable, copy-pasteable snippets. All assume `import
'package:super_core/super_core.dart';`.

---

## 1 · Minimal app with light + dark + system mode

```dart
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
        darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
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
        theme:     SuperMaterialThemeData.light(palette: _palette),
        darkTheme: SuperMaterialThemeData.dark(palette: _palette),
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
            theme:     SuperMaterialThemeData.light(mode: mode),
            darkTheme: SuperMaterialThemeData.dark(mode: mode),
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
  appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  cardTheme: const CardThemeData(elevation: 3),
);
```

## 6 · Merging your own extension via copyWith

```dart
final theme = SuperMaterialThemeData.dark().copyWith(
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


## 11 · Design-system widgets (v2.0.0)

```dart
// SuperCard — general surface card; interactive + selectable variants:
SuperCard(
  header: const SectionHeader(title: 'Downtown Central Store'),
  child: const Text('Static card — 8px radius, hairline, card shadow.'),
);
SuperCard(
  padding: const EdgeInsets.all(16),
  selected: id == _selected,
  onTap: () => setState(() => _selected = id), // hover deepens the border
  child: const Text('Selectable row'),
);

// Expandable SuperCard (v2) — vertical or horizontal, with leading/trailing:
SuperCard(
  leading: const Icon(Icons.storefront_outlined),
  header: const SectionHeader(title: 'Downtown Central Store'),
  trailing: const StatusPill('ACTIVE', tone: PillTone.success),
  expandedChild: const Text('Balance SAR 48,200.00 across 3 sub-accounts.'),
  // expandDirection: Axis.horizontal, initiallyExpanded / isExpanded / onExpansionChanged…
  child: const Text('Tap the card or the chevron to reveal details'),
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

// SuperAppBar — subtitle position + responsive action overflow:
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
SuperMaterialThemeData.light(fontFamily: 'IBM Plex Sans');
SuperMaterialThemeData.light(textTheme: myTextTheme, mergeTextTheme: true);
```


## 12 · Complete ColorScheme, Scaffold & system bars (v1.3.0)

```dart
// The generated ColorScheme now fills every Material 3 role — the fixed accent
// roles and the full surface-container ramp:
final cs = Theme.of(context).colorScheme;
cs.primaryFixed; cs.primaryFixedDim; cs.onPrimaryFixed; cs.onPrimaryFixedVariant;
cs.surfaceDim; cs.surfaceBright;
cs.surfaceContainerLowest; cs.surfaceContainer; cs.surfaceContainerHighest;

// Scaffold background == ColorScheme.surface (the GeniusLink page background) —
// already wired by SuperMaterialThemeData, no need to set it. Cards/panels ride
// the brighter surfaceContainer ramp so they stay clearly separated:
Scaffold(
  body: Card(child: child), // Card sits on cardColor == surfaceContainerLowest (light)
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
  appBarTheme: const AppBarTheme(centerTitle: true), // replaces the generated one
);
```
