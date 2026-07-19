# super_core — ChatGPT / Codex migration guide (v1.x → v2.0.0)

```yaml
name:    super_core-migration-v1-to-v2
from:    super_core 1.x
to:      super_core 2.0.0
import:  package:super_core/super_core.dart
```

Use these instructions whenever you upgrade super_core, or a package/app that
depends on it, from 1.x to 2.0.0.

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

The `abstract final class SuperTokens` of `static const` values is **removed**,
and it has **no static replacement**. Brand tokens (accent + semantic palette,
font families, radii, the 4px spacing scale, control metrics, motion) are now
instance fields on the immutable `SuperTokensData`, carried by the theme and
read dynamically:

- `SuperThemeData.tokens` — on the theme extension
  (`SuperThemeData.of(context).tokens.x`, or `context.superTheme.tokens.x`).
- `SuperMaterialThemeData.tokens` — on the Material theme.
- The default values live only as the literals baked into the `SuperTokensData`
  constructor; the single default *instance* is `SuperTokensData.fallback`.
  There are **no** `SuperTokensData.defaultX` constants.

### Rewrite rules

The universal replacement is a **dynamic read** — there is no static constant
fallback, so a `const` call site must drop its `const` and read from context:

| v1 | v2 |
|---|---|
| `SuperTokens.accent` | `SuperThemeData.of(context).tokens.accent` |
| `SuperTokens.space4` | `context.superTheme.tokens.space4` |
| `SuperTokens.radiusCard` | `context.superTheme.tokens.radiusCard` |
| `SuperTokens.durBase` | `context.superTheme.tokens.durBase` |
| `SuperTokens.monoFont` | `context.superTheme.tokens.monoFont` |

**Handling `const` contexts (the main mechanical work):**

- A widget that read a token inside a `const` constructor must drop `const` and
  read from context: `const SizedBox(height: SuperTokens.space2)` →
  `SizedBox(height: context.superTheme.tokens.space2)`. Removing `const` where
  the subtree now contains a dynamic read is required — a lingering outer
  `const` around a dynamic value is a compile error.
- Where `const` is **mandatory** and no context is available — enum constant
  arguments, `static const` fields, and default parameter values — a dynamic
  read is impossible. Use a plain literal (the brand value), matching the
  file's existing literal pattern. Examples from the migrated toolkit:
  - enum: `asset('Asset', 'الأصول', Color(0xFF4A7CFF), …)` (accent literal)
  - default param: `this.color = const Color(0xFF4A7CFF)`
  - theme-preset static const: `static const Color accent = Color(0xFF4A7CFF);`
  - initState (theme read unsafe): `curve: const Cubic(0.4, 0, 0.2, 1)`

> Brand-value literals (for reference): accent `0xFF4A7CFF`,
> accentHover `0xFF5E8DFF`, accentPressed `0xFF3D6DEB`, success `0xFF1DB88A`,
> warning `0xFFF97316`, danger `0xFFEF4444`; fonts `Manrope` / `Inter` /
> `JetBrainsMono` / `NotoNaskhArabic`; spacing 4/8/12/16/24/32/40/64/80;
> radii control 4 / md 6 / card 8 / pill 12; motion durBase 150ms,
> curveStandard `Cubic(0.4, 0, 0.2, 1)`.

### `SuperMarker` colors

`SuperMarker` no longer exposes any color constant. Resolve against the ambient
token bundle:

```dart
// v1: SuperMarker.ledger.color  (or a SuperTokens color in a switch)
final tokens = SuperThemeData.of(context).tokens;
color: SuperMarker.ledger.resolve(tokens);   // the only path — fully dynamic
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
2. [ ] Replace `SuperTokens.<field>` → `context.superTheme.tokens.<field>`
       (dynamic), dropping `const` on the enclosing widget. Where `const` is
       mandatory (enum arg / static const / default param / initState), use a
       brand-value literal instead.
3. [ ] Update token-shim `export … show SuperTokens` → `show SuperTokensData`.
4. [ ] Replace `SuperMarker.x` color reads with `SuperMarker.x.resolve(tokens)`.
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
