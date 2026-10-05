import 'package:flutter/material.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/shared/widgets/app_button.dart';
import 'package:sch_track/shared/widgets/app_dropdown_menu.dart';
import 'package:sch_track/shared/widgets/app_text_field.dart';

class CrmPipelineToolbar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String? selectedOwner;
  final List<String> availableOwners;
  final ValueChanged<String?> onOwnerChanged;
  final CrmTripType? selectedTripType;
  final ValueChanged<CrmTripType?> onTripTypeChanged;
  final bool isFilterActive;
  final VoidCallback onClearFilters;
  final VoidCallback onAddOpportunity;

  const CrmPipelineToolbar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedOwner,
    required this.availableOwners,
    required this.onOwnerChanged,
    required this.selectedTripType,
    required this.onTripTypeChanged,
    required this.isFilterActive,
    required this.onClearFilters,
    required this.onAddOpportunity,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isMobile = availableWidth < 500;

        return Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              // Search Field
              SizedBox(
                width: isMobile ? double.infinity : 200,
                child: AppTextField(
                  hintText: 'Search opportunities...',
                  initialValue: searchQuery.isEmpty ? null : searchQuery,
                  onChanged: onSearchChanged,
                  prefixIcon: const Icon(Icons.search, size: 18),
                ),
              ),

              // Owner Filter
              SizedBox(
                width: isMobile ? double.infinity : 160,
                child: AppDropdownMenu<String?>(
                  value: selectedOwner,
                  hintText: 'All owners',
                  onChanged: onOwnerChanged,
                  items: [
                    const AppDropdownItem<String?>(
                      value: null,
                      label: 'All owners',
                    ),
                    ...availableOwners.map(
                      (owner) => AppDropdownItem<String?>(
                        value: owner,
                        label: owner,
                      ),
                    ),
                  ],
                ),
              ),

              // Trip Type Filter
              SizedBox(
                width: isMobile ? double.infinity : 160,
                child: AppDropdownMenu<CrmTripType?>(
                  value: selectedTripType,
                  hintText: 'All trip types',
                  onChanged: onTripTypeChanged,
                  items: [
                    const AppDropdownItem<CrmTripType?>(
                      value: null,
                      label: 'All trip types',
                    ),
                    ...CrmTripType.values.map(
                      (type) => AppDropdownItem<CrmTripType?>(
                        value: type,
                        label: type.label,
                      ),
                    ),
                  ],
                ),
              ),

              // Clear Filters Action
              if (isFilterActive)
                AppButton(
                  label: 'Clear Filters',
                  variant: AppButtonVariant.text,
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: onClearFilters,
                ),

              // Add Opportunity Action
              AppButton(
                label: 'Add Opportunity',
                icon: const Icon(Icons.add, size: 18),
                onPressed: onAddOpportunity,
              ),
            ],
          ),
        );
      },
    );
  }
}
