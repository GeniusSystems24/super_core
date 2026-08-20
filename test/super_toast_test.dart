import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  tearDown(() {
    SuperToast.controller.dismissAll(immediate: true);
  });

  group('alignment', () {
    test('adaptive placement follows Super device mode', () {
      expect(
        SuperToastAlignment.adaptive(SuperDeviceMode.mobile),
        SuperToastAlignment.topCenter,
      );
      expect(
        SuperToastAlignment.adaptive(SuperDeviceMode.tablet),
        SuperToastAlignment.topCenter,
      );
      expect(
        SuperToastAlignment.adaptive(SuperDeviceMode.desktop),
        SuperToastAlignment.bottomEnd,
      );
    });

    test('directional positions resolve in LTR and RTL', () {
      expect(
        SuperToastAlignment.topStart.resolve(TextDirection.ltr).alignment,
        Alignment.topLeft,
      );
      expect(
        SuperToastAlignment.topStart.resolve(TextDirection.rtl).alignment,
        Alignment.topRight,
      );
      expect(
        SuperToastAlignment.bottomEnd.resolve(TextDirection.rtl).alignment,
        Alignment.bottomLeft,
      );
    });
  });

  testWidgets('requires a SuperToastHost ancestor', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      () => SuperToast.info(context, title: 'missing host'),
      throwsA(isA<FlutterError>()),
    );
  });

  testWidgets('shows and auto-dismisses', (tester) async {
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => SuperToast.info(
            context,
            title: 'auto toast',
            duration: const Duration(seconds: 1),
          ),
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(find.text('auto toast'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('auto toast'), findsNothing);
  });

  testWidgets('null duration and Duration.zero are persistent', (tester) async {
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => Row(
          children: [
            TextButton(
              onPressed: () => SuperToast.info(
                context,
                title: 'null persistent',
                duration: null,
              ),
              child: const Text('null'),
            ),
            TextButton(
              onPressed: () => SuperToast.info(
                context,
                title: 'zero persistent',
                duration: Duration.zero,
              ),
              child: const Text('zero'),
            ),
          ],
        ),
      ),
    ));

    await tester.tap(find.text('null'));
    await tester.tap(find.text('zero'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();

    expect(find.text('null persistent'), findsOneWidget);
    expect(find.text('zero persistent'), findsOneWidget);
  });

  testWidgets('hover pauses auto-dismiss and exit restarts duration', (
    tester,
  ) async {
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => SuperToast.info(
            context,
            title: 'hover toast',
            duration: const Duration(seconds: 1),
          ),
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    final gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(tester.getCenter(find.text('hover toast')));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('hover toast'), findsOneWidget);

    await gesture.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('hover toast'), findsNothing);
  });

  testWidgets('pauseOnHover false keeps the timer running', (tester) async {
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => SuperToast.info(
            context,
            title: 'not paused',
            duration: const Duration(seconds: 1),
            pauseOnHover: false,
          ),
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    final gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(tester.getCenter(find.text('not paused')));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('not paused'), findsNothing);
  });

  testWidgets('handle pause/resume/dismiss works', (tester) async {
    late SuperToastHandle handle;
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () {
            handle = SuperToast.info(
              context,
              title: 'handled',
              duration: const Duration(seconds: 1),
            );
            handle.pause();
          },
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(handle.isActive, isTrue);
    expect(handle.isPaused, isTrue);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('handled'), findsOneWidget);

    handle.resume();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(handle.isActive, isFalse);

    // Recreate and explicitly dismiss.
    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    handle.dismiss();
    await tester.pumpAndSettle();
    expect(find.text('handled'), findsNothing);
  });

  group('swipe to dismiss', () {
    testWidgets('default top-left accepts up/left', (tester) async {
      await tester.pumpWidget(_swipeApp(
        position: SuperToastPosition.topLeft,
      ));
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      await tester.drag(find.text('swipe me'), const Offset(-260, 0));
      await tester.pumpAndSettle();
      expect(find.text('swipe me'), findsNothing);
    });

    testWidgets('wrong direction snaps back', (tester) async {
      await tester.pumpWidget(_swipeApp(
        position: SuperToastPosition.topLeft,
      ));
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      await tester.drag(find.text('swipe me'), const Offset(260, 0));
      await tester.pumpAndSettle();
      expect(find.text('swipe me'), findsOneWidget);
    });

    testWidgets('empty directions disable swipe', (tester) async {
      await tester.pumpWidget(_swipeApp(
        position: SuperToastPosition.bottomCenter,
        swipeToDismiss: const <AxisDirection>[],
      ));
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      await tester.drag(find.text('swipe me'), const Offset(0, 260));
      await tester.pumpAndSettle();
      expect(find.text('swipe me'), findsOneWidget);
    });

    testWidgets('dismiss threshold is honored', (tester) async {
      await tester.pumpWidget(_swipeApp(
        position: SuperToastPosition.topCenter,
        dismissThreshold: 0.8,
      ));
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      await tester.drag(find.text('swipe me'), const Offset(0, -30));
      await tester.pumpAndSettle();
      expect(find.text('swipe me'), findsOneWidget);
    });
  });

  testWidgets('suffix builder receives an entry that can dismiss', (
    tester,
  ) async {
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => SuperToast.success(
            context,
            title: 'with suffix',
            duration: null,
            suffixBuilder: (_, entry) => TextButton(
              onPressed: entry.dismiss,
              child: const Text('undo'),
            ),
          ),
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    expect(find.text('with suffix'), findsOneWidget);
    await tester.tap(find.text('undo'));
    await tester.pumpAndSettle();
    expect(find.text('with suffix'), findsNothing);
  });

  testWidgets('showRaw supports SelectableText under an Overlay', (
    tester,
  ) async {
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => SuperToast.showRaw(
            context,
            data: const SuperToastData(
              title: 'raw semantics',
              duration: null,
            ),
            builder: (_, __) => const Material(
              child: SelectableText('selectable raw'),
            ),
          ),
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    await tester.longPress(find.text('selectable raw'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('accessibility', () {
    testWidgets('toast is a live region with dismiss semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_app(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => SuperToast.info(
              context,
              title: 'semantic toast',
              duration: null,
            ),
            child: const Text('show'),
          ),
        ),
      ));

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      var node = tester.getSemantics(find.text('semantic toast'));
      while (!node.getSemanticsData().flagsCollection.isLiveRegion) {
        node = node.parent!;
      }
      final data = node.getSemanticsData();
      expect(data.flagsCollection.isLiveRegion, isTrue);
      expect(data.hasAction(SemanticsAction.dismiss), isTrue);
      semantics.dispose();
    });

    testWidgets('accessible navigation disables auto-dismiss', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(accessibleNavigation: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await tester.pumpWidget(_app(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => SuperToast.info(
              context,
              title: 'accessible toast',
              duration: const Duration(seconds: 1),
            ),
            child: const Text('show'),
          ),
        ),
      ));

      await tester.tap(find.text('show'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('accessible toast'), findsOneWidget);
    });
  });

  testWidgets('onDismiss fires once after dismissal completes', (tester) async {
    var calls = 0;
    late SuperToastHandle handle;
    await tester.pumpWidget(_app(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () {
            handle = SuperToast.info(
              context,
              title: 'callback toast',
              duration: null,
              onDismiss: () => calls++,
            );
          },
          child: const Text('show'),
        ),
      ),
    ));

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
    handle.dismiss();
    handle.dismiss();
    await tester.pumpAndSettle();
    expect(calls, 1);
  });
}

Widget _swipeApp({
  required SuperToastPosition position,
  List<AxisDirection>? swipeToDismiss,
  double dismissThreshold = 0.5,
}) => _app(
  child: Builder(
    builder: (context) => TextButton(
      onPressed: () => SuperToast.info(
        context,
        title: 'swipe me',
        position: position,
        duration: null,
        swipeToDismiss: swipeToDismiss,
        dismissThreshold: dismissThreshold,
      ),
      child: const Text('show'),
    ),
  ),
);

Widget _app({
  required Widget child,
  SuperToastHostStyle style = const SuperToastHostStyle(),
}) => MaterialApp(
  theme: SuperMaterialThemeData.light(
    textTheme: _testTypography,
    primaryTextTheme: _testTypography,
  ),
  builder: (context, appChild) => SuperToastHost(
    style: style,
    child: appChild ?? const SizedBox.shrink(),
  ),
  home: Scaffold(body: Center(child: child)),
);

final _testTypography = SuperTextTheme(
  bodyFont: const TextStyle(fontFamily: 'TestBody'),
  otherFont: const TextStyle(fontFamily: 'TestDisplay'),
);
