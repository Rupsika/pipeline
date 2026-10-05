import '../domain/models/crm_follow_up.dart';

class MockCrmFollowUpsRepository {
  final List<CrmFollowUp> _items = [];

  MockCrmFollowUpsRepository() {
    _initMockData();
  }

  void _initMockData() {
    final today = DateTime.now();
    _items.addAll([
      CrmFollowUp(
        id: 'flw_1',
        opportunityId: 'opp_1',
        title: 'Confirm Phuket hotel preferences',
        contactName: 'Rohan Iyer',
        destination: 'Phuket & Bangkok, Thailand',
        dueDate: today.subtract(const Duration(days: 1)),
        isCompleted: false,
        priority: FollowUpPriority.high,
        notes: 'Needs 4-star ocean view option.',
      ),
      CrmFollowUp(
        id: 'flw_2',
        opportunityId: 'opp_7',
        title: 'Send group discount quote for Europe',
        contactName: 'Neha Kapoor',
        destination: 'Paris, Swiss & Rome',
        dueDate: today,
        isCompleted: false,
        priority: FollowUpPriority.high,
        notes: 'Finalize 10% discount clause.',
      ),
      CrmFollowUp(
        id: 'flw_3',
        opportunityId: 'opp_3',
        title: 'Check Dubai flight rates with Emirates',
        contactName: 'Arjun Nair',
        destination: 'Dubai, UAE',
        dueDate: today,
        isCompleted: false,
        priority: FollowUpPriority.medium,
      ),
      CrmFollowUp(
        id: 'flw_4',
        opportunityId: 'opp_5',
        title: 'Follow up on Bali villa proposal feedback',
        contactName: 'Meera Shah',
        destination: 'Ubud & Seminyak, Indonesia',
        dueDate: today.add(const Duration(days: 2)),
        isCompleted: false,
        priority: FollowUpPriority.medium,
      ),
      CrmFollowUp(
        id: 'flw_5',
        opportunityId: 'opp_8',
        title: 'Verify Swiss travel pass age discounts',
        contactName: 'Vikram Malhotra',
        destination: 'Zurich & Interlaken, Switzerland',
        dueDate: today.add(const Duration(days: 4)),
        isCompleted: false,
        priority: FollowUpPriority.low,
      ),
      CrmFollowUp(
        id: 'flw_6',
        opportunityId: 'opp_9',
        title: 'Send booking confirmation & invoice',
        contactName: 'Priya Menon',
        destination: 'Tokyo & Kyoto, Japan',
        dueDate: today.subtract(const Duration(days: 3)),
        isCompleted: true,
        priority: FollowUpPriority.high,
      ),
    ]);
  }

  Future<List<CrmFollowUp>> getFollowUps() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_items);
  }

  Future<CrmFollowUp> toggleCompletion(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final updated = _items[index].copyWith(isCompleted: !_items[index].isCompleted);
      _items[index] = updated;
      return updated;
    }
    throw Exception('Follow-up not found');
  }

  Future<CrmFollowUp> addFollowUp(CrmFollowUp item) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _items.add(item);
    return item;
  }
}
