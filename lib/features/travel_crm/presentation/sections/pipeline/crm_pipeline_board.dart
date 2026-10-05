import 'package:flutter/material.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/features/travel_crm/providers/crm_pipeline_provider.dart';
import 'crm_pipeline_column.dart';

class CrmPipelineBoard extends StatelessWidget {
  final CrmPipelineViewState state;
  final ValueChanged<String>? onSelectCard;
  final Function(String id, CrmPipelineStage newStage)? onMoveStage;
  final Function(CrmPipelineStage stage)? onAddOpportunityForStage;

  const CrmPipelineBoard({
    super.key,
    required this.state,
    this.onSelectCard,
    this.onMoveStage,
    this.onAddOpportunityForStage,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: CrmPipelineStage.values.map((stage) {
            final items = state.opportunitiesForStage(stage);
            return CrmPipelineColumn(
              stage: stage,
              opportunities: items,
              selectedId: state.selectedOpportunityId,
              onSelectCard: onSelectCard,
              onMoveStage: onMoveStage,
              onAddOpportunity: () => onAddOpportunityForStage?.call(stage),
            );
          }).toList(),
        ),
      ),
    );
  }
}
