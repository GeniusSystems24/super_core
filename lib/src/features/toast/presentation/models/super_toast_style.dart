// ============================================================
// features/toast/presentation/models/super_toast_style.dart
// ------------------------------------------------------------
// Behavior/style configuration for SuperToast. Visual defaults resolve from
// the active Super Core theme; animation timings preserve the reference toast
// choreography while scaling from Super motion tokens.
// ============================================================

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/super_theme.dart';
import 'super_toast_alignment.dart';

/// Expansion policy for a toast stack.
enum SuperToastExpandBehavior {
  /// The stack is permanently expanded.
  always,

  /// Pointer hover or touch press expands/collapses the stack.
  hoverOrPress,

  /// The stack never expands.
  disabled,
}

/// Motion for the stack as a whole.
@immutable
class SuperToastStackMotion {
  const SuperToastStackMotion({
    this.expandDuration,
    this.collapseDuration,
    this.expandCurve,
    this.collapseCurve,
  });

  final Duration? expandDuration;
  final Duration? collapseDuration;
  final Curve? expandCurve;
  final Curve? collapseCurve;
}

/// Motion for an individual toast.
@immutable
class SuperToastMotion {
  const SuperToastMotion({
    this.entranceDuration,
    this.dismissDuration,
    this.transitionDuration,
    this.reentranceDuration,
    this.exitDuration,
    this.swipeCompletionDuration,
    this.entranceCurve,
    this.dismissCurve,
    this.transitionCurve,
    this.reentranceCurve,
    this.exitCurve,
    this.swipeCompletionCurve,
    this.entranceDismissFadeTween,
    this.fadeOnEntrance = true,
  });

  final Duration? entranceDuration;
  final Duration? dismissDuration;
  final Duration? transitionDuration;
  final Duration? reentranceDuration;
  final Duration? exitDuration;
  final Duration? swipeCompletionDuration;
  final Curve? entranceCurve;
  final Curve? dismissCurve;
  final Curve? transitionCurve;
  final Curve? reentranceCurve;
  final Curve? exitCurve;
  final Curve? swipeCompletionCurve;

  /// Optional opacity tween for entrance/dismiss. Defaults to 0 → 1.
  /// Supply a custom [Animatable] for fine-grained parity/customization.
  final Animatable<double>? entranceDismissFadeTween;

  /// Backwards-compatible shorthand. When false and no explicit tween is
  /// supplied, opacity stays at 1 during entrance/dismiss.
  final bool fadeOnEntrance;
}

/// Host-level toast behavior and layout overrides.
@immutable
class SuperToastHostStyle {
  const SuperToastHostStyle({
    this.maxVisible = 3,
    this.padding,
    this.expandBehavior = SuperToastExpandBehavior.hoverOrPress,
    this.expandHoverEnterDuration,
    this.expandHoverExitDuration,
    this.expandStartSpacing = 0,
    this.expandSpacing,
    this.collapsedProtrusion,
    this.collapsedScale = 0.97,
    this.motion = const SuperToastStackMotion(),
    this.alignment,
    this.resumeStagger,
  }) : assert(maxVisible > 0),
       assert(collapsedScale > 0 && collapsedScale <= 1);

  final int maxVisible;
  final EdgeInsetsGeometry? padding;
  final SuperToastExpandBehavior expandBehavior;
  final Duration? expandHoverEnterDuration;
  final Duration? expandHoverExitDuration;
  final double expandStartSpacing;
  final double? expandSpacing;
  final double? collapsedProtrusion;
  final double collapsedScale;
  final SuperToastStackMotion motion;

  /// Default alignment. `null` uses the adaptive touch/desktop placement.
  final SuperToastAlignment? alignment;

  /// Stagger added when auto-dismiss resumes for older entries.
  final Duration? resumeStagger;

  SuperToastResolvedHostStyle resolve(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final spacing = t.spacing;

    return SuperToastResolvedHostStyle(
      maxVisible: maxVisible,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: spacing.space5,
            vertical: spacing.space4,
          ),
      expandBehavior: expandBehavior,
      expandHoverEnterDuration: expandHoverEnterDuration ?? k.durExpand,
      expandHoverExitDuration: expandHoverExitDuration ?? k.durExpand,
      expandStartSpacing: expandStartSpacing,
      expandSpacing: expandSpacing ?? spacing.space3,
      collapsedProtrusion: collapsedProtrusion ?? spacing.space3,
      collapsedScale: collapsedScale,
      motion: SuperToastResolvedStackMotion(
        expandDuration:
            motion.expandDuration ?? _times(k.durExpand, 2),
        collapseDuration:
            motion.collapseDuration ?? _plus(k.durExpand, k.durFast),
        expandCurve: motion.expandCurve ?? Curves.easeOutCubic,
        collapseCurve: motion.collapseCurve ?? Curves.easeOut,
      ),
      alignment: alignment ?? SuperToastAlignment.adaptive(t.mode),
      resumeStagger: resumeStagger ?? _times(k.durBase, 2),
    );
  }
}

@immutable
class SuperToastResolvedHostStyle {
  const SuperToastResolvedHostStyle({
    required this.maxVisible,
    required this.padding,
    required this.expandBehavior,
    required this.expandHoverEnterDuration,
    required this.expandHoverExitDuration,
    required this.expandStartSpacing,
    required this.expandSpacing,
    required this.collapsedProtrusion,
    required this.collapsedScale,
    required this.motion,
    required this.alignment,
    required this.resumeStagger,
  });

  final int maxVisible;
  final EdgeInsetsGeometry padding;
  final SuperToastExpandBehavior expandBehavior;
  final Duration expandHoverEnterDuration;
  final Duration expandHoverExitDuration;
  final double expandStartSpacing;
  final double expandSpacing;
  final double collapsedProtrusion;
  final double collapsedScale;
  final SuperToastResolvedStackMotion motion;
  final SuperToastAlignment alignment;
  final Duration resumeStagger;
}

@immutable
class SuperToastResolvedStackMotion {
  const SuperToastResolvedStackMotion({
    required this.expandDuration,
    required this.collapseDuration,
    required this.expandCurve,
    required this.collapseCurve,
  });

  final Duration expandDuration;
  final Duration collapseDuration;
  final Curve expandCurve;
  final Curve collapseCurve;

  @override
  bool operator ==(Object other) =>
      other is SuperToastResolvedStackMotion &&
      other.expandDuration == expandDuration &&
      other.collapseDuration == collapseDuration &&
      other.expandCurve == expandCurve &&
      other.collapseCurve == collapseCurve;

  @override
  int get hashCode => Object.hash(
    expandDuration,
    collapseDuration,
    expandCurve,
    collapseCurve,
  );
}

/// Per-toast surface/motion overrides.
@immutable
class SuperToastStyle {
  const SuperToastStyle({
    this.constraints,
    this.decoration,
    this.backgroundFilter,
    this.padding,
    this.iconTheme,
    this.iconSpacing,
    this.titleSpacing,
    this.suffixSpacing,
    this.clipBehavior = Clip.none,
    this.motion = const SuperToastMotion(),
  });

  final BoxConstraints? constraints;
  final Decoration? decoration;
  final ImageFilter? backgroundFilter;
  final EdgeInsetsGeometry? padding;
  final IconThemeData? iconTheme;
  final double? iconSpacing;
  final double? titleSpacing;
  final double? suffixSpacing;
  final Clip clipBehavior;
  final SuperToastMotion motion;

  SuperToastResolvedStyle resolve(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final spacing = t.spacing;

    return SuperToastResolvedStyle(
      constraints:
          constraints ?? const BoxConstraints(maxHeight: 250, maxWidth: 400),
      decoration:
          decoration ??
          BoxDecoration(
            color: t.surface,
            border: Border.all(color: t.border),
            borderRadius: spacing.borderRadiusCard,
            boxShadow: SuperThemeData.popShadow,
          ),
      backgroundFilter: backgroundFilter,
      padding: padding ?? spacing.cardPadding,
      iconTheme:
          iconTheme ?? IconThemeData(color: t.fg1, size: t.sizing.icon),
      iconSpacing: iconSpacing ?? spacing.space3,
      titleSpacing: titleSpacing ?? spacing.space1,
      suffixSpacing: suffixSpacing ?? spacing.space3,
      clipBehavior: clipBehavior,
      motion: SuperToastResolvedMotion(
        entranceDuration:
            motion.entranceDuration ?? _times(k.durExpand, 2),
        dismissDuration:
            motion.dismissDuration ?? _plus(k.durExpand, k.durFast),
        transitionDuration:
            motion.transitionDuration ?? _times(k.durExpand, 2),
        reentranceDuration:
            motion.reentranceDuration ?? _times(k.durExpand, 2),
        exitDuration: motion.exitDuration ?? _times(k.durExpand, 2),
        swipeCompletionDuration:
            motion.swipeCompletionDuration ?? k.durBase,
        entranceCurve: motion.entranceCurve ?? Curves.easeOutCubic,
        dismissCurve: motion.dismissCurve ?? Curves.easeOutCubic,
        transitionCurve: motion.transitionCurve ?? Curves.easeOutCubic,
        reentranceCurve: motion.reentranceCurve ?? Curves.easeOutCubic,
        exitCurve: motion.exitCurve ?? Curves.easeOutCubic,
        swipeCompletionCurve:
            motion.swipeCompletionCurve ?? Curves.easeInCubic,
        entranceDismissFadeTween:
            motion.entranceDismissFadeTween ??
            (motion.fadeOnEntrance
                ? const SuperToastFadeTween(begin: 0, end: 1)
                : const SuperToastFadeTween(begin: 1, end: 1)),
      ),
    );
  }
}

@immutable
class SuperToastResolvedStyle {
  const SuperToastResolvedStyle({
    required this.constraints,
    required this.decoration,
    required this.backgroundFilter,
    required this.padding,
    required this.iconTheme,
    required this.iconSpacing,
    required this.titleSpacing,
    required this.suffixSpacing,
    required this.clipBehavior,
    required this.motion,
  });

  final BoxConstraints constraints;
  final Decoration decoration;
  final ImageFilter? backgroundFilter;
  final EdgeInsetsGeometry padding;
  final IconThemeData iconTheme;
  final double iconSpacing;
  final double titleSpacing;
  final double suffixSpacing;
  final Clip clipBehavior;
  final SuperToastResolvedMotion motion;

  BorderRadius resolveBorderRadius(BuildContext context) {
    final decoration = this.decoration;
    if (decoration is BoxDecoration && decoration.borderRadius != null) {
      return decoration.borderRadius!.resolve(Directionality.of(context));
    }
    return context.superTheme.spacing.borderRadiusCard;
  }
}

@immutable
class SuperToastResolvedMotion {
  const SuperToastResolvedMotion({
    required this.entranceDuration,
    required this.dismissDuration,
    required this.transitionDuration,
    required this.reentranceDuration,
    required this.exitDuration,
    required this.swipeCompletionDuration,
    required this.entranceCurve,
    required this.dismissCurve,
    required this.transitionCurve,
    required this.reentranceCurve,
    required this.exitCurve,
    required this.swipeCompletionCurve,
    required this.entranceDismissFadeTween,
  });

  final Duration entranceDuration;
  final Duration dismissDuration;
  final Duration transitionDuration;
  final Duration reentranceDuration;
  final Duration exitDuration;
  final Duration swipeCompletionDuration;
  final Curve entranceCurve;
  final Curve dismissCurve;
  final Curve transitionCurve;
  final Curve reentranceCurve;
  final Curve exitCurve;
  final Curve swipeCompletionCurve;
  final Animatable<double> entranceDismissFadeTween;

  @override
  bool operator ==(Object other) =>
      other is SuperToastResolvedMotion &&
      other.entranceDuration == entranceDuration &&
      other.dismissDuration == dismissDuration &&
      other.transitionDuration == transitionDuration &&
      other.reentranceDuration == reentranceDuration &&
      other.exitDuration == exitDuration &&
      other.swipeCompletionDuration == swipeCompletionDuration &&
      other.entranceCurve == entranceCurve &&
      other.dismissCurve == dismissCurve &&
      other.transitionCurve == transitionCurve &&
      other.reentranceCurve == reentranceCurve &&
      other.exitCurve == exitCurve &&
      other.swipeCompletionCurve == swipeCompletionCurve &&
      other.entranceDismissFadeTween == entranceDismissFadeTween;

  @override
  int get hashCode => Object.hashAll([
    entranceDuration,
    dismissDuration,
    transitionDuration,
    reentranceDuration,
    exitDuration,
    swipeCompletionDuration,
    entranceCurve,
    dismissCurve,
    transitionCurve,
    reentranceCurve,
    exitCurve,
    swipeCompletionCurve,
    entranceDismissFadeTween,
  ]);
}


/// Immutable opacity tween used by the default entrance/dismiss choreography.
@immutable
class SuperToastFadeTween extends Animatable<double> {
  const SuperToastFadeTween({required this.begin, required this.end});

  final double begin;
  final double end;

  @override
  double transform(double t) => begin + (end - begin) * t;

  @override
  bool operator ==(Object other) =>
      other is SuperToastFadeTween && other.begin == begin && other.end == end;

  @override
  int get hashCode => Object.hash(begin, end);
}

Duration _times(Duration duration, int factor) =>
    Duration(microseconds: duration.inMicroseconds * factor);

Duration _plus(Duration a, Duration b) =>
    Duration(microseconds: a.inMicroseconds + b.inMicroseconds);
