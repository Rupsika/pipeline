import 'package:flutter/material.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/shared/widgets/app_button.dart';
import 'package:sch_track/shared/widgets/app_dropdown_menu.dart';
import 'package:sch_track/shared/widgets/app_text_field.dart';

class AddOpportunityDialog extends StatefulWidget {
  final ValueChanged<CrmOpportunity> onSubmit;
  final List<String> availableOwners;
  final CrmPipelineStage initialStage;

  const AddOpportunityDialog({
    super.key,
    required this.onSubmit,
    required this.availableOwners,
    this.initialStage = CrmPipelineStage.newEnquiry,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<CrmOpportunity> onSubmit,
    required List<String> availableOwners,
    CrmPipelineStage initialStage = CrmPipelineStage.newEnquiry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddOpportunityDialog(
        onSubmit: onSubmit,
        availableOwners: availableOwners,
        initialStage: initialStage,
      ),
    );
  }

  @override
  State<AddOpportunityDialog> createState() => _AddOpportunityDialogState();
}

class _AddOpportunityDialogState extends State<AddOpportunityDialog> {
  final _formKey = GlobalKey<FormState>();

  final _contactNameController = TextEditingController();
  final _tripTitleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _estimatedValueController = TextEditingController();
  final _travelMonthController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _notesController = TextEditingController();

  CrmTripType _selectedTripType = CrmTripType.family;
  late CrmPipelineStage _selectedStage;
  final DateTime _nextFollowUpAt = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _selectedStage = widget.initialStage;
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _tripTitleController.dispose();
    _destinationController.dispose();
    _estimatedValueController.dispose();
    _travelMonthController.dispose();
    _ownerNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'OP';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _contactNameController.text.trim();
    final title = _tripTitleController.text.trim();
    final dest = _destinationController.text.trim();
    final val = double.parse(_estimatedValueController.text.trim());
    final month = _travelMonthController.text.trim();
    final owner = _ownerNameController.text.trim();

    final newOpportunity = CrmOpportunity(
      id: 'opp_${DateTime.now().millisecondsSinceEpoch}',
      contactName: name,
      tripTitle: title,
      tripType: _selectedTripType,
      destination: dest,
      estimatedValue: val,
      travelMonth: month,
      stage: _selectedStage,
      ownerName: owner,
      ownerInitials: _getInitials(owner),
      nextFollowUpAt: _nextFollowUpAt,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSubmit(newOpportunity);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 540,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Travel Opportunity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: AppSpacing.sm),

              // Form fields list
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Contact Name
                      AppTextField(
                        label: 'Contact Name *',
                        hintText: 'e.g. Meera Shah',
                        controller: _contactNameController,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Contact name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Trip Title & Trip Type
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Trip Title *',
                              hintText: 'e.g. Bali family holiday',
                              controller: _tripTitleController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Trip title is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppDropdownMenu<CrmTripType>(
                              label: 'Trip Type *',
                              value: _selectedTripType,
                              items: CrmTripType.values
                                  .map(
                                    (type) => AppDropdownItem<CrmTripType>(
                                      value: type,
                                      label: type.label,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedTripType = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Destination
                      AppTextField(
                        label: 'Destination *',
                        hintText: 'e.g. Ubud & Seminyak, Indonesia',
                        controller: _destinationController,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Destination is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Estimated Value & Travel Month
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Estimated Value (₹) *',
                              hintText: 'e.g. 240000',
                              controller: _estimatedValueController,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Estimated value is required';
                                }
                                final numVal = double.tryParse(val.trim());
                                if (numVal == null || numVal <= 0) {
                                  return 'Must be a positive number';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              label: 'Travel Month *',
                              hintText: 'e.g. October 2026',
                              controller: _travelMonthController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Travel month is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Assigned Owner & Initial Stage
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Assigned Owner *',
                              hintText: 'e.g. Ankit Kumar',
                              controller: _ownerNameController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Owner name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppDropdownMenu<CrmPipelineStage>(
                              label: 'Initial Stage *',
                              value: _selectedStage,
                              items: CrmPipelineStage.values
                                  .map(
                                    (stage) => AppDropdownItem<CrmPipelineStage>(
                                      value: stage,
                                      label: stage.label,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedStage = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Notes
                      AppTextField(
                        label: 'Notes (Optional)',
                        hintText: 'Add initial notes or customer preferences...',
                        controller: _notesController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.md),
              const Divider(),
              SizedBox(height: AppSpacing.sm),

              // Actions Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.outline,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  AppButton(
                    label: 'Save Opportunity',
                    onPressed: _submit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
