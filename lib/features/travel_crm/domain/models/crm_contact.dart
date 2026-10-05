class CrmContact {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final int totalDeals;
  final double totalSpent;
  final String status; // 'Active', 'Lead', 'VIP', 'Inactive'
  final List<String> tags;
  final DateTime createdAt;

  const CrmContact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.totalDeals = 0,
    this.totalSpent = 0.0,
    this.status = 'Active',
    this.tags = const [],
    required this.createdAt,
  });

  CrmContact copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    int? totalDeals,
    double? totalSpent,
    String? status,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return CrmContact(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      totalDeals: totalDeals ?? this.totalDeals,
      totalSpent: totalSpent ?? this.totalSpent,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrmContact &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
