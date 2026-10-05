import 'package:flutter/material.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'crm_opportunity_card.dart';

class CrmPipelineColumn extends StatelessWidget {
  final CrmPipelineStage stage;
  final List<CrmOpportunity> opportunities;
  final String? selectedId;
  final ValueChanged<String>? onSelectCard;
  final Function(String id, CrmPipelineStage newStage)? onMoveStage;
  final VoidCallback? onAddOpportunity;

  const CrmPipelineColumn({
    super.key,
    required this.stage,
    required this.opportunities,
    this.selectedId,
    this.onSelectCard,
    this.onMoveStage,
    this.onAddOpportunity,
  });

  Color _getStageColor(CrmPipelineStage stage) {
    switch (stage) {
      case CrmPipelineStage.newEnquiry:
        return AppColors.stageNewEnquiry;
      case CrmPipelineStage.qualified:
        return AppColors.stageQualified;
      case CrmPipelineStage.proposalSent:
        return AppColors.stageProposalSent;
      case CrmPipelineStage.negotiation:
        return AppColors.stageNegotiation;
      case CrmPipelineStage.won:
        return AppColors.stageWon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stageColor = _getStageColor(stage);

    return Container(
      width: 280,
      height: 540,
      margin: EdgeInsets.only(right: AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: stageColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    stage.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${opportunities.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Cards List or Empty Stage State
          Expanded(
            child: opportunities.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 28,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'No opportunities in ${stage.label}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    itemCount: opportunities.length,
                    itemBuilder: (context, index) {
                      final item = opportunities[index];
                      return CrmOpportunityCard(
                        opportunity: item,
                        isSelected: selectedId == item.id,
                        onTap: () => onSelectCard?.call(item.id),
                        onMoveStage: (newStage) => onMoveStage?.call(item.id, newStage),
                      );
                    },
                  ),
          ),

          // Add Opportunity Button at bottom of column
          InkWell(
            onTap: onAddOpportunity,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Add opportunity',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
