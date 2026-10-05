import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sch_track/features/travel_crm/data/mock_crm_pipeline_repository.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/features/travel_crm/providers/crm_pipeline_provider.dart';

void main() {
  late MockCrmPipelineRepository repository;

  setUp(() {
    repository = MockCrmPipelineRepository();
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        crmPipelineRepositoryProvider.overrideWithValue(repository),
      ],
    );
  }

  group('CrmPipelineProvider State & Logic Tests', () {
    test('Mock opportunities load and all five stages are represented', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);

      await notifier.loadOpportunities();
      final state = container.read(crmPipelineProvider);

      expect(state.isLoading, false);
      expect(state.opportunities.length, 10);

      // Verify all 5 stages exist in initial data
      for (final stage in CrmPipelineStage.values) {
        expect(state.opportunitiesForStage(stage).isNotEmpty, true,
            reason: 'Stage ${stage.label} should be represented');
      }
    });

    test('Search filter matches contact name, title, destination, and owner case-insensitively', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      // Search contact name
      notifier.setSearchQuery('meera');
      var state = container.read(crmPipelineProvider);
      expect(state.filteredOpportunities.length, 1);
      expect(state.filteredOpportunities.first.contactName, 'Meera Shah');

      // Search destination
      notifier.setSearchQuery('dubai');
      state = container.read(crmPipelineProvider);
      expect(state.filteredOpportunities.length, 1);
      expect(state.filteredOpportunities.first.tripTitle, 'Dubai honeymoon');

      // Search owner name
      notifier.setSearchQuery('pooja');
      state = container.read(crmPipelineProvider);
      expect(state.filteredOpportunities.length, 3);
    });

    test('Owner filter works', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      notifier.setSelectedOwner('Ankit Kumar');
      final state = container.read(crmPipelineProvider);
      expect(state.filteredOpportunities.every((o) => o.ownerName == 'Ankit Kumar'), true);
      expect(state.filteredOpportunities.length, 4);
    });

    test('Trip-type filter works', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      notifier.setSelectedTripType(CrmTripType.honeymoon);
      final state = container.read(crmPipelineProvider);
      expect(state.filteredOpportunities.every((o) => o.tripType == CrmTripType.honeymoon), true);
      expect(state.filteredOpportunities.length, 2);
    });

    test('Combined search and filters work together', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      notifier.setSearchQuery('honeymoon');
      notifier.setSelectedOwner('Ankit Kumar');
      notifier.setSelectedTripType(CrmTripType.honeymoon);

      final state = container.read(crmPipelineProvider);
      expect(state.filteredOpportunities.length, 1);
      expect(state.filteredOpportunities.first.contactName, 'Arjun Nair');
    });

    test('Active Pipeline value, Won count, and Won value are calculated correctly', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      final state = container.read(crmPipelineProvider);
      expect(state.totalCount, 10);
      expect(state.wonCount, 2);
      expect(state.wonValue, 450000 + 280000); // 730000
      expect(state.activePipelineValue, 120000 + 95000 + 180000 + 620000 + 240000 + 310000 + 560000 + 780000); // 2905000
    });

    test('Adding an opportunity places it in correct column and updates summary totals', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      final initialTotal = container.read(crmPipelineProvider).totalCount;
      final initialActive = container.read(crmPipelineProvider).activePipelineValue;

      final newOpp = CrmOpportunity(
        id: 'opp_new_test',
        contactName: 'New Client',
        tripTitle: 'Paris Special',
        tripType: CrmTripType.solo,
        destination: 'Paris, France',
        estimatedValue: 200000,
        travelMonth: 'December 2026',
        stage: CrmPipelineStage.qualified,
        ownerName: 'Ankit Kumar',
        ownerInitials: 'AK',
        nextFollowUpAt: DateTime(2026, 9, 1),
        createdAt: DateTime(2026, 8, 1),
        updatedAt: DateTime(2026, 8, 1),
      );

      await notifier.addOpportunity(newOpp);
      final state = container.read(crmPipelineProvider);

      expect(state.totalCount, initialTotal + 1);
      expect(state.activePipelineValue, initialActive + 200000);
      expect(state.opportunitiesForStage(CrmPipelineStage.qualified).any((o) => o.id == 'opp_new_test'), true);
    });

    test('Moving changes stage, decreases old count, increases new count, and updates Won totals', () async {
      final container = makeContainer();
      final notifier = container.read(crmPipelineProvider.notifier);
      await notifier.loadOpportunities();

      // Find an opportunity in proposalSent stage (e.g. Meera Shah opp_5, value 240000)
      final stateBefore = container.read(crmPipelineProvider);
      final oldCountProposal = stateBefore.countForStage(CrmPipelineStage.proposalSent);
      final oldCountWon = stateBefore.countForStage(CrmPipelineStage.won);
      final initialActiveVal = stateBefore.activePipelineValue;
      final initialWonVal = stateBefore.wonValue;

      // Move opp_5 to Won stage
      await notifier.moveOpportunityStage('opp_5', CrmPipelineStage.won);

      final stateAfter = container.read(crmPipelineProvider);
      expect(stateAfter.countForStage(CrmPipelineStage.proposalSent), oldCountProposal - 1);
      expect(stateAfter.countForStage(CrmPipelineStage.won), oldCountWon + 1);
      expect(stateAfter.activePipelineValue, initialActiveVal - 240000);
      expect(stateAfter.wonValue, initialWonVal + 240000);
    });
  });
}
