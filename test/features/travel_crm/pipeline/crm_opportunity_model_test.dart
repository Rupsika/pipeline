import 'package:flutter_test/flutter_test.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';

void main() {
  group('CrmOpportunity Model Tests', () {
    test('Immutable model copyWith updates target fields correctly', () {
      final now = DateTime(2026, 8, 1);
      final opp = CrmOpportunity(
        id: 'opp_test',
        contactName: 'Test Contact',
        tripTitle: 'Test Trip',
        tripType: CrmTripType.family,
        destination: 'Test Destination',
        estimatedValue: 100000,
        travelMonth: 'October 2026',
        stage: CrmPipelineStage.newEnquiry,
        ownerName: 'Test Owner',
        ownerInitials: 'TO',
        nextFollowUpAt: now,
        createdAt: now,
        updatedAt: now,
      );

      final updated = opp.copyWith(
        stage: CrmPipelineStage.won,
        estimatedValue: 150000,
        updatedAt: now.add(const Duration(hours: 1)),
      );

      expect(updated.id, 'opp_test');
      expect(updated.contactName, 'Test Contact');
      expect(updated.stage, CrmPipelineStage.won);
      expect(updated.estimatedValue, 150000);
      expect(updated.updatedAt, now.add(const Duration(hours: 1)));
    });

    test('Stage readable labels return exact expected strings', () {
      expect(CrmPipelineStage.newEnquiry.label, 'New Enquiry');
      expect(CrmPipelineStage.qualified.label, 'Qualified');
      expect(CrmPipelineStage.proposalSent.label, 'Proposal Sent');
      expect(CrmPipelineStage.negotiation.label, 'Negotiation');
      expect(CrmPipelineStage.won.label, 'Won');
    });

    test('Trip type readable labels return exact expected strings', () {
      expect(CrmTripType.solo.label, 'Solo');
      expect(CrmTripType.honeymoon.label, 'Honeymoon');
      expect(CrmTripType.family.label, 'Family');
      expect(CrmTripType.group.label, 'Group');
      expect(CrmTripType.corporate.label, 'Corporate');
      expect(CrmTripType.custom.label, 'Custom');
    });
  });
}
