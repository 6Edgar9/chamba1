import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import 'send_bid_screen.dart';
import 'worker_my_jobs_screen.dart';
import 'create_worker_profile_screen.dart';
import 'role_selection_screen.dart';

class AvailableJobsScreen extends StatefulWidget {
  final AppState? appState;

  const AvailableJobsScreen({super.key, this.appState});

  @override
  State<AvailableJobsScreen> createState() => _AvailableJobsScreenState();
}

class _AvailableJobsScreenState extends State<AvailableJobsScreen> {
  late AppState _appState;
  String _selectedFilter = 'Todos';
  bool _isAvailable = true;

  final List<String> _filters = [
    'Todos',
    'Gasfitería',
    'Electricidad',
    'Cerrajería',
    'Pintura',
    '< 3 km',
  ];

  @override
  void initState() {
    super.initState();
    _appState = widget.appState ?? AppState();
    _appState.addListener(_onStateUpdate);
  }

  void _onStateUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allJobs = _appState.availableWorkerJobs;
    final filteredJobs = allJobs.where((j) {
      if (_selectedFilter == 'Todos') return true;
      if (_selectedFilter == '< 3 km') return j.distanceKm <= 3.0;
      return j.categoryName.toLowerCase().contains(_selectedFilter.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chambas Disponibles',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isAvailable ? AppColors.tertiary : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isAvailable ? 'Disponible para recibir ofertas' : 'No disponible',
                  style: AppTypography.labelSm.copyWith(
                    color: _isAvailable ? AppColors.tertiary : AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.primary),
            tooltip: 'Mi Perfil de Técnico',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateWorkerProfileScreen(appState: _appState),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.work_history_outlined, color: AppColors.primary),
            tooltip: 'Mis Trabajos',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WorkerMyJobsScreen(appState: _appState),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: AppColors.secondary),
            tooltip: 'Cambiar a Modo Cliente',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RoleSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          color: AppColors.secondary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top worker metrics banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jorge Quispe Baldera',
                            style: AppTypography.bodyLgMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Radio: 15 km • 4.9 ⭐ (142 chambas)',
                            style: AppTypography.labelSm.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isAvailable,
                        activeThumbColor: AppColors.tertiary,
                        onChanged: (val) => setState(() => _isAvailable = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Category and distance filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.card,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.neutral,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedFilter = filter);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                // Header counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredJobs.length} Solicitudes cerca de ti',
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const Icon(Icons.tune, size: 18, color: AppColors.muted),
                  ],
                ),

                const SizedBox(height: 14),

                if (filteredJobs.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x14202D33)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off, size: 48, color: AppColors.muted),
                        const SizedBox(height: 12),
                        Text(
                          'No hay solicitudes con ese filtro',
                          style: AppTypography.bodyLgMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Prueba seleccionando "Todos" para ver los pedidos en Chiclayo.',
                          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ...filteredJobs.map((job) => _buildAvailableJobCard(job)),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableJobCard(JobRequest job) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ChambaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      'A ${job.distanceKm} km',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                ChambaBadge(
                  label: job.urgency,
                  type: job.urgency.contains('Urgente')
                      ? ChambaBadgeType.counterReceived
                      : ChambaBadgeType.neutral,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              job.title,
              style: AppTypography.headlineSm.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.neutral,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              job.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.muted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${job.district} (${job.address})',
                    style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0x14202D33)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Presupuesto del Cliente',
                      style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'S/. ',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          job.budget.toStringAsFixed(0),
                          style: AppTypography.numericBid.copyWith(
                            color: AppColors.secondary,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ChambaButton(
                  width: 170,
                  height: 46,
                  label: 'Enviar Oferta',
                  leadingIcon: Icons.send,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SendBidScreen(
                          appState: _appState,
                          job: job,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
