// ============================================================
// features/toast/presentation/models/super_toast_alignment.dart
// ------------------------------------------------------------
// Viewport/stack alignment model. It deliberately separates the screen anchor
// from the direction in which the toast deck grows.
// ============================================================

import 'package:flutter/widgets.dart';

import '../../../../core/theme/super_device_mode.dart';
import '../../domain/entities/super_toast_data.dart';

/// Controls where a toast stack is anchored and how it grows.
@immutable
final class SuperToastAlignment {
  const SuperToastAlignment(this.alignment, this.stackAxis)
    : assert(
        stackAxis >= -1 && stackAxis <= 1,
        'stackAxis must be between -1 and 1.',
      );

  /// Anchor within the available host viewport.
  final AlignmentGeometry alignment;

  /// Vertical deck-growth transform in the range `[-1, 1]`.
  ///
  /// `1` produces top-edge behavior (toasts enter from above and older cards
  /// grow downward). `-1` produces bottom-edge behavior.
  final double stackAxis;

  static const topStart = SuperToastAlignment(AlignmentDirectional.topStart, 1);
  static const topCenter = SuperToastAlignment(Alignment.topCenter, 1);
  static const topEnd = SuperToastAlignment(AlignmentDirectional.topEnd, 1);
  static const topLeft = SuperToastAlignment(Alignment.topLeft, 1);
  static const topRight = SuperToastAlignment(Alignment.topRight, 1);

  static const bottomStart = SuperToastAlignment(
    AlignmentDirectional.bottomStart,
    -1,
  );
  static const bottomCenter = SuperToastAlignment(Alignment.bottomCenter, -1);
  static const bottomEnd = SuperToastAlignment(
    AlignmentDirectional.bottomEnd,
    -1,
  );
  static const bottomLeft = SuperToastAlignment(Alignment.bottomLeft, -1);
  static const bottomRight = SuperToastAlignment(Alignment.bottomRight, -1);

  /// Adaptive default: top-center for touch layouts, bottom-end for desktop.
  static SuperToastAlignment adaptive(SuperDeviceMode mode) =>
      mode.isDesktop ? bottomEnd : topCenter;

  static SuperToastAlignment fromPosition(
    SuperToastPosition position,
    SuperDeviceMode mode,
  ) => switch (position) {
    SuperToastPosition.adaptive => adaptive(mode),
    SuperToastPosition.topStart => topStart,
    SuperToastPosition.topCenter => topCenter,
    SuperToastPosition.topEnd => topEnd,
    SuperToastPosition.topLeft => topLeft,
    SuperToastPosition.topRight => topRight,
    SuperToastPosition.bottomStart => bottomStart,
    SuperToastPosition.bottomCenter => bottomCenter,
    SuperToastPosition.bottomEnd => bottomEnd,
    SuperToastPosition.bottomLeft => bottomLeft,
    SuperToastPosition.bottomRight => bottomRight,
  };

  /// Resolves directional alignment into a physical placement.
  SuperToastPlacement resolve(TextDirection direction) => SuperToastPlacement(
    alignment: alignment.resolve(direction),
    stackTransform: Offset(0, stackAxis),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperToastAlignment &&
          other.alignment == alignment &&
          other.stackAxis == stackAxis;

  @override
  int get hashCode => Object.hash(alignment, stackAxis);
}

/// Physical placement captured when a toast is inserted into a host.
@immutable
final class SuperToastPlacement {
  const SuperToastPlacement({
    required this.alignment,
    required this.stackTransform,
  });

  final Alignment alignment;
  final Offset stackTransform;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperToastPlacement &&
          other.alignment == alignment &&
          other.stackTransform == stackTransform;

  @override
  int get hashCode => Object.hash(alignment, stackTransform);
}
