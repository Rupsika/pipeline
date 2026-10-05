import 'package:flutter/material.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/shared/widgets/app_card.dart';

class PipelineSummary extends StatelessWidget {
  final int totalCount;
  final double activeValue;
  final int wonCount;
  final double wonValue;

  const PipelineSummary({
    super.key,
    required this.totalCount,
    required this.activeValue,
    required this.wonCount,
    required this.wonValue,
  });

  String _formatLakhs(double amount) {
    if (amount >= 100000) {
      final inLakhs = amount / 100000;
      final formatted = inLakhs.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
      return '₹${formatted}L';
    }
    return '₹${amount.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      backgroundColor: Colors.white,
      borderColor: Colors.grey.shade200,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.md,
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Metric 1: Opportunities Count
              _SummaryMetricTile(
                icon: Icons.work_outline_rounded,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF2563EB),
                value: '$totalCount',
                label: 'opportunities',
              ),

              // Metric 2: Active Pipeline Value in Lakhs
              _SummaryMetricTile(
                icon: Icons.currency_rupee_rounded,
                iconBgColor: const Color(0xFFFFF7ED),
                iconColor: const Color(0xFFEA580C),
                value: _formatLakhs(activeValue),
                label: 'pipeline value',
              ),

              // Metric 3: Won opportunities count
              _SummaryMetricTile(
                icon: Icons.emoji_events_outlined,
                iconBgColor: const Color(0xFFF0FDF4),
                iconColor: const Color(0xFF16A34A),
                value: '$wonCount',
                label: 'won this month',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryMetricTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;

  const _SummaryMetricTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
