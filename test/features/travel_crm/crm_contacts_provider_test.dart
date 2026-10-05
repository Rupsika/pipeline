import 'package:flutter_test/flutter_test.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_contact.dart';
import 'package:sch_track/features/travel_crm/providers/crm_contacts_provider.dart';
import 'package:sch_track/features/travel_crm/data/mock_crm_contacts_repository.dart';

void main() {
  group('CrmContactsProvider Tests', () {
    late MockCrmContactsRepository repository;
    late CrmContactsNotifier notifier;

    setUp(() {
      repository = MockCrmContactsRepository();
      notifier = CrmContactsNotifier(repository);
    });

    test('Initial state loads contacts from mock repository', () async {
      expect(notifier.state.isLoading, true);
      await notifier.loadContacts();
      expect(notifier.state.isLoading, false);
      expect(notifier.state.contacts.isNotEmpty, true);
    });

    test('Search filter filters contacts by name or location', () async {
      await notifier.loadContacts();
      notifier.setSearchQuery('Rohan');
      expect(notifier.state.filteredContacts.length, 1);
      expect(notifier.state.filteredContacts.first.name, 'Rohan Iyer');
    });

    test('Status filter filters contacts correctly', () async {
      await notifier.loadContacts();
      notifier.setSelectedStatus('VIP');
      expect(notifier.state.filteredContacts.every((c) => c.status == 'VIP'), true);
    });

    test('Adding a contact updates state list', () async {
      await notifier.loadContacts();
      final initialCount = notifier.state.contacts.length;

      final newContact = CrmContact(
        id: 'test_cnt_99',
        name: 'Test Traveler',
        email: 'test@example.com',
        phone: '1234567890',
        location: 'Delhi',
        createdAt: DateTime.now(),
      );

      await notifier.addContact(newContact);
      expect(notifier.state.contacts.length, initialCount + 1);
      expect(notifier.state.contacts.last.name, 'Test Traveler');
    });
  });
}
