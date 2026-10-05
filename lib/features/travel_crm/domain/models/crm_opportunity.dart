enum CrmPipelineStage {
  newEnquiry,
  qualified,
  proposalSent,
  negotiation,
  won,
}

extension CrmPipelineStageX on CrmPipelineStage {
  String get label {
    switch (this) {
      case CrmPipelineStage.newEnquiry:
        return 'New Enquiry';
      case CrmPipelineStage.qualified:
        return 'Qualified';
      case CrmPipelineStage.proposalSent:
        return 'Proposal Sent';
      case CrmPipelineStage.negotiation:
        return 'Negotiation';
      case CrmPipelineStage.won:
        return 'Won';
    }
  }
}

enum CrmTripType {
  solo,
  honeymoon,
  family,
  group,
  corporate,
  custom,
}

extension CrmTripTypeX on CrmTripType {
  String get label {
    switch (this) {
      case CrmTripType.solo:
        return 'Solo';
      case CrmTripType.honeymoon:
        return 'Honeymoon';
      case CrmTripType.family:
        return 'Family';
      case CrmTripType.group:
        return 'Group';
      case CrmTripType.corporate:
        return 'Corporate';
      case CrmTripType.custom:
        return 'Custom';
    }
  }
}

class CrmOpportunity {
  final String id;
  final String? contactId;
  final String contactName;
  final String tripTitle;
  final CrmTripType tripType;
  final String destination;
  final double estimatedValue;
  final String travelMonth;
  final CrmPipelineStage stage;
  final String ownerName;
  final String ownerInitials;
  final DateTime nextFollowUpAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CrmOpportunity({
    required this.id,
    this.contactId,
    required this.contactName,
    required this.tripTitle,
    required this.tripType,
    required this.destination,
    required this.estimatedValue,
    required this.travelMonth,
    required this.stage,
    required this.ownerName,
    required this.ownerInitials,
    required this.nextFollowUpAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  CrmOpportunity copyWith({
    String? id,
    String? contactId,
    String? contactName,
    String? tripTitle,
    CrmTripType? tripType,
    String? destination,
    double? estimatedValue,
    String? travelMonth,
    CrmPipelineStage? stage,
    String? ownerName,
    String? ownerInitials,
    DateTime? nextFollowUpAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrmOpportunity(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      tripTitle: tripTitle ?? this.tripTitle,
      tripType: tripType ?? this.tripType,
      destination: destination ?? this.destination,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      travelMonth: travelMonth ?? this.travelMonth,
      stage: stage ?? this.stage,
      ownerName: ownerName ?? this.ownerName,
      ownerInitials: ownerInitials ?? this.ownerInitials,
      nextFollowUpAt: nextFollowUpAt ?? this.nextFollowUpAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrmOpportunity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
