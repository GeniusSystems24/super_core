import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

/// Shared Arabic / RTL sample used by the example screens.
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SuperSectionCard(
        title: title,
        subtitle: subtitle,
        marker: SuperMarker.identity,
        icon: Icons.translate_outlined,
        headerStyle: compactHeader
            ? SuperSectionHeaderStyle.style2
            : SuperSectionHeaderStyle.style1,
        headerTrailing: const StatusPill('جاهز', tone: PillTone.success),
        footerBrand: showFooter ? 'جينيس لينك - تجربة RTL' : null,
        footerActions: showFooter
            ? const [
                SuperFooterLink('مراجعة'),
                SuperFooterLink('حفظ', emphasized: true),
              ]
            : const [],
        children: [
          Text(
            'يعرض هذا المثال محاذاة البداية والنهاية، ترتيب الأيقونات، '
            'ونصوص الحالة عند استخدام واجهة عربية من اليمين إلى اليسار.',
            textAlign: TextAlign.start,
            style: t.textTheme.body.copyWith(color: t.fg2),
          ),
          Wrap(
            spacing: t.spacing.space2,
            runSpacing: t.spacing.space2,
            children: const [
              StatusPill('مفتوح', tone: PillTone.info),
              StatusPill('مكتمل', tone: PillTone.success),
              StatusPill('قيد المراجعة', tone: PillTone.warning),
            ],
          ),
          const _ArabicDetails(),
        ],
      ),
    );
  }
}

class _ArabicDetails extends StatelessWidget {
  const _ArabicDetails();

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      padding: t.spacing.compactCardPadding,
      decoration: BoxDecoration(
        color: t.inputBg,
        borderRadius: t.spacing.borderRadiusMd,
        border: Border.all(color: t.border),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArabicDetailRow('رقم الحساب', '100-0042'),
          SizedBox(height: 8),
          _ArabicDetailRow('اسم الحساب', 'صندوق النقدية'),
          SizedBox(height: 8),
          _ArabicDetailRow('الحالة', 'جاهز للترحيل'),
        ],
      ),
    );
  }
}

class _ArabicDetailRow extends StatelessWidget {
  const _ArabicDetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: t.textTheme.body.copyWith(color: t.fg3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: t.spacing.space3),
        Text(
          value,
          // style: t.textTheme.body.copyWith(
          //   color: t.fg1,
          //   fontWeight: FontWeight.w700,
          // ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
