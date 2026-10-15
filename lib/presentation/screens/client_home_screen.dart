import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../core/widgets/role_switcher_pill.dart';
import '../../data/models/category.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import 'post_job_screen.dart';
import 'received_bids_screen.dart';
import 'job_tracking_screen.dart';
import 'role_selection_screen.dart';
import 'worker_profile_detail_screen.dart';
import 'chat_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  final AppState? appState;
  final bool showBottomNav;

  const ClientHomeScreen({
    super.key,
    this.appState,
    this.showBottomNav = false,
  });

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen>
    with SingleTickerProviderStateMixin {
  late AppState _appState;
  late AnimationController _radarController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _appState = widget.appState ?? AppState();
    _appState.addListener(_onStateChange);
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    _radarController.dispose();
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
                LayoutBuilder(
                  builder: (context, headerConstraints) {
                    final isCompactHeader = headerConstraints.maxWidth < 360;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, ${_appState.clientName.split(" ").first} 👋',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                  Flexible(
                                    child: Text(
                                      _appState.clientDistrict,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelMd.copyWith(
                                        color: AppColors.neutral,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                        ),
                        const SizedBox(width: 8),
                        RoleSwitcherPill(
                          appState: _appState,
                          compact: isCompactHeader,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 18),

                // FEATURE 2: Chamba SOS Emergency Radar Section (< 30 min)
                _buildChambaSosSection(),

                const SizedBox(height: 18),

                // Hero CTA Banner: Publicar Chamba Standard
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
                    Expanded(
                      child: Text(
                        'Categorías de Servicio',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                    Expanded(
                      child: Text(
                        'Tus Solicitudes Activas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
      bottomNavigationBar: widget.showBottomNav
          ? Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x0F173B4D),
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) {
              if (_appState.jobs.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReceivedBidsScreen(
                      appState: _appState,
                      job: _appState.jobs.first,
                    ),
                  ),
                );
              }
            } else if (index == 2) {
              if (_appState.jobs.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      appState: _appState,
                      job: _appState.jobs.first,
                    ),
                  ),
                );
              }
            } else if (index == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RoleSelectionScreen(),
                ),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: AppColors.muted,
          selectedLabelStyle: AppTypography.labelSm.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: AppTypography.labelSm,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Solicitudes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      )
          : null,
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = JobCategory.defaultCategories;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 340;
        final aspectRatio = isCompact ? 0.72 : 0.85;
        final iconBoxSize = isCompact ? 46.0 : 56.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: isCompact ? 8 : 10,
            mainAxisSpacing: 12,
            childAspectRatio: aspectRatio,
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
                    width: iconBoxSize,
                    height: iconBoxSize,
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
                      size: isCompact ? 22 : 26,
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
                      fontSize: isCompact ? 10.5 : 12,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChambaSosSection() {
    return AnimatedBuilder(
      animation: _radarController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF991B1B), Color(0xFFDC2626), Color(0xFFB91C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.sosRed.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Radar Pulse Ripple Animation
              Positioned(
                right: -20,
                top: -20,
                width: 160,
                height: 160,
                child: CustomPaint(
                  painter: SosRadarPainter(_radarController.value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.sosRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'CHAMBA SOS • < 30 MIN',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.sosRedDark,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Tarifa 1.35x',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¿Emergencia en Casa?',
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fugas de agua, cortocircuitos o chapas atascadas. Técnicos de guardia en Chiclayo salen en moto de inmediato.',
                      style: AppTypography.bodyMd.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.sosRedDark,
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.flash_on_rounded, color: AppColors.sosRed, size: 20),
                        label: Text(
                          'Pedir Chamba SOS Ahora (< 30 min)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.sosRedDark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PostJobScreen(
                                appState: _appState,
                                isSosInitial: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
    final isSos = job.isSos;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Container(
        decoration: isSos
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.sosRed, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sosRed.withValues(alpha: 0.20),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : null,
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
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (isSos) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.sosRedLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '🚨 SOS PRIORIDAD',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.sosRed,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
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
                            Text(
                              '• ${job.district}',
                              style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          job.title,
                          style: AppTypography.bodyLgMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSos ? AppColors.sosRedDark : AppColors.neutral,
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
                          color: isSos ? AppColors.sosRed : AppColors.secondary,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        isSos ? 'Tarifa SOS' : 'Presupuesto',
                        style: AppTypography.labelSm.copyWith(
                          color: isSos ? AppColors.sosRed : AppColors.muted,
                          fontWeight: isSos ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0x14202D33)),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (hasOffers) ...[
                    ChambaBadge.counterReceived(
                      label: '${job.bids.length} Ofertas recibidas',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                      mainAxisSize: MainAxisSize.min,
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
                    isSos
                        ? const ChambaBadge.sos(label: '🚨 Alerta SOS Enviada (<30 min)')
                        : const ChambaBadge.negotiating(label: 'Buscando especialistas...'),
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
        child: Column(
          children: [
            Row(
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                          Flexible(
                            child: Text(
                              ' (${worker.completedJobs} chambas)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                            ),
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
            const SizedBox(height: 10),
            // Trust Shield Micro Row
            TrustShieldBadgesRow(
              isIdVerified: worker.isIdVerified ?? true,
              hasCleanRecord: worker.hasCleanRecord ?? true,
              offersWarranty: worker.offersWarranty ?? true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom radar waves painter for Chamba SOS
class SosRadarPainter extends CustomPainter {
  final double animationValue;

  SosRadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final progress = (animationValue + (i / 3.0)) % 1.0;
      final radius = progress * maxRadius;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SosRadarPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

