import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import 'chat_screen.dart';

class JobTrackingScreen extends StatefulWidget {
  final AppState appState;
  final JobRequest job;

  const JobTrackingScreen({
    super.key,
    required this.appState,
    required this.job,
  });

  @override
  State<JobTrackingScreen> createState() => _JobTrackingScreenState();
}

class _JobTrackingScreenState extends State<JobTrackingScreen> {
  late JobRequest _job;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
    widget.appState.addListener(_onStateUpdate);
  }

  void _onStateUpdate() {
    if (mounted) {
      final updated = widget.appState.jobs.firstWhere(
        (j) => j.id == widget.job.id,
        orElse: () => _job,
      );
      setState(() => _job = updated);
    }
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onStateUpdate);
    super.dispose();
  }

  void _advanceStatus() {
    JobStatus nextStatus;
    if (_job.status == JobStatus.searching || _job.status == JobStatus.negotiating) {
      nextStatus = JobStatus.onTheWay;
    } else if (_job.status == JobStatus.onTheWay) {
      nextStatus = JobStatus.inProgress;
    } else if (_job.status == JobStatus.inProgress) {
      nextStatus = JobStatus.completed;
    } else {
      nextStatus = JobStatus.completed;
    }

    widget.appState.updateJobStatus(_job.id, nextStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado actualizado a: ${nextStatus.displayLabel}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerName = _job.workerName ?? 'Jorge Quispe Baldera';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Mi Servicio en Curso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(appState: widget.appState, job: _job),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero status card
              ChambaCard(
                color: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChambaBadge.confirmed(
                          label: _job.status.displayLabel,
                        ),
                        Text(
                          'Código: ${_job.confirmationCode}',
                          style: AppTypography.labelSm.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _job.title,
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Dirección: ${_job.address}, ${_job.district}',
                      style: AppTypography.bodyMd.copyWith(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Colors.white24),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monto Final Acordado:',
                          style: AppTypography.bodyMd.copyWith(color: Colors.white70),
                        ),
                        Text(
                          'S/. ${_job.budget.toStringAsFixed(0)}',
                          style: AppTypography.numericBid.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Tracker Stepper
              ChambaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seguimiento en Tiempo Real',
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStep(
                      stepNumber: 1,
                      title: 'Solicitud Publicada',
                      subtitle: 'Se notificaron 8 técnicos en tu zona',
                      isDone: true,
                      isCurrent: false,
                    ),
                    _buildStep(
                      stepNumber: 2,
                      title: 'Acuerdo Cerrado',
                      subtitle: 'Precio acordado en S/. ${_job.budget.toStringAsFixed(0)}',
                      isDone: true,
                      isCurrent: false,
                    ),
                    _buildStep(
                      stepNumber: 3,
                      title: 'Especialista en Camino',
                      subtitle: 'Llegada estimada en 15 - 20 minutos',
                      isDone: _job.status == JobStatus.inProgress || _job.status == JobStatus.completed,
                      isCurrent: _job.status == JobStatus.onTheWay,
                    ),
                    _buildStep(
                      stepNumber: 4,
                      title: 'Trabajo en Progreso',
                      subtitle: 'Reparación activa en tu domicilio',
                      isDone: _job.status == JobStatus.completed,
                      isCurrent: _job.status == JobStatus.inProgress,
                    ),
                    _buildStep(
                      stepNumber: 5,
                      title: 'Completado y Pago',
                      subtitle: 'Califica al técnico y paga directamente (Yape, Plin o Efectivo)',
                      isDone: _job.status == JobStatus.completed,
                      isCurrent: _job.status == JobStatus.completed,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Assigned Worker Card
              ChambaCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            workerName[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workerName,
                                style: AppTypography.bodyLgMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.neutral,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.verified, size: 14, color: AppColors.tertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'DNI Verificado • 4.9 ⭐ (142)',
                                    style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ChambaButton.secondary(
                            label: 'Llamar',
                            height: 44,
                            leadingIcon: Icons.phone,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Llamando a +51 974 812 345...')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChambaButton(
                            label: 'Mensaje',
                            height: 44,
                            leadingIcon: Icons.chat,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(appState: widget.appState, job: _job),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Security PIN Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x1F173B4D), width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.pin, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Código de Verificación',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _job.confirmationCode,
                            style: AppTypography.headlineLg.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Compártelo cuando el técnico llegue para validar el servicio.',
                            style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // State progression testing CTA
              if (_job.status != JobStatus.completed)
                ChambaButton(
                  label: _job.status == JobStatus.onTheWay
                      ? 'Simular Llegada (Iniciar Trabajo)'
                      : 'Marcar Trabajo como Completado',
                  leadingIcon: Icons.update,
                  onPressed: _advanceStatus,
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.badgeConfirmedBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.tertiary),
                      const SizedBox(width: 8),
                      Text(
                        '¡Servicio Completado con Éxito!',
                        style: AppTypography.bodyLgMedium.copyWith(
                          color: AppColors.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
  }) {
    Color circleColor;
    Color iconColor;

    if (isDone) {
      circleColor = AppColors.tertiary;
      iconColor = Colors.white;
    } else if (isCurrent) {
      circleColor = AppColors.secondary;
      iconColor = Colors.white;
    } else {
      circleColor = AppColors.surfaceContainer;
      iconColor = AppColors.muted;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? AppColors.tertiary : const Color(0x1F202D33),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMdMedium.copyWith(
                      fontWeight: isCurrent || isDone ? FontWeight.w800 : FontWeight.w500,
                      color: isCurrent
                          ? AppColors.secondary
                          : (isDone ? AppColors.neutral : AppColors.muted),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
