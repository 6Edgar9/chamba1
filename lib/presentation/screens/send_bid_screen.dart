import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/price_dial_stepper.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
import '../widgets/chamba_interactive_map.dart';
import 'worker_my_jobs_screen.dart';

class SendBidScreen extends StatefulWidget {
  final AppState appState;
  final JobRequest job;

  const SendBidScreen({
    super.key,
    required this.appState,
    required this.job,
  });

  @override
  State<SendBidScreen> createState() => _SendBidScreenState();
}

class _SendBidScreenState extends State<SendBidScreen> {
  late double _proposedAmount;
  int _selectedEtaMinutes = 25;
  final _messageController = TextEditingController(
    text: 'Tengo las herramientas y repuestos listos. Puedo salir de inmediato.',
  );
  bool _isSubmitting = false;

  final List<int> _etaOptions = [15, 25, 40, 60];

  final List<String> _quickNotes = [
    'Herramientas y repuestos en mi moto',
    'Llego en menos de 30 minutos',
    'Garantía de servicio por escrito',
    'Precio final sin cobros sorpresa',
  ];

  @override
  void initState() {
    super.initState();
    _proposedAmount = widget.job.budget;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitBid() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    widget.appState.submitBid(
      jobId: widget.job.id,
      amount: _proposedAmount,
      etaMinutes: _selectedEtaMinutes,
      message: _messageController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Oferta de S/. ${_proposedAmount.toStringAsFixed(0)} enviada a ${widget.job.clientName}!',
        ),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WorkerMyJobsScreen(appState: widget.appState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientBudget = widget.job.budget;
    final isDirectAccept = (_proposedAmount - clientBudget).abs() < 0.1;
    final isHigher = _proposedAmount > clientBudget;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Enviar Cotización'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Client request summary card
              ChambaCard(
                color: AppColors.surfaceContainerLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.job.categoryName.toUpperCase(),
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'A ${widget.job.distanceKm} km',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.job.title,
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.job.description,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0x14202D33)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Presupuesto ofrecido por cliente:',
                          style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                        ),
                        Text(
                          'S/. ${clientBudget.toStringAsFixed(0)}',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Approximate Privacy Map Preview
              Text(
                'Zona Aproximada de Trabajo',
                style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
              ),
              const SizedBox(height: 6),
              Text(
                'Por seguridad del cliente, se muestra el radio aproximado de 500m en ${widget.job.district}:',
                style: AppTypography.labelSm.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 10),
              ChambaInteractiveMap(
                mode: MapDisplayMode.approximate,
                height: 180,
                initialCenter: LatLng(widget.job.latitude, widget.job.longitude),
                isInteractive: false,
              ),
              const SizedBox(height: 20),

              // inDrive Price dial negotiation
              PriceDialStepper(
                currentPrice: _proposedAmount,
                minPrice: 15.0,
                maxPrice: 1500.0,
                label: 'Tu Propuesta de Precio en Soles',
                onPriceChanged: (val) {
                  setState(() => _proposedAmount = val);
                },
              ),
              const SizedBox(height: 12),

              // Status indicator comparing against client offer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDirectAccept
                      ? AppColors.tertiary.withValues(alpha: 0.1)
                      : isHigher
                          ? AppColors.secondary.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDirectAccept
                          ? Icons.check_circle_outline
                          : isHigher
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                      size: 16,
                      color: isDirectAccept
                          ? AppColors.tertiary
                          : isHigher
                              ? AppColors.secondary
                              : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isDirectAccept
                          ? 'Aceptas directamente el presupuesto del cliente'
                          : isHigher
                              ? 'Contraoferta: propones S/. ${(_proposedAmount - clientBudget).toStringAsFixed(0)} más'
                              : 'Propones una tarifa S/. ${(clientBudget - _proposedAmount).toStringAsFixed(0)} más económica',
                        style: AppTypography.labelSm.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDirectAccept
                              ? AppColors.tertiary
                              : isHigher
                                  ? AppColors.secondary
                                  : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ETA Arrival chips
              Text(
                'Tiempo estimado de llegada (en moto/transporte)',
                style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
              ),
              const SizedBox(height: 10),
              Row(
                children: _etaOptions.map((eta) {
                  final isSelected = _selectedEtaMinutes == eta;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => setState(() => _selectedEtaMinutes = eta),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : const Color(0x1F202D33),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$eta',
                                style: AppTypography.labelLg.copyWith(
                                  color: isSelected ? Colors.white : AppColors.neutral,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'min',
                                style: AppTypography.labelSm.copyWith(
                                  color: isSelected ? Colors.white70 : AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              // Message input
              Text(
                'Mensaje personalizado para el cliente',
                style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Ej. Cuento con repuestos en moto, puedo ir de inmediato...',
                ),
              ),
              const SizedBox(height: 10),

              // Quick notes chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickNotes.map((note) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        backgroundColor: AppColors.card,
                        label: Text(note),
                        labelStyle: AppTypography.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed: () {
                          setState(() {
                            _messageController.text = note;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 26),

              // Submit CTA Button
              ChambaButton(
                label: _isSubmitting
                    ? 'Enviando propuesta...'
                    : 'Enviar Propuesta S/. ${_proposedAmount.toStringAsFixed(0)}',
                leadingIcon: Icons.send_rounded,
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _submitBid,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
