---
name: super-core-migration-v1-to-v2
description: >
  Step-by-step guide to migrate Flutter code from super_core v1.x to v2.0.0 —
  the breaking release that turns the static `SuperTokens` class into the dynamic
  theme-owned `SuperTokensData`, adds a custom-font pipeline, forks `AppBar` /
  `SliverAppBar` into `SuperAppBar` / `SuperSliverAppBar` (subtitle + responsive
  action overflow), makes `SuperCard` expandable, and removes `SuperDialog`. Use
  this whenever you upgrade super_core or a package/app that depends on it.
---

# Migrating super_core v1.x → v2.0.0

v2.0.0 is a **breaking** release. This guide lists every change that can break a
call site and the exact rewrite for each. Work top to bottom; finish with
`flutter analyze` in the package **and** every dependent.

---

## 0. Bump the dependency

Every dependent package (and example) that pins a version constraint:

```yaml
# pubspec.yaml — before
super_core: ">=1.2.0 <2.0.0"
# after
super_core: ">=2.0.0 <3.0.0"
```

Path dependencies (`super_core: { path: ../super_core }`) need no change. Then
`flutter pub get` in each package.

---

## 1. `SuperTokens` (static) → `SuperTokensData` (dynamic)  ⚠️ the big one

The `abstract final class SuperTokens` of `static const` values is **removed**.
Brand tokens (accent + semantic palette, font families, radii, the 4px spacing
scale, control metrics, motion) are now instance fields on the immutable
`SuperTokensData`, carried by the theme:

- `SuperThemeData.tokens` — on the theme extension.
- `SuperMaterialThemeData.tokens` — on the Material theme.
- Every field also has a `static const` **default mirror**:
  `SuperTokensData.defaultAccent`, `defaultSpace4`, `defaultRadiusCard`,
  `defaultDurBase`, `defaultCurveStandard`, … (name = `default` + PascalCase of
  the field).

### Rewrite rules

| v1 | v2 (runtime — preferred in widgets) | v2 (`const` context) |
|---|---|---|
| `SuperTokens.accent` | `SuperThemeData.of(context).tokens.accent` | `SuperTokensData.defaultAccent` |
| `SuperTokens.space4` | `context.superTheme.tokens.space4` | `SuperTokensData.defaultSpace4` |
| `SuperTokens.radiusCard` | `…tokens.radiusCard` | `SuperTokensData.defaultRadiusCard` |
| `SuperTokens.durBase` | `…tokens.durBase` | `SuperTokensData.defaultDurBase` |
| `SuperTokens.monoFont` | `…tokens.monoFont` | `SuperTokensData.defaultMonoFont` |

**Choosing which form:**

- If a `BuildContext` is in scope and you want the token to honor a theme
  override, read `SuperThemeData.of(context).tokens.x` (or `context.superTheme
  .tokens.x`).
- If the site is `const` (e.g. `const SizedBox(height: SuperTokens.space2)`,
  a default parameter value, a `const` constructor), use the
  `SuperTokensData.defaultX` constant — it is `const` and preserves the exact
  historical value.

> The fast, safe bulk migration is the const form: replace `SuperTokens.<field>`
> with `SuperTokensData.default<Field>` everywhere. It compiles unchanged
> (including in `const` contexts) and keeps every value identical. Then, where
> you *want* runtime theming, switch specific reads to
> `SuperThemeData.of(context).tokens.<field>`. The Super toolkit packages were
> migrated with exactly this rule.

### `SuperMarker` colors

`SuperMarker` no longer exposes a `static const` color. Resolve against a token
bundle, or use the per-value default:

```dart
// v1: SuperMarker.ledger.color  (or a SuperTokens color in a switch)
final tokens = SuperThemeData.of(context).tokens;
color: SuperMarker.ledger.resolve(tokens);   // runtime
color: SuperMarker.ledger.defaultColor;       // const default
```

### Overriding tokens (new capability)

```dart
SuperMaterialThemeData.light(
  tokens: const SuperTokensData(radiusCard: 12, space4: 20),
);
```

### Per-package token shims

Packages that re-exported the tokens class must update the show clause:

```dart
// <pkg>/lib/src/core/theme/*_tokens.dart — before
export 'package:super_core/super_core.dart' show SuperTokens, SuperMarker;
// after
export 'package:super_core/super_core.dart' show SuperTokensData, SuperMarker;
```

---

## 2. `SuperDialog` removed → themed `showDialog` / `AlertDialog`

`SuperDialog` and its `show` / `confirm` / `alert` statics are gone.
`SuperMaterialThemeData` already themes Flutter's dialogs (radius, colors, type).

```dart
// v1: SuperDialog.confirm(context, title: …, message: …, confirmLabel: 'Delete', danger: true) → Future<bool>
final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
  title: const Text('Delete Store'),
  content: const Text('This cannot be undone.'),
  actions: [
    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
    FilledButton(
      style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
      onPressed: () => Navigator.pop(ctx, true),
      child: const Text('Delete'),
    ),
  ],
));
if (ok == true) delete();

// v1: SuperDialog.alert(...) → an AlertDialog with a single OK action.
// v1: SuperDialog.show<T>(context, builder: (ctx) => SuperDialog(title:…, content:…, actions:[SuperButton…]))
//     → showDialog<T>(context: context, builder: (ctx) => AlertDialog(title:…, content:…, actions:[TextButton/FilledButton…]))
```

---

## 3. `SuperAppBar` API change (+ new features)

v1's `SuperAppBar` took `eyebrow` (ALL-CAPS breadcrumb) and `titleTrailing`.
v2's `SuperAppBar` is a full fork of Flutter's `AppBar`: `title` and `subtitle`
are **widgets**, and the subtitle position is set with `subtitlePosition`.

```dart
// v1
SuperAppBar(
  eyebrow: 'Stores & Products • Stores',
  title: 'Create Store',
  titleTrailing: const StatusPill('DRAFT', tone: PillTone.warning),
  actions: [...],
);

// v2 — subtitle above the (widget) title; a trailing pill becomes an action
SuperAppBar(
  title: const Text('Create Store'),
  subtitle: const Text('STORES & PRODUCTS • STORES'),
  subtitlePosition: SubtitlePosition.above, // .below is the default
  actions: [
    const StatusPill('DRAFT', tone: PillTone.warning),
    SuperIconButton(icon: Icons.help_outline, onPressed: () {}),
  ],
);
```

**New — responsive action overflow.** Extra actions past the limit collapse into
a three-dot menu. The limit defaults per device class (mobile 3 / tablet 4 /
desktop 5); override with `maxActions` or `maxMobileActions` /
`maxTabletActions` / `maxDesktopActions`.

**New — `SuperSliverAppBar`** for `CustomScrollView` slivers, with the same
subtitle + overflow features plus `pinned` / `floating` / `snap` / `stretch` /
`expandedHeight` / `flexibleSpace`.

Defaults for both come from `SuperAppBarTheme extends AppBarTheme`, installed
into `ThemeData.appBarTheme` by `SuperMaterialThemeData`. Override via
`appBarTheme:` on the theme constructor.

---

## 4. `SuperCard` — additive (old calls keep working)

v1 `SuperCard(header:, child:, onTap:, selected:, padding:)` still compiles. v2
adds:

- `leading` / `trailing` slots.
- `expandedChild` + `expandDirection` (`Axis.vertical` default, `.horizontal`),
  revealed on tap or via the chevron; controlled with `initiallyExpanded` /
  `isExpanded` / `onExpansionChanged`.

Defaults come from `SuperCardTheme extends CardThemeData` in
`ThemeData.cardTheme`.

---

## 5. New: custom font family

Optional — adopt if the app needs a non-default font.

```dart
SuperMaterialThemeData.light(fontFamily: 'IBM Plex Sans');
// or adopt a TextTheme's font over the GeniusLink ramp (sizes/weights kept):
SuperMaterialThemeData.light(textTheme: myTextTheme, mergeTextTheme: true);
// or replace the ramp wholesale:
SuperMaterialThemeData.light(textTheme: myTextTheme, mergeTextTheme: false);
```

---

## Migration checklist

1. [ ] Bump `super_core` constraint to `">=2.0.0 <3.0.0"`; `flutter pub get`.
2. [ ] Replace `SuperTokens.<field>` → `SuperTokensData.default<Field>` (const)
       or `SuperThemeData.of(context).tokens.<field>` (runtime).
3. [ ] Update token-shim `export … show SuperTokens` → `show SuperTokensData`.
4. [ ] Replace `SuperMarker.x` color reads with `.resolve(tokens)` / `.defaultColor`.
5. [ ] Replace `SuperDialog.*` with `showDialog` / `AlertDialog`.
6. [ ] Rewrite `SuperAppBar(eyebrow:, title:'…', titleTrailing:)` →
       `title: Text(...)` + `subtitle:` + `subtitlePosition:` (+ move trailing
       into `actions`).
7. [ ] `flutter analyze` in the package and every dependent — zero new errors.
8. [ ] `flutter test`; smoke-test the example app.

## Verification

```bash
flutter pub get
dart format .
flutter analyze     # expect zero errors; fix any remaining SuperTokens/SuperDialog refs
flutter test
```

If analyze still reports `SuperTokens` or `SuperDialog`, grep for them: every
remaining hit is a call site this guide covers.
