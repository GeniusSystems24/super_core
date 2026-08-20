import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/super_semantic_colors.dart';
import '../../../../core/widgets/super_button.dart';
import '../../domain/entities/super_toast_data.dart';
import '../controllers/super_toast_controller.dart';
import '../models/super_toast_action.dart';
import '../models/super_toast_style.dart';

/// Standard Super design-system toast surface.
///
/// Animation, timers, semantics live-region behavior, and swipe gestures are
/// intentionally owned by the host/animated wrapper rather than this view.
class SuperToastView extends StatelessWidget {
  const SuperToastView({
    required this.data,
    required this.handle,
    this.style = const SuperToastStyle(),
    this.icon,
    this.action,
    this.suffix,
    super.key,
  });

  final SuperToastData data;
  final SuperToastHandle handle;
  final SuperToastStyle style;
  final Widget? icon;
  final SuperToastAction? action;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final resolved = style.resolve(context);
    final semantic = SuperSemanticColors.of(context);
    final tone = _resolveTone(data.tone, semantic);
    final description = data.description?.trim();

    final content = Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            maxLines: 100,
            style: context.superTextTheme.titleMd.copyWith(color: t.fg1),
          ),
          if (description != null && description.isNotEmpty) ...[
            SizedBox(height: resolved.titleSpacing),
            Text(
              description,
              maxLines: 100,
              style: context.superTextTheme.body.copyWith(color: t.fg3),
            ),
          ],
          if (action?.position == SuperToastActionPosition.below) ...[
            SizedBox(height: t.spacing.space2),
            _ToastActionButton(
              action: action!,
              tone: tone,
              handle: handle,
            ),
          ],
        ],
      ),
    );

    Widget surface = DecoratedBox(
      decoration: resolved.decoration,
      child: Padding(
        padding: resolved.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (action?.position == SuperToastActionPosition.leading) ...[
              _ToastActionButton(
                action: action!,
                tone: tone,
                handle: handle,
              ),
              SizedBox(width: resolved.suffixSpacing),
            ],
            IconTheme(
              data: resolved.iconTheme.copyWith(color: tone.solid),
              child: icon ?? Icon(_defaultIcon(data.tone)),
            ),
            SizedBox(width: resolved.iconSpacing),
            content,
            if (action?.position == SuperToastActionPosition.trailing) ...[
              SizedBox(width: resolved.suffixSpacing),
              _ToastActionButton(
                action: action!,
                tone: tone,
                handle: handle,
              ),
            ],
            if (suffix != null) ...[
              SizedBox(width: resolved.suffixSpacing),
              suffix!,
            ],
            if (data.showCloseButton) ...[
              SizedBox(width: resolved.suffixSpacing),
              SuperIconButton(
                icon: Icons.close_rounded,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: handle.dismiss,
              ),
            ],
          ],
        ),
      ),
    );

    final radius = resolved.resolveBorderRadius(context);
    if (resolved.backgroundFilter case final filter?) {
      surface = Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: filter,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          surface,
        ],
      );
    }

    if (resolved.clipBehavior != Clip.none) {
      surface = ClipRRect(
        borderRadius: radius,
        clipBehavior: resolved.clipBehavior,
        child: surface,
      );
    }

    if (data.dismissible) {
      surface = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: handle.dismiss,
        child: surface,
      );
    }

    final semanticsLabel = description == null || description.isEmpty
        ? data.title
        : '${data.title}. $description';

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: surface,
    );
  }

  static SuperSemanticColor _resolveTone(
    SuperToastTone tone,
    SuperSemanticColors colors,
  ) => switch (tone) {
    SuperToastTone.neutral => colors.neutral,
    SuperToastTone.info => colors.info,
    SuperToastTone.success => colors.success,
    SuperToastTone.warning => colors.warning,
    SuperToastTone.danger => colors.danger,
  };

  static IconData _defaultIcon(SuperToastTone tone) => switch (tone) {
    SuperToastTone.neutral => Icons.notifications_none_rounded,
    SuperToastTone.info => Icons.info_outline_rounded,
    SuperToastTone.success => Icons.check_circle_outline_rounded,
    SuperToastTone.warning => Icons.warning_amber_rounded,
    SuperToastTone.danger => Icons.error_outline_rounded,
  };
}

class _ToastActionButton extends StatelessWidget {
  const _ToastActionButton({
    required this.action,
    required this.tone,
    required this.handle,
  });

  final SuperToastAction action;
  final SuperSemanticColor tone;
  final SuperToastHandle handle;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: tone.solid,
        backgroundColor: tone.subtle,
        side: BorderSide(color: tone.border),
        textStyle: context.superTextTheme.button,
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.space2,
          vertical: t.spacing.space1,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: t.spacing.borderRadiusMd,
        ),
      ),
      onPressed: () {
        action.onPressed();
        if (action.dismissAfterAction) handle.dismiss();
      },
      child: Text(action.label),
    );
  }
}
