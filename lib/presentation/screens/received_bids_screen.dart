import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../core/widgets/price_dial_stepper.dart';
import '../../data/models/job_request.dart';
import '../../data/models/bid.dart';
import '../state/app_state.dart';
import 'worker_profile_detail_screen.dart';
import 'chat_screen.dart';
import 'job_tracking_screen.dart';

class ReceivedBidsScreen extends StatefulWidget {
  final AppState appState;
  final JobRequest job;

  const ReceivedBidsScreen({
    super.key,
    required this.appState,
    required this.job,
  });

  @override
  State<ReceivedBidsScreen> createState() => _ReceivedBidsScreenState();
}

class _ReceivedBidsScreenState extends State<ReceivedBidsScreen> {
  late JobRequest _currentJob;

  @override
  void initState() {
    super.initState();
    _currentJob = widget.job;
    widget.appState.addListener(_onStateUpdate);
  }

  void _onStateUpdate() {
    if (mounted) {
      final updated = widget.appState.jobs.firstWhere(
        (j) => j.id == widget.job.id,
        orElse: () => _currentJob,
      );
      setState(() => _currentJob = updated);
    }
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onStateUpdate);
    super.dispose();
  }

  void _showCounterOfferModal(Bid bid) {
    double counterValue = widget.job.budget;

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
                color: AppColors.canvas,
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
                          color: AppColors.muted.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Contraofertar a ${bid.workerName}',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'El técnico ofertó S/. ${bid.amount.toStringAsFixed(0)}. Ingresa tu propuesta final:',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 20),
                    PriceDialStepper(
                      currentPrice: counterValue,
                      minPrice: 15.0,
                      maxPrice: 1500.0,
                      label: 'Tu Contraoferta en Soles',
                      onPriceChanged: (val) {
                        setModalState(() => counterValue = val);
                      },
                    ),
                    const SizedBox(height: 20),
                    ChambaButton(
                      label: 'Enviar Contraoferta S/. ${counterValue.toStringAsFixed(0)}',
                      onPressed: () {
                        widget.appState.counterBid(
                          jobId: _currentJob.id,
                          bidId: bid.id,
                          counterAmount: counterValue,
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Contraoferta de S/. ${counterValue.toStringAsFixed(0)} enviada a ${bid.workerName}',
                            ),
                            backgroundColor: AppColors.secondary,
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

  @override
  Widget build(BuildContext context) {
    final bids = _currentJob.bids;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Ofertas Recibidas'),
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
                  builder: (_) => ChatScreen(
                    appState: widget.appState,
                    job: _currentJob,
                  ),
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
              // Summary card of job
              ChambaCard(
                color: AppColors.surfaceContainerLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currentJob.categoryName,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        ChambaBadge.negotiating(
                          label: '${bids.length} propuestas',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentJob.title,
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted),
                            const SizedBox(width: 4),
                            Text(
                              _currentJob.district,
                              style: AppTypography.labelMd.copyWith(color: AppColors.muted),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Tu presupuesto: ',
                              style: AppTypography.labelMd.copyWith(color: AppColors.muted),
                            ),
                            Text(
                              'S/. ${_currentJob.budget.toStringAsFixed(0)}',
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Subheading
              Row(
                children: [
                  const Icon(Icons.offline_bolt, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cotizaciones en Tiempo Real',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Elige al técnico que prefieras o contraoferta para acordar un precio justo.',
                style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 16),

              if (bids.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x14202D33)),
                  ),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: AppColors.secondary),
                      const SizedBox(height: 18),
                      Text(
                        'Esperando ofertas de técnicos...',
                        style: AppTypography.bodyLgMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Los especialistas en tu zona han sido notificados. Recibirás propuestas en breve.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ...bids.map((bid) => _buildBidCard(bid)),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBidCard(Bid bid) {
    final worker = widget.appState.workers.firstWhere(
      (w) => w.id == bid.workerId,
      orElse: () => widget.appState.workers.first,
    );
    final hasCounter = bid.counterAmount != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ChambaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker header row
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WorkerProfileDetailScreen(worker: worker),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      bid.workerAvatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                              bid.workerName,
                              style: AppTypography.bodyLgMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.neutral,
                              ),
                            ),
                          ),
                          if (bid.isWorkerVerified)
                            const ChambaBadge.verified(label: 'DNI Verificado'),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${bid.workerRating}',
                            style: AppTypography.labelSm.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral,
                            ),
                          ),
                          Text(
                            ' (${bid.workerCompletedJobs} trabajos)',
                            style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.muted),
                          const SizedBox(width: 4),
                          Text(
                            'Llega en ${bid.etaMinutes} min',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (bid.message.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0x0F202D33)),
                ),
                child: Text(
                  '"${bid.message}"',
                  style: AppTypography.bodyMd.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.neutral,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0x14202D33)),
            const SizedBox(height: 14),

            // Price negotiation comparison
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasCounter ? 'Tu contraoferta' : 'Oferta del técnico',
                      style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 2),
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
                          hasCounter
                              ? bid.counterAmount!.toStringAsFixed(0)
                              : bid.amount.toStringAsFixed(0),
                          style: AppTypography.numericBid.copyWith(
                            color: AppColors.secondary,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.person_outline, size: 16),
                  label: const Text('Ver Perfil'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WorkerProfileDetailScreen(worker: worker),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Dual action buttons: Aceptar / Contraofertar
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ChambaButton(
                    label: 'Aceptar S/. ${(bid.counterAmount ?? bid.amount).toStringAsFixed(0)}',
                    leadingIcon: Icons.check,
                    onPressed: () {
                      widget.appState.acceptBid(
                        jobId: _currentJob.id,
                        bidId: bid.id,
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => JobTrackingScreen(
                            appState: widget.appState,
                            job: widget.appState.activeJob!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: ChambaButton.secondary(
                    label: 'Contraofertar',
                    leadingIcon: Icons.sync_alt,
                    onPressed: () => _showCounterOfferModal(bid),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
