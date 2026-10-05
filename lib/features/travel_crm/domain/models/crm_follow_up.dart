enum FollowUpPriority { low, medium, high }

extension FollowUpPriorityX on FollowUpPriority {
  String get label {
    switch (this) {
      case FollowUpPriority.low:
        return 'Low';
      case FollowUpPriority.medium:
        return 'Medium';
      case FollowUpPriority.high:
        return 'High';
    }
  }
}

class CrmFollowUp {
  final String id;
  final String opportunityId;
  final String title;
  final String contactName;
  final String destination;
  final DateTime dueDate;
  final bool isCompleted;
  final FollowUpPriority priority;
  final String? notes;

  const CrmFollowUp({
    required this.id,
    required this.opportunityId,
    required this.title,
    required this.contactName,
    required this.destination,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = FollowUpPriority.medium,
    this.notes,
  });

  CrmFollowUp copyWith({
    String? id,
    String? opportunityId,
    String? title,
    String? contactName,
    String? destination,
    DateTime? dueDate,
    bool? isCompleted,
    FollowUpPriority? priority,
    String? notes,
  }) {
    return CrmFollowUp(
      id: id ?? this.id,
      opportunityId: opportunityId ?? this.opportunityId,
      title: title ?? this.title,
      contactName: contactName ?? this.contactName,
      destination: destination ?? this.destination,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrmFollowUp &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
