# super_core — ChatGPT / Codex migration guide (v2.0.x → v2.1.0)

```yaml
name:    super_core-migration-v2-to-v2.1
from:    super_core 2.0.x
to:      super_core 2.1.0
import:  package:super_core/super_core.dart
```

Use these instructions whenever you upgrade super_core, or a package/app that
depends on it, from 2.0.x to 2.1.0.

# Migrating super_core v2.0.x → v2.1.0

v2.1.0 is a small but **breaking** release: it deletes every remaining static
token value so the theme is the *only* source of brand tokens. If your code
already reads tokens through `SuperThemeData.of(context).tokens`, there is
nothing to do. The break only affects code that referenced the v2.0 static
default constants.

> Context: v2.0.0 turned the static `SuperTokens` class into the dynamic
> `SuperTokensData` but kept a `static const` **mirror** of every field
> (`SuperTokensData.defaultAccent`, `defaultSpace4`, …) plus
> `SuperMarker.<x>.defaultColor`, as a convenience for `const` call sites.
> v2.1.0 removes those mirrors — "no static values in the theme" — so nothing
> can read a brand token except from the ambient theme.

---

## 0. Bump the dependency

```yaml
# pubspec.yaml
super_core: ">=2.1.0 <3.0.0"   # was ">=2.0.0 <3.0.0"
```

`flutter pub get`. Path dependencies need no change.

---

## 1. Remove `SuperTokensData.default*` references  ⚠️ the only real break

Every `static const` default mirror is gone:
`SuperTokensData.defaultAccent`, `defaultAccentHover`, `defaultAccentPressed`,
`defaultSuccess`, `defaultWarning`, `defaultDanger`, `defaultDisplayFont`,
`defaultBodyFont`, `defaultMonoFont`, `defaultArabicFont`, `defaultRadius*`,
`defaultSpace*`, `defaultControlHeight`, `defaultIconButton`, `defaultMarker*`,
`defaultContentColumn`, `defaultField*`, `defaultStepperSize`,
`defaultTrailingIcon`, `defaultDur*`, `defaultCurve*` — **all deleted.**

### Rewrite rule

Read the value dynamically from the theme; there is no static fallback, so a
`const` call site must drop its `const`:

```dart
// v2.0
Container(color: SuperTokensData.defaultAccent);
const SizedBox(height: SuperTokensData.defaultSpace4);

// v2.1 — read from the ambient theme (context in scope)
Container(color: context.superTheme.tokens.accent);
SizedBox(height: context.superTheme.tokens.space4);   // const dropped
```

`context.superTheme.tokens` and `SuperThemeData.of(context).tokens` are the same
bundle; use whichever reads cleaner.

### Where `const` is mandatory and no `context` exists

Enum constant arguments, `static const` fields, and default parameter values
cannot read the theme. Use a **plain brand-value literal** (matching the file's
existing literal style):

```dart
// enum constant
asset('Asset', 'الأصول', Color(0xFF4A7CFF), AccountNature.debit),
// default parameter value
const CountPill({required this.label, this.color = const Color(0xFF4A7CFF)});
// static const preset (a theme class's own const presets)
static const Color accent = Color(0xFF4A7CFF);
// initState (reading the theme there is unsafe)
_curve = CurvedAnimation(parent: _ac, curve: const Cubic(0.4, 0, 0.2, 1));
```

Brand-value literals for reference: accent `0xFF4A7CFF`,
accentHover `0xFF5E8DFF`, accentPressed `0xFF3D6DEB`, success `0xFF1DB88A`,
warning `0xFFF97316`, danger `0xFFEF4444`; fonts `Manrope` / `Inter` /
`JetBrainsMono` / `NotoNaskhArabic`; spacing 4/8/12/16/24/32/40/64/80; radii
control 4 / md 6 / card 8 / pill 12; controlHeight 40, iconButton 32,
markerWidth 4, markerHeight 40, contentColumn 680, fieldComfortable 42,
fieldCompact 36, stepperSize 24, trailingIcon 26; durFast 100ms, durBase 150ms,
durExpand 200ms, curveStandard `Cubic(0.4, 0, 0.2, 1)`, curveOut
`Cubic(0, 0, 0.2, 1)`.

> Tip: prefer restructuring so a `context` is available (turn a `static const`
> field into a `Color foo(BuildContext context) => context.superTheme.tokens.x`
> helper, or a getter that reads an existing `SuperThemeData` field) over
> hard-coding a literal — the literal will not follow a themed override. Only
> fall back to a literal when `const` is genuinely unavoidable.

---

## 2. `SuperMarker.<x>.defaultColor` removed

`SuperMarker` no longer carries a `defaultColor`. Resolve against the ambient
tokens:

```dart
// v2.0
color: SuperMarker.ledger.defaultColor;
// v2.1
color: SuperMarker.ledger.resolve(context.superTheme.tokens);
```

`SuperMarker.resolve(tokens)` is unchanged and remains the correct API.

---

## 3. Nothing else changes

`SuperTokensData` itself (fields, `copyWith`, `lerp`, `fallback`),
`SuperMaterialThemeData`, the widgets (`SuperAppBar`, `SuperSliverAppBar`,
`SuperCard`, …), and the theme classes are all source-compatible with 2.0.
`SuperTokensData.fallback` (the default *instance*) still exists — only the
per-field `default*` *constants* were removed.

---

## Migration checklist

1. [ ] Bump `super_core` to `">=2.1.0 <3.0.0"`; `flutter pub get`.
2. [ ] Replace `SuperTokensData.default<Field>` → `context.superTheme.tokens.<field>`
       (drop the enclosing `const`), or a brand-value literal where `const` is
       mandatory (enum arg / static const / default param / initState).
3. [ ] Replace `SuperMarker.<x>.defaultColor` →
       `SuperMarker.<x>.resolve(context.superTheme.tokens)`.
4. [ ] `flutter analyze` — grep for `SuperTokensData.default` and `.defaultColor`;
       every hit is a site this guide covers.
5. [ ] `flutter test`; smoke-test the example app.

## Verification

```bash
flutter pub get
dart format .
flutter analyze     # expect zero errors
flutter test
```
