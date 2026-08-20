// GENERATED DOCS-LAYOUT MIGRATION: super_core example docs v1
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
/// Demonstrates the reusable confirmation and field View/Dialog pairs.
///
/// The inline examples use [SuperConfirmView] and [SuperFieldView] directly,
/// while the modal actions show how the thin dialog wrappers reuse those same
/// view implementations.
class DialogViewsExampleScreen extends StatefulWidget {
  const DialogViewsExampleScreen({super.key});

  @override
  State<DialogViewsExampleScreen> createState() =>
      _DialogViewsExampleScreenState();
}

class _DialogViewsExampleScreenState extends State<DialogViewsExampleScreen> {
  final _inlineNameController = TextEditingController(text: 'Downtown Store');
  final _dialogNameController = TextEditingController(text: 'Main Warehouse');

  @override
  void dispose() {
    _inlineNameController.dispose();
    _dialogNameController.dispose();
    super.dispose();
  }

  Future<void> _showConfirmDialog() async {
    final confirmed = await SuperConfirmDialog.show(
      context,
      title: 'Post journal entry?',
      description:
          'Review the entry before posting. Posted entries are treated as final.',
      icon: Icons.fact_check_outlined,
      confirmLabel: 'Post Entry',
      confirmIcon: const Icon(Icons.check),
      content: const _EntrySummary(),
    );

    if (!mounted) return;
    if (confirmed) {
      SuperSnackBar.success(context, 'Journal entry posted successfully.');
    }
  }

  Future<void> _showDestructiveDialog() async {
    final confirmed = await SuperConfirmDialog.show(
      context,
      title: 'Delete this store?',
      description:
          'This removes the store from active records. Confirm only when the store is no longer needed.',
      icon: Icons.delete_outline,
      confirmLabel: 'Delete Store',
      confirmIcon: const Icon(Icons.delete_outline),
      isDestructive: true,
      content: const _StoreSummary(),
    );

    if (!mounted) return;
    if (confirmed) {
      SuperSnackBar.danger(context, 'Store deletion confirmed.');
    }
  }

  Future<void> _showFieldDialog() async {
    final value = await SuperFieldDialog.show<String>(
      context,
      title: 'Edit warehouse name',
      description: 'Update the display name used across inventory screens.',
      child: FieldShell(
        label: 'Warehouse name',
        required: true,
        hint: 'Use a clear operational name.',
        child: TextField(
          controller: _dialogNameController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            hintText: 'e.g. Main Warehouse',
          ),
        ),
      ),
      actions: [
        SuperButton(
          label: 'Cancel',
          variant: SuperButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        SuperButton(
          label: 'Save',
          icon: const Icon(Icons.save_outlined),
          onPressed: () => Navigator.of(context).pop(
            _dialogNameController.text.trim(),
          ),
        ),
      ],
    );

    if (!mounted || value == null || value.isEmpty) return;
    SuperSnackBar.success(context, 'Saved warehouse name: $value');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    final content = <Widget>[
            _ExampleCard(
              title: 'SuperConfirmView',
              description: 'Inline confirmation UI reused by the dialog.',
              child: SuperConfirmView(
                title: 'Create this account?',
                description:
                    'Confirm the account details before creating the record.',
                icon: Icons.account_balance_outlined,
                confirmLabel: 'Create Account',
                confirmIcon: const Icon(Icons.add),
                onConfirm: () => SuperSnackBar.success(
                  context,
                  'Inline confirmation accepted.',
                ),
                onCancel: () => SuperSnackBar.info(
                  context,
                  'Inline confirmation cancelled.',
                ),
                content: const _AccountSummary(),
              ),
            ),
            _ExampleCard(
              title: 'SuperFieldView',
              description: 'Reusable field layout for pages, cards, or sheets.',
              child: SuperFieldView(
                title: 'Store information',
                description: 'Enter the primary store details.',
                actions: [
                  SuperButton(
                    label: 'Reset',
                    variant: SuperButtonVariant.secondary,
                    onPressed: () => _inlineNameController.clear(),
                  ),
                  SuperButton(
                    label: 'Save',
                    icon: const Icon(Icons.save_outlined),
                    onPressed: () => SuperSnackBar.success(
                      context,
                      'Inline field view saved.',
                    ),
                  ),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FieldShell(
                      label: 'Store name',
                      required: true,
                      hint: 'Shown in inventory and reporting screens.',
                      child: TextField(
                        controller: _inlineNameController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Downtown Store',
                        ),
                      ),
                    ),
                    SizedBox(height: t.spacing.space4),
                    const FieldShell(
                      label: 'Store code',
                      hint: 'Optional internal reference.',
                      child: TextField(
                        decoration: InputDecoration(hintText: 'e.g. STR-001'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _ExampleCard(
              title: 'SuperConfirmDialog',
              description:
                  'The dialog wrapper handles presentation and result lifecycle.',
              child: Wrap(
                spacing: t.spacing.space2,
                runSpacing: t.spacing.space2,
                children: [
                  SuperButton(
                    label: 'Open Confirmation',
                    icon: const Icon(Icons.open_in_new),
                    onPressed: _showConfirmDialog,
                  ),
                  SuperButton(
                    label: 'Open Destructive',
                    variant: SuperButtonVariant.secondary,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _showDestructiveDialog,
                  ),
                ],
              ),
            ),
            _ExampleCard(
              title: 'SuperFieldDialog',
              description:
                  'The same field hierarchy presented in a themed modal surface.',
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: SuperButton(
                  label: 'Open Field Dialog',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: _showFieldDialog,
                ),
              ),
            ),
          ];

    return SuperExampleDocsPage(
      title: 'Dialog & View Examples',
      subtitle: 'Reusable confirmation and field surfaces',
      description:
          'Reusable content views and their thin dialog wrappers share one hierarchy, one theme, and one result lifecycle.',
      badges: const [
        SuperExampleDocsBadgeData(
          icon: Icons.open_in_new_outlined,
          label: 'Overlay',
          tone: SuperMarker.notes,
        ),
        SuperExampleDocsBadgeData(
          icon: Icons.dynamic_form_outlined,
          label: 'Reusable views',
          tone: SuperMarker.identity,
        ),
      ],
      api: const [
        'SuperConfirmView',
        'SuperConfirmDialog',
        'SuperFieldView',
        'SuperFieldDialog',
      ],
      sections: [
        SuperExampleDocsSectionData(
          label: 'Views',
          eyebrow: 'Inline',
          title: 'Reusable views',
          description:
              'Use the view widgets directly in pages, cards, sheets, or any custom presentation surface.',
          children: [content[0], content[1]],
        ),
        SuperExampleDocsSectionData(
          label: 'Dialogs',
          eyebrow: 'Overlay',
          title: 'Dialog wrappers',
          description:
              'Thin wrappers present the same view hierarchy as modal dialogs and return typed results.',
          children: [content[2], content[3]],
        ),
      ],
      footer: const SuperExampleDocsNote(
        text:
            'The inline and modal variants intentionally share the same content widgets so product behavior stays consistent across presentations.',
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final snippets = <String, String>{
      'SuperConfirmView': '''SuperConfirmView(
  title: 'Create this account?',
  description: 'Confirm the details before creating the record.',
  onConfirm: () {},
  onCancel: () {},
);''',
      'SuperFieldView': '''SuperFieldView(
  title: 'Store information',
  actions: [SuperButton(label: 'Save', onPressed: () {})],
  child: FieldShell(label: 'Store name', child: TextField()),
);''',
      'SuperConfirmDialog': '''final confirmed = await SuperConfirmDialog.show(
  context,
  title: 'Post journal entry?',
  description: 'This action can be confirmed or cancelled.',
);''',
      'SuperFieldDialog': '''final value = await SuperFieldDialog.show<String>(
  context,
  title: 'Edit warehouse name',
  child: TextField(),
);''',
    };

    return SuperExampleDocsCard(
      title: title,
      description: description,
      code: snippets[title] ?? '// $title',
      minPreviewHeight: 260,
      previewAlignment: AlignmentDirectional.topCenter,
      preview: child,
    );
  }
}

class _AccountSummary extends StatelessWidget {
  const _AccountSummary();

  @override
  Widget build(BuildContext context) {
    return const _SummaryRows(
      rows: [
        ('Account', 'Cash on Hand'),
        ('Code', '1101'),
        ('Type', 'Asset'),
      ],
    );
  }
}

class _EntrySummary extends StatelessWidget {
  const _EntrySummary();

  @override
  Widget build(BuildContext context) {
    return const _SummaryRows(
      rows: [
        ('Reference', 'JV-2026-0042'),
        ('Debit', '12,500.00'),
        ('Credit', '12,500.00'),
      ],
    );
  }
}

class _StoreSummary extends StatelessWidget {
  const _StoreSummary();

  @override
  Widget build(BuildContext context) {
    return const _SummaryRows(
      rows: [
        ('Store', 'Downtown Store'),
        ('Code', 'STR-0042'),
        ('Status', 'Active'),
      ],
    );
  }
}

class _SummaryRows extends StatelessWidget {
  const _SummaryRows({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return SuperSectionCard(
      card: false,
      padding: EdgeInsets.zero,
      children: [
        for (final row in rows)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  row.$1,
                  style: context.superTextTheme.label.copyWith(color: t.fg3),
                ),
              ),
              SizedBox(width: t.spacing.space4),
              Expanded(
                child: Text(
                  row.$2,
                  textAlign: TextAlign.end,
                  style: context.superTextTheme.body.copyWith(color: t.fg1),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
