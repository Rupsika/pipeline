import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_contact.dart';
import 'package:sch_track/features/travel_crm/providers/crm_contacts_provider.dart';
import 'package:sch_track/shared/widgets/app_button.dart';
import 'package:sch_track/shared/widgets/avatar_circle.dart';
import 'package:sch_track/shared/widgets/status_badge.dart';

class CrmContactsSection extends ConsumerWidget {
  const CrmContactsSection({super.key});

  void _openAddContactDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final locationCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Traveller Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email Address *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: locationCtrl,
                decoration: const InputDecoration(labelText: 'Location / City *'),
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
              if (nameCtrl.text.trim().isEmpty) return;

              final newContact = CrmContact(
                id: 'cnt_${DateTime.now().millisecondsSinceEpoch}',
                name: nameCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                location: locationCtrl.text.trim(),
                createdAt: DateTime.now(),
              );

              await ref.read(crmContactsProvider.notifier).addContact(newContact);
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contact "${newContact.name}" added successfully.')),
                );
              }
            },
            child: const Text('Add Contact', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crmContactsProvider);
    final notifier = ref.read(crmContactsProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar: Search + Filter + Add Button
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
                      hintText: 'Search contacts by name, email, location, tags...',
                      prefixIcon: Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: state.selectedStatus,
                  hint: const Text('Status Filter'),
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All Statuses')),
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Lead', child: Text('Lead')),
                    DropdownMenuItem(value: 'VIP', child: Text('VIP')),
                  ],
                  onChanged: notifier.setSelectedStatus,
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: 'Add Contact',
                  icon: const Icon(Icons.person_add_alt, size: 16),
                  onPressed: () => _openAddContactDialog(context, ref),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // Contacts Grid
          if (state.filteredContacts.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('No contacts found matching criteria.', style: TextStyle(color: AppColors.textMuted)),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900
                    ? 3
                    : constraints.maxWidth > 600
                        ? 2
                        : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    mainAxisExtent: 180,
                  ),
                  itemCount: state.filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = state.filteredContacts[index];
                    return _ContactCard(contact: contact);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final CrmContact contact;

  const _ContactCard({required this.contact});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'VIP':
        return Colors.purple;
      case 'Active':
        return Colors.green;
      case 'Lead':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarCircle(
                initials: _getInitials(contact.name),
                radius: 18,
                backgroundColor: const Color(0xFFEFF6FF),
                textColor: const Color(0xFF2563EB),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      contact.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: contact.status,
                color: _getStatusColor(contact.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  contact.email,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                contact.phone,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          if (contact.tags.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: contact.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
