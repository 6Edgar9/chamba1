import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import '../widgets/chamba_interactive_map.dart';
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
  int _selectedRating = 5;
  final _reviewController = TextEditingController();
  String _selectedPaymentMethod = 'Yape';

  final List<String> _feedbackTags = [
    'Puntualidad 10/10',
    'Trabajo impecable',
    'Precio justo',
    'Herramientas completas',
    'Muy respetuoso',
  ];
  final Set<String> _chosenTags = {'Puntualidad 10/10', 'Precio justo'};

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
    _reviewController.dispose();
    super.dispose();
  }

  void _showPaymentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0x33202D33),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Registrar Pago del Servicio',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Paga directamente al especialista acordado en Chiclayo:',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x1F173B4D)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Monto a pagar:',
                            style: AppTypography.bodyLgMedium.copyWith(color: AppColors.neutral),
                          ),
                          Text(
                            'S/. ${_job.budget.toStringAsFixed(0)}',
                            style: AppTypography.numericBid.copyWith(
                              color: AppColors.secondary,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selecciona método de pago:',
                      style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                    ),
                    const SizedBox(height: 10),
                    _buildPaymentOption('Yape', 'Billetera digital BCP (+51 974 812 345)', Icons.qr_code_2, setModalState),
                    _buildPaymentOption('Plin', 'Interbank, Scotiabank, BBVA', Icons.phone_android, setModalState),
                    _buildPaymentOption('Efectivo', 'Pago directo en mano al finalizar', Icons.payments_outlined, setModalState),
                    const SizedBox(height: 20),
                    ChambaButton(
                      label: 'Confirmar Pago por $_selectedPaymentMethod',
                      leadingIcon: Icons.check_circle_outline,
                      onPressed: () {
                        widget.appState.registerPayment(
                          jobId: _job.id,
                          paymentMethod: _selectedPaymentMethod,
                        );
                        Navigator.of(context).pop();
                        _showRatingModal();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon, StateSetter setModalState) {
    final isSelected = _selectedPaymentMethod == title;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setModalState(() => _selectedPaymentMethod = title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainer : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0x1F202D33),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.secondary : AppColors.muted, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLgMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showRatingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0x33202D33),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '¿Cómo estuvo el servicio?',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tu calificación ayuda a técnicos honestos en Chiclayo a recibir más trabajo.',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        final isFilled = star <= _selectedRating;
                        return IconButton(
                          iconSize: 36,
                          icon: Icon(
                            isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setModalState(() => _selectedRating = star);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Quick Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _feedbackTags.map((tag) {
                        final isChosen = _chosenTags.contains(tag);
                        return FilterChip(
                          selected: isChosen,
                          label: Text(tag),
                          labelStyle: AppTypography.labelSm.copyWith(
                            color: isChosen ? Colors.white : AppColors.neutral,
                            fontWeight: isChosen ? FontWeight.w700 : FontWeight.w500,
                          ),
                          backgroundColor: AppColors.canvas,
                          selectedColor: AppColors.primary,
                          showCheckmark: false,
                          onSelected: (val) {
                            setModalState(() {
                              if (val) {
                                _chosenTags.add(tag);
                              } else {
                                _chosenTags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _reviewController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Comentario opcional sobre el trabajo...',
                        hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ChambaButton(
                      label: 'Enviar Calificación',
                      onPressed: () {
                        widget.appState.rateJob(
                          jobId: _job.id,
                          rating: _selectedRating,
                          reviewComment: _reviewController.text.trim(),
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Gracias por calificar! Tu opinión fue registrada.'),
                            backgroundColor: AppColors.tertiary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          '¿Cancelar solicitud?',
          style: AppTypography.headlineSm.copyWith(color: AppColors.primary),
        ),
        content: Text(
          'Al cancelar la solicitud, se cerrará la negociación con los técnicos postulados.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Volver'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              widget.appState.cancelJob(_job.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Sí, Cancelar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerName = _job.workerName ?? 'Jorge Quispe Baldera';
    final clientCoords = LatLng(_job.latitude, _job.longitude);
    // Worker moving marker slightly offset for live navigation realism
    final workerCoords = LatLng(_job.latitude + 0.006, _job.longitude + 0.008);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Mi Servicio y Seguimiento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Abrir chat',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(appState: widget.appState, job: _job),
                ),
              );
            },
          ),
          if (_job.status != JobStatus.completed && _job.status != JobStatus.cancelled)
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'cancel') _showCancelDialog();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancelar Solicitud', style: TextStyle(color: Colors.red)),
                ),
              ],
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
                          'PIN: ${_job.confirmationCode}',
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
                    if (_job.reference.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          'Ref: ${_job.reference}',
                          style: AppTypography.labelSm.copyWith(color: Colors.white60),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Colors.white24),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monto Acordado:',
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
              const SizedBox(height: 16),

              // Interactive Live Tracking Map
              Text(
                'Ruta en Vivo y Posición del Especialista',
                style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
              ),
              const SizedBox(height: 8),
              ChambaInteractiveMap(
                mode: MapDisplayMode.tracking,
                height: 220,
                initialCenter: clientCoords,
                workerPosition: workerCoords,
                clientAddress: _job.address,
              ),
              const SizedBox(height: 16),

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
                                const SnackBar(content: Text('Llamando al especialista...')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChambaButton(
                            label: 'Chat',
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
              const SizedBox(height: 16),

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
                            'Código de Verificación Seguro',
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
                            'Entrégalo al especialista cuando llegue a tu casa para confirmar el inicio.',
                            style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Status Progression Stepper
              ChambaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progreso del Servicio',
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStep(
                      stepNumber: 1,
                      title: 'Acuerdo Cerrado',
                      subtitle: 'Precio acordado en S/. ${_job.budget.toStringAsFixed(0)}',
                      isDone: true,
                      isCurrent: false,
                    ),
                    _buildStep(
                      stepNumber: 2,
                      title: 'Especialista en Camino',
                      subtitle: 'Desplazándose en moto a ${_job.district}',
                      isDone: _job.status == JobStatus.inProgress || _job.status == JobStatus.completed,
                      isCurrent: _job.status == JobStatus.onTheWay,
                    ),
                    _buildStep(
                      stepNumber: 3,
                      title: 'En el Domicilio / Reparación',
                      subtitle: 'Trabajo técnico en ejecución',
                      isDone: _job.status == JobStatus.completed,
                      isCurrent: _job.status == JobStatus.inProgress,
                    ),
                    _buildStep(
                      stepNumber: 4,
                      title: 'Finalizado y Pago',
                      subtitle: _job.isPaid
                          ? 'Pagado con ${_job.paymentMethod}'
                          : 'Validación final y pago en Soles',
                      isDone: _job.status == JobStatus.completed && _job.isPaid,
                      isCurrent: _job.status == JobStatus.completed && !_job.isPaid,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons according to state
              if (_job.status == JobStatus.onTheWay) ...[
                ChambaButton(
                  label: 'Confirmar Llegada del Técnico',
                  leadingIcon: Icons.home,
                  onPressed: () {
                    widget.appState.confirmArrival(_job.id);
                  },
                ),
              ] else if (_job.status == JobStatus.inProgress) ...[
                ChambaButton(
                  label: 'Marcar Trabajo Terminado',
                  leadingIcon: Icons.check_circle_outline,
                  onPressed: () {
                    widget.appState.completeJob(_job.id);
                    _showPaymentModal();
                  },
                ),
              ] else if (_job.status == JobStatus.completed) ...[
                if (!_job.isPaid)
                  ChambaButton(
                    label: 'Registrar Pago (S/. ${_job.budget.toStringAsFixed(0)})',
                    leadingIcon: Icons.payment,
                    onPressed: _showPaymentModal,
                  )
                else if (_job.rating == null)
                  ChambaButton.secondary(
                    label: 'Calificar al Especialista ⭐',
                    onPressed: _showRatingModal,
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.tertiary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified, color: AppColors.tertiary),
                        const SizedBox(width: 8),
                        Text(
                          'Servicio Finalizado y Calificado (${_job.rating} ⭐)',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 20),
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
    Color textColor;
    IconData iconData;

    if (isDone) {
      circleColor = AppColors.tertiary;
      textColor = AppColors.neutral;
      iconData = Icons.check;
    } else if (isCurrent) {
      circleColor = AppColors.secondary;
      textColor = AppColors.primary;
      iconData = Icons.radio_button_checked;
    } else {
      circleColor = const Color(0x33202D33);
      textColor = AppColors.muted;
      iconData = Icons.circle_outlined;
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
                  color: isDone || isCurrent ? circleColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: circleColor, width: 2),
                ),
                child: Icon(
                  iconData,
                  size: 14,
                  color: isDone || isCurrent ? Colors.white : AppColors.muted,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? AppColors.tertiary : const Color(0x1F202D33),
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
                    style: AppTypography.bodyLgMedium.copyWith(
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                      color: textColor,
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
