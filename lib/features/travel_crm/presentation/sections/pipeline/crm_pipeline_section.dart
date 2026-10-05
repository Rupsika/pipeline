import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/features/travel_crm/providers/crm_pipeline_provider.dart';
import 'add_opportunity_dialog.dart';
import 'crm_pipeline_board.dart';
import 'crm_pipeline_toolbar.dart';
import 'opportunity_details_dialog.dart';
import 'pipeline_states.dart';
import 'pipeline_summary.dart';

class CrmPipelineSection extends ConsumerWidget {
  const CrmPipelineSection({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openAddOpportunityDialog(
    BuildContext context,
    CrmPipelineViewState state,
    CrmPipelineNotifier notifier, {
    CrmPipelineStage initialStage = CrmPipelineStage.newEnquiry,
  }) {
    AddOpportunityDialog.show(
      context,
      availableOwners: state.availableOwners,
      initialStage: initialStage,
      onSubmit: (newOpp) async {
        await notifier.addOpportunity(newOpp);
        if (context.mounted) {
          _showSnackBar(
            context,
            'Added "${newOpp.tripTitle}" to ${newOpp.stage.label}.',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crmPipelineProvider);
    final notifier = ref.read(crmPipelineProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter Toolbar
          CrmPipelineToolbar(
            searchQuery: state.searchQuery,
            onSearchChanged: notifier.setSearchQuery,
            selectedOwner: state.selectedOwner,
            availableOwners: state.availableOwners,
            onOwnerChanged: notifier.setSelectedOwner,
            selectedTripType: state.selectedTripType,
            onTripTypeChanged: notifier.setSelectedTripType,
            isFilterActive: state.isFilterActive,
            onClearFilters: notifier.clearFilters,
            onAddOpportunity: () => _openAddOpportunityDialog(context, state, notifier),
          ),
          SizedBox(height: AppSpacing.md),

          // Main Board Content Area
          Builder(
            builder: (context) {
              if (state.isLoading) {
                return const PipelineLoadingState();
              }

              if (state.errorMessage != null) {
                return PipelineErrorState(
                  message: state.errorMessage!,
                  onRetry: notifier.loadOpportunities,
                );
              }

              if (state.filteredOpportunities.isEmpty && state.isFilterActive) {
                return PipelineEmptyFilterState(
                  onClearFilters: notifier.clearFilters,
                );
              }

              return CrmPipelineBoard(
                state: state,
                onAddOpportunityForStage: (stage) {
                  _openAddOpportunityDialog(
                    context,
                    state,
                    notifier,
                    initialStage: stage,
                  );
                },
                onSelectCard: (id) {
                  notifier.selectOpportunity(id);
                  final selectedOpp = state.opportunities.firstWhere(
                    (o) => o.id == id,
                  );
                  OpportunityDetailsDialog.show(
                    context,
                    opportunity: selectedOpp,
                    onDelete: () async {
                      await notifier.deleteOpportunity(id);
                      if (context.mounted) {
                        _showSnackBar(
                          context,
                          'Deleted opportunity "${selectedOpp.tripTitle}".',
                        );
                      }
                    },
                    onMoveStage: (newStage) async {
                      await notifier.moveOpportunityStage(id, newStage);
                      if (context.mounted) {
                        _showSnackBar(
                          context,
                          'Moved "${selectedOpp.tripTitle}" to ${newStage.label}.',
                        );
                      }
                    },
                  );
                },
                onMoveStage: (id, newStage) async {
                  final opp = state.opportunities.firstWhere((o) => o.id == id);
                  await notifier.moveOpportunityStage(id, newStage);
                  if (context.mounted) {
                    _showSnackBar(
                      context,
                      'Moved "${opp.tripTitle}" to ${newStage.label}.',
                    );
                  }
                },
              );
            },
          ),
          SizedBox(height: AppSpacing.md),

          // Bottom Summary Section
          PipelineSummary(
            totalCount: state.totalCount,
            activeValue: state.activePipelineValue,
            wonCount: state.wonCount,
            wonValue: state.wonValue,
          ),
        ],
      ),
    );
  }
}
