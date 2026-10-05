import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/shared/widgets/app_card.dart';
import 'package:sch_track/shared/widgets/avatar_circle.dart';
import 'package:sch_track/shared/widgets/status_badge.dart';

class CrmOpportunityCard extends StatelessWidget {
  final CrmOpportunity opportunity;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<CrmPipelineStage>? onMoveStage;

  const CrmOpportunityCard({
    super.key,
    required this.opportunity,
    this.isSelected = false,
    this.onTap,
    this.onMoveStage,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isWon = opportunity.stage == CrmPipelineStage.won;

    return AppCard(
      isSelected: isSelected,
      onTap: onTap,
      backgroundColor: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
      borderColor: isSelected ? const Color(0xFFFF6600) : Colors.grey.shade200,
      padding: EdgeInsets.all(AppSpacing.md),
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Contact Name & Won Badge / Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opportunity.contactName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      opportunity.tripTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isWon)
                const StatusBadge(
                  label: 'Won',
                  color: Color(0xFF16A34A),
                )
              else
                PopupMenuButton<CrmPipelineStage>(
                  icon: Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary),
                  tooltip: 'Opportunity actions',
                  onSelected: (stage) {
                    onMoveStage?.call(stage);
                  },
                  itemBuilder: (context) {
                    return CrmPipelineStage.values
                        .where((stage) => stage != opportunity.stage)
                        .map(
                          (stage) => PopupMenuItem<CrmPipelineStage>(
                            value: stage,
                            child: Row(
                              children: [
                                Icon(Icons.swap_horiz, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 8),
                                Text('Move to ${stage.label}'),
                              ],
                            ),
                          ),
                        )
                        .toList();
                  },
                ),
            ],
          ),

          SizedBox(height: AppSpacing.sm),

          // Estimated Value
          Text(
            _formatCurrency(opportunity.estimatedValue),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // Footer: Owner & Follow-up Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Owner
              Expanded(
                child: Row(
                  children: [
                    AvatarCircle(
                      initials: opportunity.ownerInitials,
                      radius: 10,
                      backgroundColor: const Color(0xFFE2E8F0),
                      textColor: const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        opportunity.ownerName,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Follow up Date
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(opportunity.nextFollowUpAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
