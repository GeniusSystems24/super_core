# super_core skill

Use this guidance when building or reviewing Flutter UI that depends on
`super_core`.

## Package target

- Current package version: `3.5.0`.
- Import the public API from `package:super_core/super_core.dart`.
- Treat `SuperMaterialThemeData`, `SuperThemeData`, `SuperTextTheme`,
  `SuperSemanticColors`, `SuperSpacing`, and `SuperSizing` as the visual source
  of truth.
- Do not introduce feature-specific hard-coded colors, radii, spacing, type
  scales, or motion when an equivalent Super design token exists.

## SuperToast (v3.5.0)

`SuperToast` is the advanced host-based transient notification API. Its visuals must stay on the active `super_core` design system; do not hard-code a second toast palette, spacing scale, typography system, elevation system or motion language.

### Installation

Place `SuperToastHost` near the app root, normally in `MaterialApp.builder`:

```dart
MaterialApp(
  builder: (context, child) => SuperToastHost(
    child: child ?? const SizedBox.shrink(),
  ),
);
```

Toast calls require a descendant context. This host keeps toast theming live, provides an Overlay ancestor for raw interactive content, groups entries by resolved alignment, and owns the animated stacks.

### Standard usage

Use `SuperToast.show`, `info`, `success`, `warning`, or `danger` for the standard design-system surface. Prefer short titles and concise descriptions.

```dart
SuperToast.success(
  context,
  title: 'Saved',
  description: 'The record was saved successfully.',
);
```

### Placement

The adaptive default is `topCenter` on touch layouts and `bottomEnd` on desktop. Supported named placements are `topStart`, `topCenter`, `topEnd`, `topLeft`, `topRight`, `bottomStart`, `bottomCenter`, `bottomEnd`, `bottomLeft`, and `bottomRight`. Start/end resolve from text direction. Use `SuperToastAlignment` for custom placement.

### Stack behavior

Each resolved alignment owns an independent stack. The default stack is collapsed and shows up to three deck layers. It expands after a short hover delay on pointer devices or by press on touch devices. `SuperToastExpandBehavior` supports `always`, `hoverOrPress`, and `disabled`. Older collapsed entries scale down and protrude behind the front entry; expanded stacks animate using measured child sizes.

### Swipe behavior

Swipe-to-dismiss defaults to the outward directions implied by the resolved alignment. Corner placements permit outward vertical and horizontal dismissal; centered placements permit the outward vertical axis. Pass `swipeToDismiss: []` to disable, or an explicit `List<AxisDirection>` to override. `dismissThreshold` must be from 0 to 1.

### Timing and interaction

The default duration is five seconds. `duration: null` is persistent; `Duration.zero` is also accepted for backwards compatibility. Hover, stack interaction, manual pause and swipe suspend auto-dismiss. When interaction ends, the configured duration restarts and older entries receive a small stagger. Accessible navigation disables auto-dismiss.

`SuperToastHandle` exposes `showing`, `isActive`, `isPaused`, `dismiss()`, `pause()`, and `resume()`.

### Custom content

Use `suffixBuilder` when suffix content needs the active handle. Use `SuperToast.showRaw` for fully custom toast contents while retaining placement, stacking, timers, semantics, gestures and motion.

### Accessibility

Keep the built-in live-region and dismiss semantics. When accessible navigation or disabled motion is active, do not force entrance/dismiss/stack motion back on and do not re-enable auto-dismiss. Directional positions must remain RTL-aware.

### Architecture

Keep MVC/Clean Architecture boundaries intact:
- `domain/entities`: immutable behavior data and semantic tone/position values.
- `presentation/controllers`: entry lifecycle and public handles.
- `presentation/models`: alignment, style, action and active-entry presentation models.
- `presentation/views`: host, surface, interaction state, animations and render-layout implementation.

Timers, pointer state, swipe state and animation controllers belong to presentation views, not the domain model. The controller should own entry lifecycle, not rendering details.

### SuperToast vs SuperSnackBar

`SuperSnackBar` is the `ScaffoldMessenger` feedback primitive. `SuperToast` is the independent host-based stacked toast system. Do not silently replace one with the other when behavior matters.

## Example app

The example application starts at `HomeScreen`, which acts as the responsive
catalog for package demos. `ToastExampleScreen` must demonstrate semantic
tones, top/bottom placement, actions, a custom icon, persistent handles, and
dismiss-all behavior.

## Quality checks

For changes to `super_core`, run:

```console
dart format .
flutter analyze
flutter test
```

Add or update widget tests whenever overlay lifecycle, dismissal behavior,
directionality, theming, or public component behavior changes.
