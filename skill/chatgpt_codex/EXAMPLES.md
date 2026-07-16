# super_core · Examples (v1.2.0)

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
        borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
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


## 11 · Design-system widgets (v1.2.0)

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

// SuperDialog — arbitrary dialog, confirm (Future<bool>), and alert:
SuperDialog.show<void>(context, builder: (ctx) => SuperDialog(
  title: 'Export Options',
  subtitle: 'Choose a format for the exported data',
  content: const Text('CSV · PDF · JSON'),
  actions: [
    SuperButton(label: 'Cancel', variant: SuperButtonVariant.secondary,
        onPressed: () => Navigator.of(ctx).pop()),
    SuperButton(label: 'Export', onPressed: () => Navigator.of(ctx).pop()),
  ],
));

final ok = await SuperDialog.confirm(context,
    title: 'Delete Store', message: 'This cannot be undone.',
    confirmLabel: 'Delete', danger: true);      // red confirm button
if (ok) delete();

await SuperDialog.alert(context, title: 'Entry Posted',
    message: 'JV-2024-0042 posted to the ledger.',
    icon: Icons.check_circle_outline, iconColor: SuperTokens.success);

// SuperSnackBar — one call per tone:
SuperSnackBar.info(context, 'Draft saved.', actionLabel: 'View', onAction: () {});
SuperSnackBar.success(context, 'Journal entry JV-2024-0042 posted.');
SuperSnackBar.warning(context, '3 entries require review before closing.');
SuperSnackBar.danger(context, 'Transfer failed — accounts out of balance.');

// SuperAppBar — drops into Scaffold.appBar:
Scaffold(
  appBar: SuperAppBar(
    eyebrow: 'Stores & Products • Stores',
    title: 'Create Store',
    titleTrailing: const StatusPill('DRAFT', tone: PillTone.warning),
    actions: [SuperIconButton(icon: Icons.help_outline, onPressed: () {})],
  ),
  body: const SizedBox.shrink(),
);
```
