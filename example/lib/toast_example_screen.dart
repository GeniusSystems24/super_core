import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_core/super_core.dart';

class ToastExampleScreen extends StatefulWidget {
  const ToastExampleScreen({super.key});

  @override
  State<ToastExampleScreen> createState() => _ToastExampleScreenState();
}

class _ToastExampleScreenState extends State<ToastExampleScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<_ToastDocSection, GlobalKey> _sectionKeys = {
    for (final section in _ToastDocSection.values) section: GlobalKey(),
  };

  SuperToastHandle? _handle;

  @override
  void dispose() {
    _handle?.dismiss();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Scaffold(
      appBar: SuperAppBar(
        title: const Text('Toast'),
        subtitle: const Text('Overlay · feedback · transient actions'),
      ),
      body: SuperScaffold(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showRail = constraints.maxWidth >= 1120;
            final pagePadding = t.spacing.pagePadding;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsetsDirectional.only(
                          start: pagePadding.left,
                          end: showRail ? t.spacing.space4 : pagePadding.right,
                          top: pagePadding.top,
                          bottom: pagePadding.bottom,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 860),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _DocHero(
                                    key: _sectionKeys[_ToastDocSection.overview],
                                  ),
                                  SizedBox(height: t.spacing.space5),
                                  if (!showRail) ...[
                                    _MobileToc(
                                      onSelected: _scrollTo,
                                    ),
                                    SizedBox(height: t.spacing.space5),
                                  ],
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.usage],
                                    eyebrow: 'Getting started',
                                    title: 'Usage',
                                    description:
                                        'Wrap the app with SuperToastHost once, then show standard or raw toast entries from any descendant context.',
                                    children: const [
                                      _CodeBlock(
                                        language: 'dart',
                                        code: r'''MaterialApp(
  builder: (context, child) => SuperToastHost(
    child: child!,
  ),
);''',
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.appearance],
                                    eyebrow: 'Examples',
                                    title: 'Appearance',
                                    description:
                                        'Semantic tones share the same Super Core surface, typography, spacing, and motion system.',
                                    children: [
                                      _ExampleCard(
                                        title: 'Semantic tones',
                                        description:
                                            'Use the convenience APIs or pass a SuperToastTone directly.',
                                        code: r'''SuperToast.success(
  context,
  title: 'Journal posted',
  description: 'JV-2026-00842 was posted successfully.',
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('Neutral', () => SuperToast.show(
                                                  context,
                                                  title: 'Preferences saved',
                                                  description:
                                                      'The local display preferences were updated.',
                                                )),
                                            _button('Info', () => SuperToast.info(
                                                  context,
                                                  title: 'Sync in progress',
                                                  description:
                                                      'Fresh ledger data is being synchronized.',
                                                )),
                                            _button('Success', () => SuperToast.success(
                                                  context,
                                                  title: 'Journal posted',
                                                  description:
                                                      'JV-2026-00842 was posted successfully.',
                                                )),
                                            _button('Warning', () => SuperToast.warning(
                                                  context,
                                                  title: 'Review required',
                                                  description:
                                                      'A line is missing its cost center.',
                                                )),
                                            _button('Danger', () => SuperToast.danger(
                                                  context,
                                                  title: 'Posting failed',
                                                  description:
                                                      'The journal is out of balance.',
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.alignment],
                                    eyebrow: 'Placement',
                                    title: 'Alignment',
                                    description:
                                        'Adaptive placement defaults to top-center on touch and bottom-end on desktop. Directional positions resolve automatically in RTL.',
                                    children: [
                                      _ExampleCard(
                                        title: 'Adaptive & directional alignment',
                                        description:
                                            'Try physical, directional, centered, and adaptive positions.',
                                        code: r'''SuperToast.info(
  context,
  title: 'Top end',
  position: SuperToastPosition.topEnd,
);''',
                                        minPreviewHeight: 300,
                                        preview: Wrap(
                                          spacing: t.spacing.space2,
                                          runSpacing: t.spacing.space2,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            for (final position in SuperToastPosition.values)
                                              _button(
                                                _positionLabel(position),
                                                () => SuperToast.info(
                                                  context,
                                                  title: _positionLabel(position),
                                                  position: position,
                                                  duration: const Duration(seconds: 8),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      _ExampleCard(
                                        title: 'Custom alignment',
                                        description:
                                            'Viewport anchor and vertical stack axis can be controlled independently.',
                                        code: r'''SuperToast.info(
  context,
  title: 'Custom alignment',
  alignment: const SuperToastAlignment(
    Alignment(-0.5, -1),
    1,
  ),
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button(
                                              'Between top-left and top-center',
                                              () => SuperToast.info(
                                                context,
                                                title: 'Custom alignment',
                                                alignment: const SuperToastAlignment(
                                                  Alignment(-0.5, -1),
                                                  1,
                                                ),
                                                duration: null,
                                                showCloseButton: true,
                                              ),
                                            ),
                                            _button(
                                              'Custom bottom quarter',
                                              () => SuperToast.success(
                                                context,
                                                title: 'Custom bottom alignment',
                                                alignment: const SuperToastAlignment(
                                                  Alignment(0.5, 1),
                                                  -1,
                                                ),
                                                duration: null,
                                                showCloseButton: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.stack],
                                    eyebrow: 'Interaction',
                                    title: 'Stack & swipe',
                                    description:
                                        'Entries collapse into a depth-aware deck, expand on hover or press, and can be dismissed with placement-aware swipe gestures.',
                                    children: [
                                      _ExampleCard(
                                        title: 'Collapsed stack',
                                        description:
                                            'The newest toast stays at the front. Older cards keep their own intrinsic dimensions and use uniform depth scaling.',
                                        code: r'''for (var i = 1; i <= 5; i++) {
  SuperToast.info(
    context,
    title: 'Stack item #$i',
    description: i == 5
        ? 'Newest card is at the front.'
        : null,
    position: SuperToastPosition.topCenter,
    duration: null,
  );
}''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button(
                                              '5 · Top center',
                                              () => _burst(
                                                context,
                                                SuperToastPosition.topCenter,
                                              ),
                                            ),
                                            _button(
                                              '5 · Bottom end',
                                              () => _burst(
                                                context,
                                                SuperToastPosition.bottomEnd,
                                              ),
                                            ),
                                            _button(
                                              'Dismiss all',
                                              () => SuperToast.dismissAll(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _ExampleCard(
                                        title: 'Swipe-to-dismiss',
                                        description:
                                            'Centered stacks swipe vertically. Corner stacks also allow the horizontal direction toward their edge.',
                                        code: r'''SuperToast.warning(
  context,
  title: 'Only right is enabled',
  swipeToDismiss: const [AxisDirection.right],
  dismissThreshold: 0.5,
  duration: null,
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('Default top-left swipe', () => SuperToast.info(
                                                  context,
                                                  title: 'Swipe up or left',
                                                  position: SuperToastPosition.topLeft,
                                                  duration: null,
                                                )),
                                            _button('Only swipe right', () => SuperToast.warning(
                                                  context,
                                                  title: 'Only right is enabled',
                                                  position: SuperToastPosition.bottomCenter,
                                                  swipeToDismiss: const [AxisDirection.right],
                                                  duration: null,
                                                )),
                                            _button('Swipe disabled', () => SuperToast.show(
                                                  context,
                                                  title: 'Swipe is disabled',
                                                  swipeToDismiss: const [],
                                                  showCloseButton: true,
                                                  duration: null,
                                                )),
                                            _button('Low threshold · 0.2', () => SuperToast.success(
                                                  context,
                                                  title: 'Short swipe dismisses',
                                                  dismissThreshold: 0.2,
                                                  duration: null,
                                                )),
                                            _button('High threshold · 0.8', () => SuperToast.info(
                                                  context,
                                                  title: 'Long swipe required',
                                                  dismissThreshold: 0.8,
                                                  duration: null,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.behavior],
                                    eyebrow: 'Behavior',
                                    title: 'Lifecycle & actions',
                                    description:
                                        'Auto-dismiss, persistence, entry handles, actions, and host expansion policy can be composed independently.',
                                    children: [
                                      _ExampleCard(
                                        title: 'Duration & persistence',
                                        description:
                                            'Hover/press pauses auto-dismiss. Use null or Duration.zero for persistent entries.',
                                        code: r'''SuperToast.info(
  context,
  title: 'Persistent',
  duration: null,
  showCloseButton: true,
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('1 second', () => SuperToast.success(
                                                  context,
                                                  title: 'Short duration',
                                                  duration: const Duration(seconds: 1),
                                                )),
                                            _button('Hover pauses', () => SuperToast.info(
                                                  context,
                                                  title: 'Hover me',
                                                  description:
                                                      'The countdown pauses while interacting.',
                                                  duration: const Duration(seconds: 5),
                                                )),
                                            _button('pauseOnHover: false', () => SuperToast.warning(
                                                  context,
                                                  title:
                                                      'Interaction does not pause this toast',
                                                  pauseOnHover: false,
                                                  duration: const Duration(seconds: 5),
                                                )),
                                            _button('Persistent · null', () => SuperToast.info(
                                                  context,
                                                  title: 'Persistent with null duration',
                                                  duration: null,
                                                  showCloseButton: true,
                                                )),
                                            _button('Persistent · Duration.zero', () => SuperToast.info(
                                                  context,
                                                  title:
                                                      'Backwards-compatible persistent value',
                                                  duration: Duration.zero,
                                                  showCloseButton: true,
                                                )),
                                          ],
                                        ),
                                      ),
                                      _ExampleCard(
                                        title: 'Entry handle',
                                        description:
                                            'Control a live entry programmatically with pause, resume, dismiss, and lifecycle state.',
                                        code: r'''final handle = SuperToast.info(
  context,
  title: 'Controlled entry',
);

handle.pause();
handle.resume();
handle.dismiss();''',
                                        preview: Wrap(
                                          spacing: t.spacing.space2,
                                          runSpacing: t.spacing.space2,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            _button('Create handle', () {
                                              _handle?.dismiss();
                                              _handle = SuperToast.info(
                                                context,
                                                title: 'Controlled entry',
                                                duration: const Duration(seconds: 8),
                                                onDismiss: () {
                                                  if (mounted) setState(() {});
                                                },
                                              );
                                              setState(() {});
                                            }),
                                            _button(
                                              'Pause',
                                              _handle?.isActive == true
                                                  ? () {
                                                      _handle?.pause();
                                                      setState(() {});
                                                    }
                                                  : null,
                                            ),
                                            _button(
                                              'Resume',
                                              _handle?.isActive == true
                                                  ? () {
                                                      _handle?.resume();
                                                      setState(() {});
                                                    }
                                                  : null,
                                            ),
                                            _button(
                                              'Dismiss',
                                              _handle?.isActive == true
                                                  ? () {
                                                      _handle?.dismiss();
                                                      setState(() {});
                                                    }
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      _ExampleCard(
                                        title: 'Suffix & action layouts',
                                        description:
                                            'suffixBuilder receives the live entry. Convenience actions can be leading, trailing, or below.',
                                        code: r'''SuperToast.success(
  context,
  title: 'Event created',
  suffixBuilder: (context, entry) => TextButton(
    onPressed: entry.dismiss,
    child: const Text('Undo'),
  ),
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('suffixBuilder(entry)', () => SuperToast.success(
                                                  context,
                                                  title: 'Event created',
                                                  description:
                                                      'Friday, May 23 at 10:00 AM',
                                                  duration: null,
                                                  suffixBuilder: (context, entry) =>
                                                      TextButton(
                                                    onPressed: entry.dismiss,
                                                    child: const Text('Undo'),
                                                  ),
                                                )),
                                            for (final position
                                                in SuperToastActionPosition.values)
                                              _button(
                                                'Action · ${position.name}',
                                                () => SuperToast.info(
                                                  context,
                                                  title: 'Export queued',
                                                  duration:
                                                      const Duration(seconds: 8),
                                                  action: SuperToastAction(
                                                    label: 'Details',
                                                    position: position,
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const _ExampleCard(
                                        title: 'Expand behavior',
                                        description:
                                            'Each sandbox owns an isolated host/controller so every expansion policy can be exercised safely.',
                                        code: r'''SuperToastHost(
  controller: controller,
  style: const SuperToastHostStyle(
    expandBehavior: SuperToastExpandBehavior.hoverOrPress,
  ),
  child: child,
);''',
                                        minPreviewHeight: 250,
                                        preview: Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            _BehaviorSandbox(
                                              label: 'always',
                                              behavior: SuperToastExpandBehavior.always,
                                            ),
                                            _BehaviorSandbox(
                                              label: 'hoverOrPress',
                                              behavior:
                                                  SuperToastExpandBehavior.hoverOrPress,
                                            ),
                                            _BehaviorSandbox(
                                              label: 'disabled',
                                              behavior: SuperToastExpandBehavior.disabled,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.advanced],
                                    eyebrow: 'Advanced',
                                    title: 'Raw content & customization',
                                    description:
                                        'Keep host behavior while replacing the standard surface, overriding appearance, or using the controller directly.',
                                    children: [
                                      _ExampleCard(
                                        title: 'Raw toast content',
                                        description:
                                            'showRaw preserves positioning, stack animation, timers, semantics, and swipe behavior.',
                                        code: r'''SuperToast.showRaw(
  context,
  data: const SuperToastData(
    title: 'Raw custom toast',
    duration: null,
  ),
  builder: (context, entry) => YourWidget(),
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('Raw widget', () => SuperToast.showRaw(
                                                  context,
                                                  data: const SuperToastData(
                                                    title: 'Raw custom toast',
                                                    duration:
                                                        Duration(seconds: 8),
                                                  ),
                                                  builder: (context, entry) {
                                                    final t = context.superTheme;
                                                    return Material(
                                                      color: t.tokens.accent,
                                                      borderRadius: t.spacing
                                                          .borderRadiusCard,
                                                      child: Padding(
                                                        padding:
                                                            t.spacing.cardPadding,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons.bolt_rounded,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  t.spacing.space2,
                                                            ),
                                                            const Text(
                                                              'Completely custom content',
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  t.spacing.space2,
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  entry.dismiss,
                                                              child: const Text(
                                                                'Close',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )),
                                            _button('Raw SelectableText', () => SuperToast.showRaw(
                                                  context,
                                                  data: const SuperToastData(
                                                    title: 'Selectable content',
                                                    duration: null,
                                                  ),
                                                  builder: (_, entry) => Material(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(12),
                                                      child: SelectableText(
                                                        'INV-2026-000184 · long-press/select me',
                                                        onTap: entry.dismiss,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      _ExampleCard(
                                        title: 'Surface & motion overrides',
                                        description:
                                            'The default remains Super Core. Per-toast decoration, blur, clipping, constraints, spacing, and motion can be overridden.',
                                        code: r'''SuperToast.info(
  context,
  title: 'Background filter',
  style: SuperToastStyle(
    backgroundFilter: ImageFilter.blur(
      sigmaX: 8,
      sigmaY: 8,
    ),
  ),
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('Blurred / translucent', () {
                                              final t = context.superTheme;
                                              SuperToast.info(
                                                context,
                                                title: 'Background filter',
                                                description:
                                                    'BackdropFilter is supported by the standard surface.',
                                                duration: null,
                                                showCloseButton: true,
                                                style: SuperToastStyle(
                                                  decoration: BoxDecoration(
                                                    color: t.surface.withValues(
                                                      alpha: 0.72,
                                                    ),
                                                    border: Border.all(
                                                      color: t.border,
                                                    ),
                                                    borderRadius: t
                                                        .spacing.borderRadiusCard,
                                                  ),
                                                  backgroundFilter:
                                                      ImageFilter.blur(
                                                    sigmaX: 8,
                                                    sigmaY: 8,
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                ),
                                              );
                                            }),
                                            _button('No entrance fade', () => SuperToast.warning(
                                                  context,
                                                  title: 'Motion override',
                                                  style: const SuperToastStyle(
                                                    motion: SuperToastMotion(
                                                      fadeOnEntrance: false,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      const _ExampleCard(
                                        title: 'Direct controller + immutable model',
                                        description:
                                            'Use the MVC pieces directly inside an isolated SuperToastHost.',
                                        code: r'''const data = SuperToastData(
  title: 'Direct MVC entry',
  tone: SuperToastTone.success,
  duration: null,
);

controller.show(
  context,
  data,
  builder: (context, entry) => SuperToastView(
    data: data,
    handle: entry,
  ),
);''',
                                        preview: _DirectControllerSandbox(),
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.accessibility],
                                    eyebrow: 'Internationalization & a11y',
                                    title: 'RTL & accessibility',
                                    description:
                                        'Directional placement follows text direction. Toasts expose live-region semantics and respect accessible navigation / reduced-motion settings.',
                                    children: [
                                      const _ExampleCard(
                                        title: 'RTL placement',
                                        description:
                                            'topStart and bottomEnd resolve physically from the local Directionality.',
                                        code: r'''Directionality(
  textDirection: TextDirection.rtl,
  child: Builder(
    builder: (context) => SuperButton(
      onPressed: () => SuperToast.warning(
        context,
        title: 'تحتاج العملية إلى مراجعة',
        position: SuperToastPosition.topStart,
      ),
    ),
  ),
);''',
                                        preview: _RtlScenario(),
                                      ),
                                      _ExampleCard(
                                        title: 'Accessible announcement',
                                        description:
                                            'Semantics expose a live region and dismiss action. Accessible navigation prevents auto-dismiss.',
                                        code: r'''SuperToast.info(
  context,
  title: 'Screen-reader announcement',
  description: 'This toast is exposed as a live region.',
  duration: null,
  showCloseButton: true,
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button(
                                              'Persistent semantics example',
                                              () => SuperToast.info(
                                                context,
                                                title:
                                                    'Screen-reader announcement',
                                                description:
                                                    'This toast is exposed as a live region.',
                                                duration: null,
                                                showCloseButton: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _sectionGap(context),
                                  _DocSection(
                                    key: _sectionKeys[_ToastDocSection.cleanup],
                                    eyebrow: 'Utilities',
                                    title: 'Dismissal & cleanup',
                                    description:
                                        'Body dismissal is opt-in, the close affordance is optional, and independent placements can coexist before a global cleanup.',
                                    children: [
                                      _ExampleCard(
                                        title: 'Dismiss controls',
                                        description:
                                            'Choose body tap, an explicit close affordance, swipe, auto-dismiss, or programmatic dismissal.',
                                        code: r'''SuperToast.info(
  context,
  title: 'Tap this toast body',
  dismissible: true,
  duration: null,
);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('Tap body to dismiss', () => SuperToast.info(
                                                  context,
                                                  title: 'Tap this toast body',
                                                  dismissible: true,
                                                  duration: null,
                                                )),
                                            _button('Close button', () => SuperToast.info(
                                                  context,
                                                  title: 'Explicit close affordance',
                                                  showCloseButton: true,
                                                  duration: null,
                                                )),
                                            _button('Neither', () => SuperToast.info(
                                                  context,
                                                  title:
                                                      'Use swipe or programmatic dismiss',
                                                  duration:
                                                      const Duration(seconds: 8),
                                                )),
                                          ],
                                        ),
                                      ),
                                      _ExampleCard(
                                        title: 'Multiple placements',
                                        description:
                                            'Populate independent corner stacks and dismiss every live entry in one call.',
                                        code: r'''for (final position in positions) {
  SuperToast.info(
    context,
    title: position.name,
    position: position,
    duration: null,
  );
}

SuperToast.dismissAll(context);''',
                                        preview: _PreviewColumn(
                                          children: [
                                            _button('Populate all physical corners', () {
                                              for (final position in const [
                                                SuperToastPosition.topLeft,
                                                SuperToastPosition.topRight,
                                                SuperToastPosition.bottomLeft,
                                                SuperToastPosition.bottomRight,
                                              ]) {
                                                for (var i = 1; i <= 3; i++) {
                                                  SuperToast.info(
                                                    context,
                                                    title:
                                                        '${_positionLabel(position)} #$i',
                                                    position: position,
                                                    duration: null,
                                                  );
                                                }
                                              }
                                            }),
                                            _button(
                                              'SuperToast.dismissAll(context)',
                                              () => SuperToast.dismissAll(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: t.spacing.space8),
                                  const _DocFooter(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showRail)
                  SizedBox(
                    width: 240,
                    child: _DesktopToc(
                      onSelected: _scrollTo,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _scrollTo(_ToastDocSection section) {
    final target = _sectionKeys[section]?.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: 0.04,
    );
  }

  Widget _button(String label, VoidCallback? onPressed) => SuperButton(
        label: label,
        variant: SuperButtonVariant.secondary,
        onPressed: onPressed,
      );

  Widget _sectionGap(BuildContext context) =>
      SizedBox(height: context.superTheme.spacing.space8);

  void _burst(BuildContext context, SuperToastPosition position) {
    for (var i = 1; i <= 5; i++) {
      SuperToast.info(
        context,
        title: 'Stack item #$i',
        description: i == 5 ? 'Newest card is at the front.' : null,
        position: position,
        duration: null,
      );
    }
  }

  String _positionLabel(SuperToastPosition position) => switch (position) {
        SuperToastPosition.adaptive => 'Adaptive',
        SuperToastPosition.topStart => 'Top start',
        SuperToastPosition.topCenter => 'Top center',
        SuperToastPosition.topEnd => 'Top end',
        SuperToastPosition.topLeft => 'Top left',
        SuperToastPosition.topRight => 'Top right',
        SuperToastPosition.bottomStart => 'Bottom start',
        SuperToastPosition.bottomCenter => 'Bottom center',
        SuperToastPosition.bottomEnd => 'Bottom end',
        SuperToastPosition.bottomLeft => 'Bottom left',
        SuperToastPosition.bottomRight => 'Bottom right',
      };
}

enum _ToastDocSection {
  overview('Overview'),
  usage('Usage'),
  appearance('Appearance'),
  alignment('Alignment'),
  stack('Stack & swipe'),
  behavior('Behavior'),
  advanced('Advanced'),
  accessibility('RTL & accessibility'),
  cleanup('Cleanup');

  const _ToastDocSection(this.label);
  final String label;
}

class _DocHero extends StatelessWidget {
  const _DocHero({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _DocBadge(
              icon: Icons.layers_outlined,
              label: 'Overlay',
              color: t.tokens.accent,
            ),
            SizedBox(width: t.spacing.space2),
            _DocBadge(
              icon: Icons.accessibility_new_outlined,
              label: 'Accessible',
              color: t.tokens.info,
            ),
          ],
        ),
        SizedBox(height: t.spacing.space4),
        Text(
          'Toast',
          style: text.displayLg.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
          ),
        ),
        SizedBox(height: t.spacing.space2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'A transient overlay for feedback, status, and reversible actions. SuperToast combines Super Core styling with responsive stacking, swipe dismissal, rich lifecycle control, and accessibility-aware motion.',
            style: text.bodyLg.copyWith(
              color: t.fg3,
              height: 1.55,
            ),
          ),
        ),
        SizedBox(height: t.spacing.space4),
        Wrap(
          spacing: t.spacing.space2,
          runSpacing: t.spacing.space2,
          children: const [
            _ApiPill('SuperToast'),
            _ApiPill('SuperToastHost'),
            _ApiPill('SuperToastHandle'),
            _ApiPill('SuperToastStyle'),
          ],
        ),
      ],
    );
  }
}

class _DocSection extends StatelessWidget {
  const _DocSection({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.children,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: text.eyebrow.copyWith(
            color: t.tokens.accent,
            letterSpacing: context.isRtl ? 0 : 1.25,
          ),
        ),
        SizedBox(height: t.spacing.space1),
        Text(
          title,
          style: text.headlineSm.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: t.spacing.space2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            description,
            style: text.bodySm.copyWith(
              color: t.fg3,
              height: 1.55,
            ),
          ),
        ),
        SizedBox(height: t.spacing.space4),
        ..._separated(children, SizedBox(height: t.spacing.space4)),
      ],
    );
  }
}

class _ExampleCard extends StatefulWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.code,
    required this.preview,
    this.minPreviewHeight = 220,
  });

  final String title;
  final String description;
  final String code;
  final Widget preview;
  final double minPreviewHeight;

  @override
  State<_ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<_ExampleCard> {
  var _tab = _ExampleTab.preview;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: text.titleMd.copyWith(
            color: t.fg1,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: t.spacing.space1),
        Text(
          widget.description,
          style: text.bodySm.copyWith(
            color: t.fg3,
            height: 1.45,
          ),
        ),
        SizedBox(height: t.spacing.space3),
        DecoratedBox(
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: t.border),
            borderRadius: t.spacing.cardBorderRadius,
            boxShadow: t.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: t.spacing.cardBorderRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ExampleTabs(
                  selected: _tab,
                  onChanged: (value) => setState(() => _tab = value),
                ),
                Divider(height: 1, thickness: 1, color: t.border),
                AnimatedSwitcher(
                  duration: t.tokens.durBase,
                  switchInCurve: t.tokens.curveStandard,
                  switchOutCurve: t.tokens.curveStandard,
                  child: _tab == _ExampleTab.preview
                      ? ConstrainedBox(
                          key: const ValueKey('preview'),
                          constraints: BoxConstraints(
                            minHeight: widget.minPreviewHeight,
                          ),
                          child: _PreviewSurface(child: widget.preview),
                        )
                      : _CodeBlock(
                          key: const ValueKey('code'),
                          code: widget.code,
                          language: 'dart',
                          embedded: true,
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _ExampleTab { preview, code }

class _ExampleTabs extends StatelessWidget {
  const _ExampleTabs({required this.selected, required this.onChanged});

  final _ExampleTab selected;
  final ValueChanged<_ExampleTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: t.spacing.space2,
        end: t.spacing.space2,
        top: t.spacing.space1,
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'Preview',
            selected: selected == _ExampleTab.preview,
            onTap: () => onChanged(_ExampleTab.preview),
          ),
          _TabButton(
            label: 'Code',
            selected: selected == _ExampleTab.code,
            onTap: () => onChanged(_ExampleTab.code),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: t.spacing.pillBorderRadius,
      child: AnimatedContainer(
        duration: t.tokens.durFast,
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.space3,
          vertical: t.spacing.space2,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? t.tokens.accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: context.superTextTheme.labelSm.copyWith(
            color: selected ? t.fg1 : t.fg3,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PreviewSurface extends StatelessWidget {
  const _PreviewSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(t.spacing.space5),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          t.tokens.accent.withValues(alpha: 0.018),
          t.bg,
        ),
      ),
      child: child,
    );
  }
}

class _PreviewColumn extends StatelessWidget {
  const _PreviewColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = context.superTheme.spacing.space2;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _separated(children, SizedBox(height: gap)),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.embedded = false,
  });

  final String code;
  final String language;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    final body = Container(
      width: double.infinity,
      color: Color.alphaBlend(
        t.fg1.withValues(alpha: 0.025),
        t.bg,
      ),
      padding: EdgeInsetsDirectional.fromSTEB(
        t.spacing.space4,
        t.spacing.space3,
        t.spacing.space3,
        t.spacing.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                language,
                style: context.superTextTheme.eyebrow.copyWith(
                  color: t.fg4,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Copy code',
                visualDensity: VisualDensity.compact,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Code copied'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  Icons.content_copy_rounded,
                  size: 16,
                  color: t.fg3,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.space2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              code,
              style: TextStyle(
                color: t.fg2,
                fontSize: 13,
                height: 1.55,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );

    if (embedded) return body;

    return ClipRRect(
      borderRadius: t.spacing.cardBorderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: t.border),
          borderRadius: t.spacing.cardBorderRadius,
        ),
        child: body,
      ),
    );
  }
}

class _DesktopToc extends StatelessWidget {
  const _DesktopToc({required this.onSelected});

  final ValueChanged<_ToastDocSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: t.border),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(
          t.spacing.space4,
          t.spacing.space6,
          t.spacing.space4,
          t.spacing.space6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On this page',
              style: context.superTextTheme.labelMd.copyWith(
                color: t.fg1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: t.spacing.space3),
            for (final section in _ToastDocSection.values)
              _TocButton(
                label: section.label,
                onTap: () => onSelected(section),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileToc extends StatelessWidget {
  const _MobileToc({required this.onSelected});

  final ValueChanged<_ToastDocSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On this page',
              style: context.superTextTheme.labelMd.copyWith(
                color: t.fg1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: t.spacing.space2),
            Wrap(
              spacing: t.spacing.space1,
              runSpacing: t.spacing.space1,
              children: [
                for (final section in _ToastDocSection.values)
                  ActionChip(
                    label: Text(section.label),
                    onPressed: () => onSelected(section),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TocButton extends StatelessWidget {
  const _TocButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: t.spacing.pillBorderRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.space2,
          vertical: t.spacing.space2,
        ),
        child: Text(
          label,
          style: context.superTextTheme.bodySm.copyWith(color: t.fg3),
        ),
      ),
    );
  }
}

class _DocBadge extends StatelessWidget {
  const _DocBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space2,
        vertical: t.spacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.20)),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: t.spacing.space1),
          Text(
            label,
            style: context.superTextTheme.labelSm.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiPill extends StatelessWidget {
  const _ApiPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space2,
        vertical: t.spacing.space1,
      ),
      decoration: BoxDecoration(
        color: t.selectionFill(0.12),
        borderRadius: t.spacing.pillBorderRadius,
      ),
      child: Text(
        label,
        style: context.superTextTheme.labelSm.copyWith(
          color: t.fg2,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _DocFooter extends StatelessWidget {
  const _DocFooter();

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: EdgeInsets.all(t.spacing.space4),
      decoration: BoxDecoration(
        color: t.selectionFill(0.08),
        border: Border.all(color: t.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: t.tokens.accent),
          SizedBox(width: t.spacing.space3),
          Expanded(
            child: Text(
              'All examples are live. Toast overlays are rendered by the nearest SuperToastHost and remain theme-aware while they are visible.',
              style: context.superTextTheme.bodySm.copyWith(
                color: t.fg3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _separated(List<Widget> children, Widget separator) {
  if (children.length < 2) return children;
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) separator,
      children[i],
    ],
  ];
}

class _BehaviorSandbox extends StatefulWidget {
  const _BehaviorSandbox({required this.label, required this.behavior});

  final String label;
  final SuperToastExpandBehavior behavior;

  @override
  State<_BehaviorSandbox> createState() => _BehaviorSandboxState();
}

class _BehaviorSandboxState extends State<_BehaviorSandbox> {
  final SuperToastController _controller = SuperToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return SizedBox(
      width: 220,
      height: 190,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: t.border),
          borderRadius: t.spacing.borderRadiusCard,
        ),
        child: SuperToastHost(
          controller: _controller,
          style: SuperToastHostStyle(
            expandBehavior: widget.behavior,
            alignment: SuperToastAlignment.topCenter,
          ),
          child: Builder(
            builder: (hostContext) => Center(
              child: SuperButton(
                label: widget.label,
                variant: SuperButtonVariant.secondary,
                onPressed: () {
                  for (var i = 1; i <= 3; i++) {
                    SuperToast.info(
                      hostContext,
                      title: '${widget.label} #$i',
                      duration: null,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DirectControllerSandbox extends StatefulWidget {
  const _DirectControllerSandbox();

  @override
  State<_DirectControllerSandbox> createState() =>
      _DirectControllerSandboxState();
}

class _DirectControllerSandboxState extends State<_DirectControllerSandbox> {
  final SuperToastController _controller = SuperToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 320,
    height: 190,
    child: SuperToastHost(
      controller: _controller,
      style: const SuperToastHostStyle(
        alignment: SuperToastAlignment.topCenter,
      ),
      child: Builder(
        builder: (hostContext) => Center(
          child: SuperButton(
            label: 'controller.show(data)',
            variant: SuperButtonVariant.secondary,
            onPressed: () {
              const data = SuperToastData(
                title: 'Direct MVC entry',
                description: 'Built from SuperToastData + controller.',
                tone: SuperToastTone.success,
                duration: null,
              );
              _controller.show(
                hostContext,
                data,
                defaultAlignment: SuperToastAlignment.topCenter,
                builder: (context, entry) => SuperToastView(
                  data: data,
                  handle: entry,
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _RtlScenario extends StatelessWidget {
  const _RtlScenario();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Builder(
      builder: (rtlContext) => Wrap(
        spacing: rtlContext.superTheme.spacing.space2,
        children: [
          SuperButton(
            label: 'أعلى البداية',
            variant: SuperButtonVariant.secondary,
            onPressed: () => SuperToast.warning(
              rtlContext,
              title: 'تحتاج العملية إلى مراجعة',
              description: 'تم وضع الإشعار حسب اتجاه النص.',
              position: SuperToastPosition.topStart,
              duration: null,
              showCloseButton: true,
            ),
          ),
          SuperButton(
            label: 'أسفل النهاية',
            variant: SuperButtonVariant.secondary,
            onPressed: () => SuperToast.info(
              rtlContext,
              title: 'تم تحديث البيانات',
              position: SuperToastPosition.bottomEnd,
              duration: null,
              showCloseButton: true,
            ),
          ),
        ],
      ),
    ),
  );
}
