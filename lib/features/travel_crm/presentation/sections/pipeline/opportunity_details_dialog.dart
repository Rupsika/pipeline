import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/shared/widgets/app_button.dart';
import 'package:sch_track/shared/widgets/avatar_circle.dart';
import 'package:sch_track/shared/widgets/status_badge.dart';

class OpportunityDetailsDialog extends StatelessWidget {
  final CrmOpportunity opportunity;
  final Function(CrmPipelineStage newStage) onMoveStage;
  final VoidCallback? onDelete;

  const OpportunityDetailsDialog({
    super.key,
    required this.opportunity,
    required this.onMoveStage,
    this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required CrmOpportunity opportunity,
    required Function(CrmPipelineStage newStage) onMoveStage,
    VoidCallback? onDelete,
  }) {
    return showDialog(
      context: context,
      builder: (context) => OpportunityDetailsDialog(
        opportunity: opportunity,
        onMoveStage: onMoveStage,
        onDelete: onDelete,
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

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
    final stageColor = _getStageColor(opportunity.stage);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.tripTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contact: ${opportunity.contactName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    tooltip: 'Delete Opportunity',
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete!();
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            const Divider(),
            SizedBox(height: AppSpacing.sm),

            // Main Info Grid
            Wrap(
              runSpacing: AppSpacing.md,
              spacing: AppSpacing.md,
              children: [
                _DetailTile(
                  label: 'Current Stage',
                  child: StatusBadge(
                    label: opportunity.stage.label,
                    color: stageColor,
                  ),
                ),
                _DetailTile(
                  label: 'Estimated Value',
                  value: _formatCurrency(opportunity.estimatedValue),
                  isBold: true,
                ),
                _DetailTile(
                  label: 'Destination',
                  value: opportunity.destination,
                ),
                _DetailTile(
                  label: 'Trip Type',
                  value: opportunity.tripType.label,
                ),
                _DetailTile(
                  label: 'Travel Month',
                  value: opportunity.travelMonth,
                ),
                _DetailTile(
                  label: 'Next Follow-up Date',
                  value: _formatDate(opportunity.nextFollowUpAt),
                ),
                _DetailTile(
                  label: 'Assigned Owner',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AvatarCircle(initials: opportunity.ownerInitials, radius: 10),
                      const SizedBox(width: 6),
                      Text(
                        opportunity.ownerName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (opportunity.notes != null && opportunity.notes!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.md),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  opportunity.notes!,
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
              ),
            ],

            SizedBox(height: AppSpacing.lg),
            const Divider(),
            SizedBox(height: AppSpacing.sm),

            // Move Stage Actions
            Text(
              'Move to Stage:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: CrmPipelineStage.values
                  .where((stage) => stage != opportunity.stage)
                  .map(
                    (stage) => AppButton(
                      label: stage.label,
                      variant: AppButtonVariant.outline,
                      onPressed: () {
                        onMoveStage(stage);
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;
  final bool isBold;

  const _DetailTile({
    required this.label,
    this.value,
    this.child,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          if (child != null)
            child!
          else
            Text(
              value ?? '-',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
