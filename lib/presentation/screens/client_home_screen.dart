import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../data/models/category.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import 'post_job_screen.dart';
import 'received_bids_screen.dart';
import 'job_tracking_screen.dart';
import 'role_selection_screen.dart';
import 'worker_profile_detail_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  final AppState? appState;

  const ClientHomeScreen({super.key, this.appState});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = widget.appState ?? AppState();
    _appState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeJobs = _appState.jobs;
    final recommendedWorkers = _appState.workers;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          color: AppColors.secondary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header: Greeting, Location & Mode Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, Lucía 👋',
                          style: AppTypography.headlineSm.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Santa Victoria, Chiclayo',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.neutral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RoleSelectionScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x1F173B4D), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.swap_horiz,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Modo Técnico',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Hero CTA Banner: Publicar Chamba
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF284B5D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A173B4D),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'TIPO INDRIVE',
                              style: AppTypography.labelSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Publica una Chamba y fija tu precio en S/.',
                        style: AppTypography.headlineSm.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Los especialistas cercanos verán tu pedido y te enviarán sus ofertas o contraofertas.',
                        style: AppTypography.bodyMd.copyWith(
                          color: Colors.white70,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ChambaButton(
                        label: 'Publicar Solicitud Ahora',
                        leadingIcon: Icons.add_circle_outline,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PostJobScreen(appState: _appState),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Section: Categorías Populares
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categorías de Servicio',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '8 oficios',
                      style: AppTypography.labelMd.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildCategoriesGrid(),

                const SizedBox(height: 28),

                // Section: Tus Solicitudes Activas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tus Solicitudes Activas',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${activeJobs.length} en curso',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...activeJobs.map((job) => _buildActiveJobCard(job)),

                const SizedBox(height: 24),

                // Section: Especialistas Verificados Destacados
                Text(
                  'Técnicos Verificados en Chiclayo',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 14),
                ...recommendedWorkers.map((worker) => _buildWorkerCard(worker)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = JobCategory.defaultCategories;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PostJobScreen(
                  appState: _appState,
                  initialCategory: cat,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x14202D33), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08173B4D),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  cat.icon,
                  size: 26,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cat.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelSm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveJobCard(JobRequest job) {
    final hasOffers = job.bids.isNotEmpty;
    final isOnTheWayOrActive = job.status == JobStatus.onTheWay || job.status == JobStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: ChambaCard(
        onTap: () {
          _appState.setActiveJob(job.id);
          if (isOnTheWayOrActive) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => JobTrackingScreen(appState: _appState, job: job),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReceivedBidsScreen(appState: _appState, job: job),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              job.categoryName.toUpperCase(),
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            job.district,
                            style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        job.title,
                        style: AppTypography.bodyLgMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'S/. ${job.budget.toStringAsFixed(0)}',
                      style: AppTypography.numericBid.copyWith(
                        color: AppColors.secondary,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Presupuesto',
                      style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0x14202D33)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasOffers) ...[
                  ChambaBadge.counterReceived(
                    label: '${job.bids.length} Ofertas recibidas',
                  ),
                  Row(
                    children: [
                      Text(
                        'Revisar ofertas',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.secondary),
                    ],
                  ),
                ] else if (isOnTheWayOrActive) ...[
                  ChambaBadge.confirmed(label: job.status.displayLabel),
                  Row(
                    children: [
                      Text(
                        'Ver seguimiento',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.tertiary),
                    ],
                  ),
                ] else ...[
                  const ChambaBadge.negotiating(label: 'Buscando especialistas...'),
                  Text(
                    'Ver detalles',
                    style: AppTypography.labelMd.copyWith(color: AppColors.muted),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(dynamic worker) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ChambaCard(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WorkerProfileDetailScreen(worker: worker),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: Text(
                worker.avatarInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          worker.name,
                          style: AppTypography.bodyLgMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral,
                          ),
                        ),
                      ),
                      if (worker.isVerified)
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: AppColors.tertiary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    worker.skills.take(2).join(' • '),
                    style: AppTypography.labelMd.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${worker.rating}',
                        style: AppTypography.labelSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral,
                        ),
                      ),
                      Text(
                        ' (${worker.completedJobs} chambas)',
                        style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
