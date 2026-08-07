import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';

void main() {
  testWidgets('SuperConfirmView owns confirmation UI and callbacks', (
    tester,
  ) async {
    var confirmed = false;
    var cancelled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [SuperThemeData.light]),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SuperConfirmView(
              title: 'تأكيد الحذف',
              description: 'راجع البيانات قبل المتابعة.',
              content: const Text('الحساب: الصندوق الرئيسي'),
              icon: Icons.delete_outline,
              isDestructive: true,
              confirmLabel: 'حذف',
              cancelLabel: 'إلغاء',
              onConfirm: () => confirmed = true,
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('تأكيد الحذف'), findsOneWidget);
    expect(find.text('راجع البيانات قبل المتابعة.'), findsOneWidget);
    expect(find.text('الحساب: الصندوق الرئيسي'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    await tester.tap(find.text('حذف'));
    expect(confirmed, isTrue);

    await tester.tap(find.text('إلغاء'));
    expect(cancelled, isTrue);
  });

  testWidgets('SuperConfirmDialog composes SuperConfirmView and returns result', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [SuperThemeData.light]),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await SuperConfirmDialog.show(
                  context,
                  title: 'Delete item',
                  description: 'This cannot be undone.',
                  confirmLabel: 'Delete',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(SuperConfirmDialog), findsOneWidget);
    expect(find.byType(SuperConfirmView), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.byType(SuperConfirmDialog), findsNothing);
  });

  testWidgets('SuperFieldView lays out custom content and optional actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark().copyWith(
          extensions: const [SuperThemeData.dark],
        ),
        home: Scaffold(
          body: SuperFieldView(
            title: 'Account fields',
            description: 'Enter the required account data.',
            actions: const [SuperButton(label: 'Save')],
            child: const TextField(key: Key('account-name-field')),
          ),
        ),
      ),
    );

    expect(find.text('Account fields'), findsOneWidget);
    expect(find.text('Enter the required account data.'), findsOneWidget);
    expect(find.byKey(const Key('account-name-field')), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('View actions use the themed footer surface', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.dark(),
        home: const Scaffold(
          body: SuperFieldView(
            title: 'Account fields',
            actions: [SuperButton(label: 'Save')],
            child: Text('Body'),
          ),
        ),
      ),
    );

    final footer = find.byWidgetPredicate((widget) {
      if (widget is! DecoratedBox) return false;
      final decoration = widget.decoration;
      if (decoration is! BoxDecoration) return false;
      final border = decoration.border;
      return decoration.color == SuperThemeData.dark.bg &&
          border is Border &&
          border.top.color == SuperThemeData.dark.border;
    });

    expect(footer, findsOneWidget);
    expect(
      find.descendant(of: footer, matching: find.text('Save')),
      findsOneWidget,
    );
  });

  testWidgets('SuperFieldDialog composes SuperFieldView', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [SuperThemeData.light]),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => SuperFieldDialog.show<void>(
                context,
                title: 'Edit field',
                description: 'Update the value.',
                child: const TextField(key: Key('field-dialog-input')),
              ),
              child: const Text('Open field dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open field dialog'));
    await tester.pumpAndSettle();

    expect(find.byType(SuperFieldDialog), findsOneWidget);
    expect(find.byType(SuperFieldView), findsOneWidget);
    expect(find.byKey(const Key('field-dialog-input')), findsOneWidget);
  });
}
