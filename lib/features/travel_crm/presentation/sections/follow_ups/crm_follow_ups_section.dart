import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_follow_up.dart';
import 'package:sch_track/features/travel_crm/providers/crm_follow_ups_provider.dart';
import 'package:sch_track/features/travel_crm/providers/crm_pipeline_provider.dart';
import 'package:sch_track/shared/widgets/app_button.dart';
import 'package:sch_track/shared/widgets/status_badge.dart';

class CrmFollowUpsSection extends ConsumerWidget {
  const CrmFollowUpsSection({super.key});

  void _openAddFollowUpDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final pipelineState = ref.read(crmPipelineProvider);
    String? selectedOppId = pipelineState.opportunities.isNotEmpty
        ? pipelineState.opportunities.first.id
        : null;
    FollowUpPriority selectedPriority = FollowUpPriority.medium;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Schedule Follow-up Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Task Title *'),
                  ),
                  const SizedBox(height: 12),
                  const Text('Select Linked Opportunity:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedOppId,
                    items: pipelineState.opportunities
                        .map(
                          (opp) => DropdownMenuItem(
                            value: opp.id,
                            child: Text('${opp.tripTitle} (${opp.contactName})'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() => selectedOppId = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Priority: ', style: TextStyle(fontSize: 13)),
                      DropdownButton<FollowUpPriority>(
                        value: selectedPriority,
                        items: FollowUpPriority.values
                            .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedPriority = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Due Date: ${DateFormat('d MMM yyyy').format(selectedDate)}'),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: const Text('Change Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(labelText: 'Notes (optional)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6600)),
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty || selectedOppId == null) return;

                  final opp = pipelineState.opportunities.firstWhere((o) => o.id == selectedOppId);

                  final newItem = CrmFollowUp(
                    id: 'flw_${DateTime.now().millisecondsSinceEpoch}',
                    opportunityId: opp.id,
                    title: titleCtrl.text.trim(),
                    contactName: opp.contactName,
                    destination: opp.destination,
                    dueDate: selectedDate,
                    priority: selectedPriority,
                    notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                  );

                  await ref.read(crmFollowUpsProvider.notifier).addFollowUp(newItem);
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Scheduled follow-up "${newItem.title}".')),
                    );
                  }
                },
                child: const Text('Schedule', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crmFollowUpsProvider);
    final notifier = ref.read(crmFollowUpsProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final overdue = state.overdueItems;
    final today = state.todayItems;
    final upcoming = state.upcomingItems;
    final completed = state.completedItems;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Toolbar
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: notifier.setSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Search follow-ups by title, contact, destination...',
                      prefixIcon: Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Checkbox(
                      value: state.showCompletedOnly,
                      onChanged: (val) => notifier.setShowCompletedOnly(val ?? false),
                    ),
                    const Text('Show Completed Only', style: TextStyle(fontSize: 13)),
                  ],
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: 'New Follow-up',
                  icon: const Icon(Icons.add_task, size: 16),
                  onPressed: () => _openAddFollowUpDialog(context, ref),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // Follow-up Groups
          if (state.showCompletedOnly) ...[
            _GroupHeader(title: 'Completed Tasks', count: completed.length, color: Colors.green),
            SizedBox(height: AppSpacing.xs),
            ...completed.map((item) => _FollowUpCard(item: item, notifier: notifier)),
          ] else ...[
            if (overdue.isNotEmpty) ...[
              _GroupHeader(title: 'Overdue Reminders', count: overdue.length, color: Colors.red),
              SizedBox(height: AppSpacing.xs),
              ...overdue.map((item) => _FollowUpCard(item: item, notifier: notifier)),
              SizedBox(height: AppSpacing.md),
            ],
            if (today.isNotEmpty) ...[
              _GroupHeader(title: 'Due Today', count: today.length, color: const Color(0xFFFF6600)),
              SizedBox(height: AppSpacing.xs),
              ...today.map((item) => _FollowUpCard(item: item, notifier: notifier)),
              SizedBox(height: AppSpacing.md),
            ],
            if (upcoming.isNotEmpty) ...[
              _GroupHeader(title: 'Upcoming Reminders', count: upcoming.length, color: Colors.blue),
              SizedBox(height: AppSpacing.xs),
              ...upcoming.map((item) => _FollowUpCard(item: item, notifier: notifier)),
              SizedBox(height: AppSpacing.md),
            ],
            if (overdue.isEmpty && today.isEmpty && upcoming.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('No pending follow-ups!', style: TextStyle(color: AppColors.textMuted)),
              ),
          ],
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _GroupHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  final CrmFollowUp item;
  final CrmFollowUpsNotifier notifier;

  const _FollowUpCard({required this.item, required this.notifier});

  Color _getPriorityColor(FollowUpPriority priority) {
    switch (priority) {
      case FollowUpPriority.high:
        return Colors.red;
      case FollowUpPriority.medium:
        return Colors.orange;
      case FollowUpPriority.low:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = item.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isDone,
            activeColor: const Color(0xFFFF6600),
            onChanged: (_) => notifier.toggleCompletion(item.id),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Contact: ${item.contactName} • ${item.destination}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Notes: ${item.notes}',
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          StatusBadge(
            label: item.priority.label,
            color: _getPriorityColor(item.priority),
          ),
          const SizedBox(width: 12),
          Text(
            DateFormat('d MMM').format(item.dueDate),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
