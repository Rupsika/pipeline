import '../domain/models/crm_opportunity.dart';

class MockCrmPipelineRepository {
  final List<CrmOpportunity> _items = [];

  MockCrmPipelineRepository() {
    _initMockData();
  }

  void _initMockData() {
    final fixedBaseDate = DateTime(2026, 8, 1);

    _items.addAll([
      CrmOpportunity(
        id: 'opp_1',
        contactId: 'cnt_1',
        contactName: 'Rohan Iyer',
        tripTitle: 'Thailand getaway',
        tripType: CrmTripType.solo,
        destination: 'Phuket & Bangkok, Thailand',
        estimatedValue: 120000,
        travelMonth: 'October 2026',
        stage: CrmPipelineStage.newEnquiry,
        ownerName: 'Ankit Kumar',
        ownerInitials: 'AK',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 2)),
        notes: 'Requested beachside resort options.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 5)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 5)),
      ),
      CrmOpportunity(
        id: 'opp_2',
        contactId: 'cnt_2',
        contactName: 'Kavya Reddy',
        tripTitle: 'Kerala backwaters',
        tripType: CrmTripType.custom,
        destination: 'Alleppey & Munnar, India',
        estimatedValue: 95000,
        travelMonth: 'September 2026',
        stage: CrmPipelineStage.newEnquiry,
        ownerName: 'Pooja Sharma',
        ownerInitials: 'PS',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 4)),
        notes: 'Interested in luxury houseboat stay.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 3)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 3)),
      ),
      CrmOpportunity(
        id: 'opp_3',
        contactId: 'cnt_3',
        contactName: 'Arjun Nair',
        tripTitle: 'Dubai honeymoon',
        tripType: CrmTripType.honeymoon,
        destination: 'Dubai, UAE',
        estimatedValue: 180000,
        travelMonth: 'November 2026',
        stage: CrmPipelineStage.qualified,
        ownerName: 'Ankit Kumar',
        ownerInitials: 'AK',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 5)),
        notes: 'Budget verified. Desert safari included.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 10)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 2)),
      ),
      CrmOpportunity(
        id: 'opp_4',
        contactId: 'cnt_4',
        contactName: 'Amit Deshpande',
        tripTitle: 'Australia road trip',
        tripType: CrmTripType.group,
        destination: 'Sydney & Melbourne, Australia',
        estimatedValue: 620000,
        travelMonth: 'December 2026',
        stage: CrmPipelineStage.qualified,
        ownerName: 'Ritu Verma',
        ownerInitials: 'RV',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 7)),
        notes: 'Self-drive rental request.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 8)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 1)),
      ),
      CrmOpportunity(
        id: 'opp_5',
        contactId: 'cnt_5',
        contactName: 'Meera Shah',
        tripTitle: 'Bali family holiday',
        tripType: CrmTripType.family,
        destination: 'Ubud & Seminyak, Indonesia',
        estimatedValue: 240000,
        travelMonth: 'October 2026',
        stage: CrmPipelineStage.proposalSent,
        ownerName: 'Ankit Kumar',
        ownerInitials: 'AK',
        nextFollowUpAt: DateTime(2026, 8, 12),
        notes: 'Proposal v2 sent with villa options.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 15)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 4)),
      ),
      CrmOpportunity(
        id: 'opp_6',
        contactId: 'cnt_6',
        contactName: 'Isha Bansal',
        tripTitle: 'Maldives honeymoon',
        tripType: CrmTripType.honeymoon,
        destination: 'Male, Maldives',
        estimatedValue: 310000,
        travelMonth: 'January 2027',
        stage: CrmPipelineStage.proposalSent,
        ownerName: 'Pooja Sharma',
        ownerInitials: 'PS',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 6)),
        notes: 'Water villa proposal sent.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 12)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 3)),
      ),
      CrmOpportunity(
        id: 'opp_7',
        contactId: 'cnt_7',
        contactName: 'Neha Kapoor',
        tripTitle: 'Europe group tour',
        tripType: CrmTripType.group,
        destination: 'Paris, Swiss & Rome',
        estimatedValue: 560000,
        travelMonth: 'September 2026',
        stage: CrmPipelineStage.negotiation,
        ownerName: 'Ankit Kumar',
        ownerInitials: 'AK',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 1)),
        notes: 'Discussing group discount package.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 20)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 2)),
      ),
      CrmOpportunity(
        id: 'opp_8',
        contactId: 'cnt_8',
        contactName: 'Vikram Malhotra',
        tripTitle: 'Switzerland holiday',
        tripType: CrmTripType.family,
        destination: 'Zurich & Interlaken, Switzerland',
        estimatedValue: 780000,
        travelMonth: 'October 2026',
        stage: CrmPipelineStage.negotiation,
        ownerName: 'Ritu Verma',
        ownerInitials: 'RV',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 3)),
        notes: 'Swiss Pass add-on details requested.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 18)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 1)),
      ),
      CrmOpportunity(
        id: 'opp_9',
        contactId: 'cnt_9',
        contactName: 'Priya Menon',
        tripTitle: 'Japan cherry blossom tour',
        tripType: CrmTripType.corporate,
        destination: 'Tokyo & Kyoto, Japan',
        estimatedValue: 450000,
        travelMonth: 'March 2027',
        stage: CrmPipelineStage.won,
        ownerName: 'Pooja Sharma',
        ownerInitials: 'PS',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 15)),
        notes: 'Deposit received. Booking confirmed.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 25)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 5)),
      ),
      CrmOpportunity(
        id: 'opp_10',
        contactId: 'cnt_10',
        contactName: 'Sneha Iyer',
        tripTitle: 'Singapore family trip',
        tripType: CrmTripType.family,
        destination: 'Singapore',
        estimatedValue: 280000,
        travelMonth: 'November 2026',
        stage: CrmPipelineStage.won,
        ownerName: 'Ritu Verma',
        ownerInitials: 'RV',
        nextFollowUpAt: fixedBaseDate.add(const Duration(days: 20)),
        notes: 'Universal Studios tickets confirmed.',
        createdAt: fixedBaseDate.subtract(const Duration(days: 22)),
        updatedAt: fixedBaseDate.subtract(const Duration(days: 6)),
      ),
    ]);
  }

  Future<List<CrmOpportunity>> getOpportunities() async {
    // Simulate slight async network delay in mock
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_items);
  }

  Future<CrmOpportunity> addOpportunity(CrmOpportunity opportunity) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _items.add(opportunity);
    return opportunity;
  }

  Future<CrmOpportunity> updateOpportunity(CrmOpportunity opportunity) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _items.indexWhere((item) => item.id == opportunity.id);
    if (index != -1) {
      _items[index] = opportunity;
    }
    return opportunity;
  }

  Future<void> deleteOpportunity(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _items.removeWhere((item) => item.id == id);
  }
}
