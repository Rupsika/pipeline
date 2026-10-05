import 'package:flutter_test/flutter_test.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_follow_up.dart';
import 'package:sch_track/features/travel_crm/providers/crm_follow_ups_provider.dart';
import 'package:sch_track/features/travel_crm/data/mock_crm_follow_ups_repository.dart';

void main() {
  group('CrmFollowUpsProvider Tests', () {
    late MockCrmFollowUpsRepository repository;
    late CrmFollowUpsNotifier notifier;

    setUp(() {
      repository = MockCrmFollowUpsRepository();
      notifier = CrmFollowUpsNotifier(repository);
    });

    test('Initial state loads follow-ups from repository', () async {
      expect(notifier.state.isLoading, true);
      await notifier.loadFollowUps();
      expect(notifier.state.isLoading, false);
      expect(notifier.state.followUps.isNotEmpty, true);
    });

    test('Toggle completion updates follow-up state', () async {
      await notifier.loadFollowUps();
      final item = notifier.state.followUps.first;
      final initialStatus = item.isCompleted;

      await notifier.toggleCompletion(item.id);
      final updatedItem = notifier.state.followUps.firstWhere((i) => i.id == item.id);
      expect(updatedItem.isCompleted, !initialStatus);
    });

    test('Adding new follow-up appends to list', () async {
      await notifier.loadFollowUps();
      final initialLength = notifier.state.followUps.length;

      final newItem = CrmFollowUp(
        id: 'test_flw_100',
        opportunityId: 'opp_1',
        title: 'New Call Task',
        contactName: 'Test Contact',
        destination: 'Goa',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      await notifier.addFollowUp(newItem);
      expect(notifier.state.followUps.length, initialLength + 1);
    });
  });
}
