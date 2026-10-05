import '../domain/models/crm_contact.dart';

class MockCrmContactsRepository {
  final List<CrmContact> _contacts = [];

  MockCrmContactsRepository() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime(2026, 8, 1);
    _contacts.addAll([
      CrmContact(
        id: 'cnt_1',
        name: 'Rohan Iyer',
        email: 'rohan.iyer@example.com',
        phone: '+91 98765 43210',
        location: 'Mumbai, India',
        totalDeals: 2,
        totalSpent: 240000,
        status: 'Active',
        tags: ['Solo Traveler', 'Beach Lover'],
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      CrmContact(
        id: 'cnt_2',
        name: 'Kavya Reddy',
        email: 'kavya.reddy@example.com',
        phone: '+91 98123 45678',
        location: 'Bengaluru, India',
        totalDeals: 1,
        totalSpent: 95000,
        status: 'Lead',
        tags: ['Custom Itinerary', 'Luxury'],
        createdAt: now.subtract(const Duration(days: 45)),
      ),
      CrmContact(
        id: 'cnt_3',
        name: 'Arjun Nair',
        email: 'arjun.nair@example.com',
        phone: '+91 99887 76655',
        location: 'Kochi, India',
        totalDeals: 3,
        totalSpent: 420000,
        status: 'VIP',
        tags: ['Honeymoon', 'High Value'],
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      CrmContact(
        id: 'cnt_4',
        name: 'Amit Deshpande',
        email: 'amit.d@example.com',
        phone: '+91 97654 32109',
        location: 'Pune, India',
        totalDeals: 1,
        totalSpent: 620000,
        status: 'Lead',
        tags: ['Group Tour', 'Road Trip'],
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      CrmContact(
        id: 'cnt_5',
        name: 'Meera Shah',
        email: 'meera.shah@example.com',
        phone: '+91 98989 12345',
        location: 'Ahmedabad, India',
        totalDeals: 2,
        totalSpent: 310000,
        status: 'Active',
        tags: ['Family Trip'],
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      CrmContact(
        id: 'cnt_6',
        name: 'Priya Menon',
        email: 'priya.menon@corporate.com',
        phone: '+91 91234 56789',
        location: 'Chennai, India',
        totalDeals: 4,
        totalSpent: 1250000,
        status: 'VIP',
        tags: ['Corporate', 'International'],
        createdAt: now.subtract(const Duration(days: 200)),
      ),
    ]);
  }

  Future<List<CrmContact>> getContacts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_contacts);
  }

  Future<CrmContact> addContact(CrmContact contact) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _contacts.add(contact);
    return contact;
  }
}
