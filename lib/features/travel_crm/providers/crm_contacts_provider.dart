import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_crm_contacts_repository.dart';
import '../domain/models/crm_contact.dart';

final crmContactsRepositoryProvider = Provider<MockCrmContactsRepository>((ref) {
  return MockCrmContactsRepository();
});

class CrmContactsViewState {
  final List<CrmContact> contacts;
  final String searchQuery;
  final String? selectedStatus;
  final bool isLoading;
  final String? errorMessage;

  const CrmContactsViewState({
    this.contacts = const [],
    this.searchQuery = '',
    this.selectedStatus,
    this.isLoading = false,
    this.errorMessage,
  });

  CrmContactsViewState copyWith({
    List<CrmContact>? contacts,
    String? searchQuery,
    String? selectedStatus,
    bool clearStatus = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CrmContactsViewState(
      contacts: contacts ?? this.contacts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  List<CrmContact> get filteredContacts {
    final query = searchQuery.trim().toLowerCase();
    return contacts.where((contact) {
      if (query.isNotEmpty) {
        final matchesName = contact.name.toLowerCase().contains(query);
        final matchesEmail = contact.email.toLowerCase().contains(query);
        final matchesLocation = contact.location.toLowerCase().contains(query);
        final matchesTags = contact.tags.any((t) => t.toLowerCase().contains(query));

        if (!matchesName && !matchesEmail && !matchesLocation && !matchesTags) {
          return false;
        }
      }

      if (selectedStatus != null && selectedStatus!.isNotEmpty) {
        if (contact.status != selectedStatus) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int get totalCount => contacts.length;
}

class CrmContactsNotifier extends StateNotifier<CrmContactsViewState> {
  final MockCrmContactsRepository _repository;

  CrmContactsNotifier(this._repository)
      : super(const CrmContactsViewState(isLoading: true)) {
    loadContacts();
  }

  Future<void> loadContacts() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      final list = await _repository.getContacts();
      state = state.copyWith(contacts: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load contacts.',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedStatus(String? status) {
    if (status == null || status.isEmpty) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(selectedStatus: status);
    }
  }

  Future<void> addContact(CrmContact contact) async {
    try {
      final newRecord = await _repository.addContact(contact);
      final updated = List<CrmContact>.from(state.contacts)..add(newRecord);
      state = state.copyWith(contacts: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to add contact.');
    }
  }
}

final crmContactsProvider =
    StateNotifierProvider<CrmContactsNotifier, CrmContactsViewState>((ref) {
  final repo = ref.watch(crmContactsRepositoryProvider);
  return CrmContactsNotifier(repo);
});
