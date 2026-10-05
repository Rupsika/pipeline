import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_crm_pipeline_repository.dart';
import '../domain/models/crm_opportunity.dart';

final crmPipelineRepositoryProvider = Provider<MockCrmPipelineRepository>((ref) {
  return MockCrmPipelineRepository();
});

class CrmPipelineViewState {
  final List<CrmOpportunity> opportunities;
  final String? selectedOpportunityId;
  final String searchQuery;
  final String? selectedOwner;
  final CrmTripType? selectedTripType;
  final bool isLoading;
  final String? errorMessage;

  const CrmPipelineViewState({
    this.opportunities = const [],
    this.selectedOpportunityId,
    this.searchQuery = '',
    this.selectedOwner,
    this.selectedTripType,
    this.isLoading = false,
    this.errorMessage,
  });

  CrmPipelineViewState copyWith({
    List<CrmOpportunity>? opportunities,
    String? selectedOpportunityId,
    bool clearSelectedId = false,
    String? searchQuery,
    String? selectedOwner,
    bool clearOwner = false,
    CrmTripType? selectedTripType,
    bool clearTripType = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CrmPipelineViewState(
      opportunities: opportunities ?? this.opportunities,
      selectedOpportunityId: clearSelectedId
          ? null
          : (selectedOpportunityId ?? this.selectedOpportunityId),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedOwner: clearOwner ? null : (selectedOwner ?? this.selectedOwner),
      selectedTripType:
          clearTripType ? null : (selectedTripType ?? this.selectedTripType),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  // Helper getters
  List<CrmOpportunity> get filteredOpportunities {
    final query = searchQuery.trim().toLowerCase();

    return opportunities.where((item) {
      // Search query check
      if (query.isNotEmpty) {
        final matchesContact = item.contactName.toLowerCase().contains(query);
        final matchesTitle = item.tripTitle.toLowerCase().contains(query);
        final matchesDest = item.destination.toLowerCase().contains(query);
        final matchesOwner = item.ownerName.toLowerCase().contains(query);

        if (!matchesContact && !matchesTitle && !matchesDest && !matchesOwner) {
          return false;
        }
      }

      // Owner filter check
      if (selectedOwner != null && selectedOwner!.isNotEmpty) {
        if (item.ownerName != selectedOwner) {
          return false;
        }
      }

      // Trip type filter check
      if (selectedTripType != null) {
        if (item.tripType != selectedTripType) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Summary Metrics (based on ALL loaded opportunities)
  int get totalCount => opportunities.length;

  double get activePipelineValue {
    return opportunities
        .where((item) => item.stage != CrmPipelineStage.won)
        .fold(0.0, (sum, item) => sum + item.estimatedValue);
  }

  int get wonCount {
    return opportunities
        .where((item) => item.stage == CrmPipelineStage.won)
        .length;
  }

  double get wonValue {
    return opportunities
        .where((item) => item.stage == CrmPipelineStage.won)
        .fold(0.0, (sum, item) => sum + item.estimatedValue);
  }

  // Unique list of owners for toolbar filter
  List<String> get availableOwners {
    final owners = opportunities.map((o) => o.ownerName).toSet().toList();
    owners.sort();
    return owners;
  }

  // Filtered stage counts for Kanban columns
  int countForStage(CrmPipelineStage stage) {
    return filteredOpportunities.where((item) => item.stage == stage).length;
  }

  List<CrmOpportunity> opportunitiesForStage(CrmPipelineStage stage) {
    return filteredOpportunities.where((item) => item.stage == stage).toList();
  }

  bool get isFilterActive =>
      searchQuery.trim().isNotEmpty ||
      selectedOwner != null ||
      selectedTripType != null;
}

class CrmPipelineNotifier extends StateNotifier<CrmPipelineViewState> {
  final MockCrmPipelineRepository _repository;

  CrmPipelineNotifier(this._repository)
      : super(const CrmPipelineViewState(isLoading: true)) {
    loadOpportunities();
  }

  Future<void> loadOpportunities() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      final data = await _repository.getOpportunities();
      state = state.copyWith(
        opportunities: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load opportunities. Please try again.',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedOwner(String? owner) {
    if (owner == null || owner.isEmpty) {
      state = state.copyWith(clearOwner: true);
    } else {
      state = state.copyWith(selectedOwner: owner);
    }
  }

  void setSelectedTripType(CrmTripType? tripType) {
    if (tripType == null) {
      state = state.copyWith(clearTripType: true);
    } else {
      state = state.copyWith(selectedTripType: tripType);
    }
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      clearOwner: true,
      clearTripType: true,
    );
  }

  void selectOpportunity(String? id) {
    if (id == null) {
      state = state.copyWith(clearSelectedId: true);
    } else {
      state = state.copyWith(selectedOpportunityId: id);
    }
  }

  Future<void> addOpportunity(CrmOpportunity opportunity) async {
    try {
      final newRecord = await _repository.addOpportunity(opportunity);
      final updatedList = List<CrmOpportunity>.from(state.opportunities)..add(newRecord);
      state = state.copyWith(
        opportunities: updatedList,
        selectedOpportunityId: newRecord.id,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to add opportunity.',
      );
    }
  }

  Future<void> moveOpportunityStage(String id, CrmPipelineStage newStage) async {
    final index = state.opportunities.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final currentItem = state.opportunities[index];
    if (currentItem.stage == newStage) return;

    final updatedItem = currentItem.copyWith(
      stage: newStage,
      updatedAt: DateTime.now(),
    );

    try {
      await _repository.updateOpportunity(updatedItem);
      final updatedList = List<CrmOpportunity>.from(state.opportunities);
      updatedList[index] = updatedItem;

      state = state.copyWith(
        opportunities: updatedList,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to move opportunity stage.',
      );
    }
  }

  Future<void> deleteOpportunity(String id) async {
    try {
      await _repository.deleteOpportunity(id);
      final updatedList = state.opportunities.where((item) => item.id != id).toList();
      state = state.copyWith(
        opportunities: updatedList,
        clearSelectedId: state.selectedOpportunityId == id,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete opportunity.',
      );
    }
  }
}

final crmPipelineProvider =
    StateNotifierProvider<CrmPipelineNotifier, CrmPipelineViewState>((ref) {
  final repo = ref.watch(crmPipelineRepositoryProvider);
  return CrmPipelineNotifier(repo);
});
