import 'package:flutter/material.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/shared/widgets/avatar_circle.dart';
import '../sections/contacts/crm_contacts_section.dart';
import '../sections/follow_ups/crm_follow_ups_section.dart';
import '../sections/overview/crm_overview_section.dart';
import '../sections/pipeline/crm_pipeline_section.dart';

class TravelCrmPage extends StatefulWidget {
  const TravelCrmPage({super.key});

  @override
  State<TravelCrmPage> createState() => _TravelCrmPageState();
}

class _TravelCrmPageState extends State<TravelCrmPage> {
  int _selectedTab = 2; // 0: Overview, 1: Contacts, 2: Pipeline, 3: Follow-ups

  Widget _buildTabBody() {
    switch (_selectedTab) {
      case 0:
        return const CrmOverviewSection();
      case 1:
        return const CrmContactsSection();
      case 2:
        return const CrmPipelineSection();
      case 3:
        return const CrmFollowUpsSection();
      default:
        return const CrmPipelineSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: Row(
        children: [
          // Left Sidebar
          const _CrmSidebar(),

          // Main Section Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Page Header
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.xl,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Travel CRM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Manage enquiries and sales opportunities',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Tabs Navigation Header
                      Row(
                        children: [
                          _NavTab(
                            label: 'Overview',
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          _NavTab(
                            label: 'Contacts',
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          _NavTab(
                            label: 'Pipeline',
                            isSelected: _selectedTab == 2,
                            onTap: () => setState(() => _selectedTab = 2),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          _NavTab(
                            label: 'Follow-ups',
                            isSelected: _selectedTab == 3,
                            onTap: () => setState(() => _selectedTab = 3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),

                // Tab Content Body
                Expanded(
                  child: _buildTabBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Overview Section';
      case 1:
        return 'Contacts Section';
      case 3:
        return 'Follow-ups Section';
      default:
        return 'Pipeline Section';
    }
  }
}

class _CrmSidebar extends StatelessWidget {
  const _CrmSidebar();

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 900;

    if (isNarrow) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 220,
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SCH Track',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'TRAVEL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6600),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Nav Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                _SidebarItem(icon: Icons.grid_view_rounded, label: 'Dashboard'),
                _SidebarItem(icon: Icons.map_outlined, label: 'Itinerary Planner'),
                _SidebarItem(icon: Icons.location_on_outlined, label: 'Trips & Live Tracking'),
                _SidebarItem(icon: Icons.people_outline, label: 'My Travellers'),
                _SidebarItem(icon: Icons.phone_android_outlined, label: 'Traveller App Access'),
                _SidebarItem(
                  icon: Icons.people_alt_outlined,
                  label: 'Travel CRM',
                  isActive: true,
                ),
                _SidebarItem(icon: Icons.description_outlined, label: 'Documents'),
                _SidebarItem(icon: Icons.account_balance_wallet_outlined, label: 'Finance'),
                _SidebarItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
                _SidebarItem(icon: Icons.settings_outlined, label: 'Settings'),
              ],
            ),
          ),

          // Bottom User Profile Tile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: const Row(
              children: [
                AvatarCircle(
                  initials: 'SK',
                  radius: 16,
                  backgroundColor: Color(0xFF334155),
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sonia Kapoor',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF6600) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : const Color(0xFF94A3B8),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFFCBD5E1),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFFF6600) : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFFFF6600) : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dashboard_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Switch to the Pipeline tab to manage travel opportunities.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
