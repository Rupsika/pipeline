import 'package:flutter/material.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/shared/widgets/app_button.dart';

class PipelineLoadingState extends StatelessWidget {
  const PipelineLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppSpacing.md),
            Text(
              'Loading Travel CRM Pipeline...',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PipelineErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PipelineErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Try Again',
              icon: const Icon(Icons.refresh, size: 16),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class PipelineEmptyFilterState extends StatelessWidget {
  final VoidCallback onClearFilters;

  const PipelineEmptyFilterState({
    super.key,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No opportunities match your search or filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Try adjusting your search query, owner filter, or trip-type filter.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Clear Filters',
            icon: const Icon(Icons.clear, size: 16),
            variant: AppButtonVariant.secondary,
            onPressed: onClearFilters,
          ),
        ],
      ),
    );
  }
}
