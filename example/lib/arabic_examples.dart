// GENERATED DOCS-LAYOUT MIGRATION: super_core example docs v1
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
class ArabicExampleSection extends StatelessWidget {
  const ArabicExampleSection({
    super.key,
    this.title = 'تجربة عربية',
    this.subtitle = 'نص عربي واتجاه RTL داخل مكونات Super',
    this.compactHeader = false,
    this.showFooter = true,
  });

  final String title;
  final String subtitle;
  final bool compactHeader;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return SuperExampleDocsCard(
      title: title,
      description: subtitle,
      code: r'''Directionality(
  textDirection: TextDirection.rtl,
  child: SuperSectionCard(
    title: 'بيانات الحساب',
    subtitle: 'مثال حي للنص العربي واتجاه RTL',
    marker: SuperMarker.identity,
    child: ...,
  ),
);''',
      minPreviewHeight: 280,
      previewAlignment: AlignmentDirectional.center,
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: SuperSectionCard(
            title: 'بيانات الحساب',
            subtitle: subtitle,
            marker: SuperMarker.identity,
            icon: Icons.translate_outlined,
            headerStyle: compactHeader
                ? SuperSectionHeaderStyle.style2
                : SuperSectionHeaderStyle.style1,
            headerTrailing: const StatusPill(
              'نشط',
              tone: PillTone.success,
            ),
            footer: showFooter
                ? const SuperSectionFooter(
                    brand: 'Super Core · واجهة عربية',
                    actions: [
                      SuperFooterLink('إلغاء'),
                      SuperFooterLink('حفظ', emphasized: true),
                    ],
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _ArabicDetails(),
                SizedBox(height: t.spacing.space3),
                const Hairline(),
                SizedBox(height: t.spacing.space3),
                Text(
                  'هذا المثال يتحقق من المحاذاة، ترتيب الأيقونات، الهوامش، '
                  'والنصوص الطويلة عند استخدام اتجاه من اليمين إلى اليسار.',
                  style: context.superTextTheme.bodySm.copyWith(
                    color: t.fg3,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArabicDetails extends StatelessWidget {
  const _ArabicDetails();

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Column(
      children: [
        const _ArabicDetailRow(
          icon: Icons.person_outline,
          label: 'اسم العميل',
          value: 'شركة النور للتجارة',
        ),
        SizedBox(height: t.spacing.space2),
        const _ArabicDetailRow(
          icon: Icons.numbers_outlined,
          label: 'رمز الحساب',
          value: 'ACC-10042',
        ),
        SizedBox(height: t.spacing.space2),
        const _ArabicDetailRow(
          icon: Icons.location_on_outlined,
          label: 'الفرع',
          value: 'الرياض · الفرع الرئيسي',
        ),
      ],
    );
  }
}

class _ArabicDetailRow extends StatelessWidget {
  const _ArabicDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: t.fg3),
        SizedBox(width: t.spacing.space2),
        Expanded(
          child: Text(
            label,
            style: context.superTextTheme.bodySm.copyWith(color: t.fg3),
          ),
        ),
        SizedBox(width: t.spacing.space3),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.superTextTheme.labelMd.copyWith(color: t.fg1),
          ),
        ),
      ],
    );
  }
}
