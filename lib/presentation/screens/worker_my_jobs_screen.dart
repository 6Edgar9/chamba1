import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import 'chat_screen.dart';
import 'job_tracking_screen.dart';
import '../widgets/worker_earnings_dashboard.dart';

class WorkerMyJobsScreen extends StatefulWidget {
  final AppState appState;

  const WorkerMyJobsScreen({
    super.key,
    required this.appState,
  });

  @override
  State<WorkerMyJobsScreen> createState() => _WorkerMyJobsScreenState();
}

class _WorkerMyJobsScreenState extends State<WorkerMyJobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    widget.appState.addListener(_onStateUpdate);
  }

  void _onStateUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.appState.removeListener(_onStateUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allWorkerJobs = widget.appState.jobs;
    final workerId = widget.appState.currentWorkerProfile.id;

    final activeJobs = allWorkerJobs.where((j) {
      final isAccepted = j.workerId == workerId || j.acceptedBidId != null;
      return isAccepted && (j.status == JobStatus.onTheWay || j.status == JobStatus.inProgress);
    }).toList();

    final negotiatingJobs = allWorkerJobs.where((j) {
      final hasBid = j.bids.any((b) => b.workerId == workerId);
      return hasBid && (j.status == JobStatus.searching || j.status == JobStatus.negotiating);
    }).toList();

    final completedJobs = allWorkerJobs.where((j) {
      return j.status == JobStatus.completed;
    }).toList();

    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Mis Trabajos'),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: WorkerEarningsDashboard(
                    appState: widget.appState,
                    compact: false,
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.secondary,
                    unselectedLabelColor: AppColors.muted,
                    indicatorColor: AppColors.secondary,
                    indicatorWeight: 3,
                    labelStyle: AppTypography.bodyMdMedium.copyWith(fontWeight: FontWeight.w700),
                    tabs: [
                      Tab(text: 'Activas (${activeJobs.length})'),
                      Tab(text: 'Negociando (${negotiatingJobs.length})'),
                      Tab(text: 'Historial (${completedJobs.length})'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildJobList(activeJobs, 'No tienes servicios activos en este momento.'),
              _buildJobList(negotiatingJobs, 'No tienes cotizaciones en negociación actualmente.'),
              _buildJobList(completedJobs, 'Aún no registras chambas completadas.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobList(List<JobRequest> jobs, String emptyMessage) {
    if (jobs.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox_outlined, size: 44, color: AppColors.muted),
              const SizedBox(height: 10),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ChambaCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => JobTrackingScreen(appState: widget.appState, job: job),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      job.categoryName.toUpperCase(),
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ChambaBadge(
                      label: job.status.displayLabel,
                      type: job.status == JobStatus.completed
                          ? ChambaBadgeType.confirmed
                          : ChambaBadgeType.counterReceived,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  job.title,
                  style: AppTypography.bodyLgMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cliente: ${job.clientName} • ${job.district}',
                  style: AppTypography.labelMd.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0x14202D33)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'S/. ',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          job.budget.toStringAsFixed(0),
                          style: AppTypography.numericBid.copyWith(
                            color: AppColors.secondary,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, size: 20),
                          color: AppColors.primary,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(appState: widget.appState, job: job),
                              ),
                            );
                          },
                        ),
                        ChambaButton.pill(
                          label: 'Ver Detalles',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => JobTrackingScreen(appState: widget.appState, job: job),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.canvas,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}
