import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_crm_follow_ups_repository.dart';
import '../domain/models/crm_follow_up.dart';

final crmFollowUpsRepositoryProvider = Provider<MockCrmFollowUpsRepository>((ref) {
  return MockCrmFollowUpsRepository();
});

class CrmFollowUpsViewState {
  final List<CrmFollowUp> followUps;
  final String searchQuery;
  final bool showCompletedOnly;
  final bool isLoading;
  final String? errorMessage;

  const CrmFollowUpsViewState({
    this.followUps = const [],
    this.searchQuery = '',
    this.showCompletedOnly = false,
    this.isLoading = false,
    this.errorMessage,
  });

  CrmFollowUpsViewState copyWith({
    List<CrmFollowUp>? followUps,
    String? searchQuery,
    bool? showCompletedOnly,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CrmFollowUpsViewState(
      followUps: followUps ?? this.followUps,
      searchQuery: searchQuery ?? this.searchQuery,
      showCompletedOnly: showCompletedOnly ?? this.showCompletedOnly,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  List<CrmFollowUp> get filteredFollowUps {
    final query = searchQuery.trim().toLowerCase();
    return followUps.where((item) {
      if (query.isNotEmpty) {
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesContact = item.contactName.toLowerCase().contains(query);
        final matchesDest = item.destination.toLowerCase().contains(query);

        if (!matchesTitle && !matchesContact && !matchesDest) {
          return false;
        }
      }
      if (showCompletedOnly && !item.isCompleted) {
        return false;
      }
      return true;
    }).toList();
  }

  List<CrmFollowUp> get overdueItems {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return filteredFollowUps
        .where((item) => !item.isCompleted && item.dueDate.isBefore(todayStart))
        .toList();
  }

  List<CrmFollowUp> get todayItems {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return filteredFollowUps.where((item) {
      if (item.isCompleted) return false;
      return !item.dueDate.isBefore(todayStart) && item.dueDate.isBefore(todayEnd);
    }).toList();
  }

  List<CrmFollowUp> get upcomingItems {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return filteredFollowUps
        .where((item) => !item.isCompleted && !item.dueDate.isBefore(todayEnd))
        .toList();
  }

  List<CrmFollowUp> get completedItems {
    return filteredFollowUps.where((item) => item.isCompleted).toList();
  }
}

class CrmFollowUpsNotifier extends StateNotifier<CrmFollowUpsViewState> {
  final MockCrmFollowUpsRepository _repository;

  CrmFollowUpsNotifier(this._repository)
      : super(const CrmFollowUpsViewState(isLoading: true)) {
    loadFollowUps();
  }

  Future<void> loadFollowUps() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      final list = await _repository.getFollowUps();
      state = state.copyWith(followUps: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load follow-ups.',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setShowCompletedOnly(bool value) {
    state = state.copyWith(showCompletedOnly: value);
  }

  Future<void> toggleCompletion(String id) async {
    try {
      final updated = await _repository.toggleCompletion(id);
      final list = state.followUps.map((i) => i.id == id ? updated : i).toList();
      state = state.copyWith(followUps: list);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update follow-up.');
    }
  }

  Future<void> addFollowUp(CrmFollowUp item) async {
    try {
      final newRecord = await _repository.addFollowUp(item);
      final updated = List<CrmFollowUp>.from(state.followUps)..add(newRecord);
      state = state.copyWith(followUps: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to add follow-up.');
    }
  }
}

final crmFollowUpsProvider =
    StateNotifierProvider<CrmFollowUpsNotifier, CrmFollowUpsViewState>((ref) {
  final repo = ref.watch(crmFollowUpsRepositoryProvider);
  return CrmFollowUpsNotifier(repo);
});
