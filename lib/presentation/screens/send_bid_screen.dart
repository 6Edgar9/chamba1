import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/price_dial_stepper.dart';
import '../../data/models/job_request.dart';
import '../state/app_state.dart';
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
                          'Presupuesto ofrecido por el cliente:',
                          style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                        ),
                        Text(
                          'S/. ${clientBudget.toStringAsFixed(0)}',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status message of offer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDirectAccept
                      ? AppColors.badgeConfirmedBg
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDirectAccept ? Icons.check_circle : Icons.swap_vert,
                      size: 20,
                      color: isDirectAccept ? AppColors.tertiary : AppColors.secondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isDirectAccept
                          ? 'Aceptas directamente el presupuesto fijado por el cliente.'
                          : (isHigher
                              ? 'Contraoferta: propones S/. ${(_proposedAmount - clientBudget).toStringAsFixed(0)} más.'
                              : 'Propones un descuento de S/. ${(clientBudget - _proposedAmount).toStringAsFixed(0)}.'),
                        style: AppTypography.bodyMdMedium.copyWith(
                          fontSize: 13,
                          color: isDirectAccept ? AppColors.tertiary : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Stepper Negotiation Dial
              PriceDialStepper(
                currentPrice: _proposedAmount,
                minPrice: 15.0,
                maxPrice: 2000.0,
                step: 5.0,
                label: 'Tu Oferta Propuesta en Soles',
                onPriceChanged: (val) {
                  setState(() => _proposedAmount = val);
                },
              ),

              const SizedBox(height: 22),

              // ETA options
              Text(
                'Tiempo estimado de llegada al domicilio',
                style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
              ),
              const SizedBox(height: 10),
              Row(
                children: _etaOptions.map((eta) {
                  final isSelected = _selectedEtaMinutes == eta;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        selectedColor: AppColors.surfaceContainer,
                        backgroundColor: AppColors.card,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.neutral,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 13,
                        ),
                        label: Text('$eta min'),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _selectedEtaMinutes = eta);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Quick notes chips
              Text(
                'Mensaje para el cliente',
                style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickNotes.map((note) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        backgroundColor: AppColors.card,
                        label: Text(note),
                        labelStyle: AppTypography.labelSm.copyWith(color: AppColors.primary),
                        onPressed: () {
                          setState(() => _messageController.text = note);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Describe repuestos, garantía o detalles de tu llegada...',
                ),
              ),

              const SizedBox(height: 28),

              ChambaButton(
                label: 'Enviar Oferta de S/. ${_proposedAmount.toStringAsFixed(0)}',
                leadingIcon: Icons.send_rounded,
                isLoading: _isSubmitting,
                onPressed: _submitBid,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
