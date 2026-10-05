import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sch_track/core/constants/app_colors.dart';
import 'package:sch_track/core/constants/app_spacing.dart';
import 'package:sch_track/features/travel_crm/domain/models/crm_opportunity.dart';
import 'package:sch_track/features/travel_crm/providers/crm_pipeline_provider.dart';

class CrmOverviewSection extends ConsumerWidget {
  const CrmOverviewSection({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crmPipelineProvider);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final totalOpps = state.opportunities.length;
    final wonOpps = state.wonCount;
    final winRate = totalOpps > 0 ? ((wonOpps / totalOpps) * 100).toStringAsFixed(1) : '0';

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Metric Cards Row
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _MetricCard(
                title: 'Total Opportunities',
                value: '$totalOpps',
                icon: Icons.assignment_outlined,
                color: const Color(0xFF3B82F6),
                subtitle: 'Active & closed deals',
              ),
              _MetricCard(
                title: 'Active Pipeline Value',
                value: _formatCurrency(state.activePipelineValue),
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFFFF6600),
                subtitle: 'Unwon opportunities',
              ),
              _MetricCard(
                title: 'Won Revenue',
                value: _formatCurrency(state.wonValue),
                icon: Icons.verified_outlined,
                color: const Color(0xFF10B981),
                subtitle: '$wonOpps confirmed bookings',
              ),
              _MetricCard(
                title: 'Win Rate',
                value: '$winRate%',
                icon: Icons.trending_up,
                color: const Color(0xFF8B5CF6),
                subtitle: 'Conversion percentage',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          // Two-column layout for Stage Distribution & Popular Destinations
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _StageDistributionCard(state: state)),
                        SizedBox(width: AppSpacing.md),
                        Expanded(child: _DestinationsCard(state: state)),
                      ],
                    )
                  : Column(
                      children: [
                        _StageDistributionCard(state: state),
                        SizedBox(height: AppSpacing.md),
                        _DestinationsCard(state: state),
                      ],
                    );
            },
          ),
          SizedBox(height: AppSpacing.lg),

          // Recent Activity Stream
          _RecentActivityCard(state: state),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageDistributionCard extends StatelessWidget {
  final CrmPipelineViewState state;

  const _StageDistributionCard({required this.state});

  Color _getStageColor(CrmPipelineStage stage) {
    switch (stage) {
      case CrmPipelineStage.newEnquiry:
        return AppColors.stageNewEnquiry;
      case CrmPipelineStage.qualified:
        return AppColors.stageQualified;
      case CrmPipelineStage.proposalSent:
        return AppColors.stageProposalSent;
      case CrmPipelineStage.negotiation:
        return AppColors.stageNegotiation;
      case CrmPipelineStage.won:
        return AppColors.stageWon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = state.opportunities.length;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stage Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Opportunities grouped by sales pipeline stage',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          ...CrmPipelineStage.values.map((stage) {
            final count = state.countForStage(stage);
            final percent = total > 0 ? count / total : 0.0;
            final color = _getStageColor(stage);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stage.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$count (${(percent * 100).toStringAsFixed(0)}%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DestinationsCard extends StatelessWidget {
  final CrmPipelineViewState state;

  const _DestinationsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final destMap = <String, int>{};
    for (var o in state.opportunities) {
      final dest = o.destination.split(',').last.trim();
      destMap[dest] = (destMap[dest] ?? 0) + 1;
    }

    final sortedEntries = destMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Destinations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Most requested travel regions',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          if (sortedEntries.isEmpty)
            const Text('No data available', style: TextStyle(color: AppColors.textMuted))
          else
            ...sortedEntries.take(5).map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        color: Color(0xFFFF6600),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.value} deals',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final CrmPipelineViewState state;

  const _RecentActivityCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final recentOpps = List<CrmOpportunity>.from(state.opportunities)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Opportunity Activities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Latest status and stage updates across active deals',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          if (recentOpps.isEmpty)
            const Text('No recent activities', style: TextStyle(color: AppColors.textMuted))
          else
            ...recentOpps.take(5).map((opp) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFFE2E8F0),
                      child: Text(
                        opp.ownerInitials,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${opp.ownerName} updated stage for "${opp.tripTitle}"',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Contact: ${opp.contactName} • Stage: ${opp.stage.label}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${(opp.estimatedValue / 1000).toStringAsFixed(0)}k',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6600),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
