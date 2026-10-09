import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../data/models/worker_profile.dart';

class WorkerProfileDetailScreen extends StatelessWidget {
  final WorkerProfile worker;

  const WorkerProfileDetailScreen({
    super.key,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Perfil del Especialista'),
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
              // Hero card
              ChambaCard(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            worker.avatarInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (worker.isVerified)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 16, color: Colors.white),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      worker.name,
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      worker.district,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (worker.isVerified)
                          const ChambaBadge.verified(label: 'DNI Verificado (RENIEC)')
                        else
                          const ChambaBadge(label: 'En Proceso de Verificación'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: Color(0x14202D33)),
                    const SizedBox(height: 18),
                    // Stats metrics row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Calificación', '${worker.rating} ⭐'),
                        _buildStat('Chambas', '${worker.completedJobs}'),
                        _buildStat('Experiencia', '${worker.experienceYears} años'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Bio
              ChambaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acerca del Especialista',
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      worker.bio,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.neutral,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oficios y Especialidades',
                      style: AppTypography.labelLg.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: worker.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x1F173B4D)),
                          ),
                          child: Text(
                            skill,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Coverage & Rates
              ChambaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarifa Referencial y Cobertura',
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on_outlined, size: 20, color: AppColors.secondary),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'S/. ${worker.baseRate.toStringAsFixed(0)} / visita o base',
                              style: AppTypography.bodyLgMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.neutral,
                              ),
                            ),
                            Text(
                              'Negociable según magnitud del trabajo',
                              style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.radar_outlined, size: 20, color: AppColors.tertiary),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Radio de cobertura: ${worker.serviceRadiusKm} km',
                              style: AppTypography.bodyLgMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.neutral,
                              ),
                            ),
                            Text(
                              'Chiclayo, La Victoria, José Leonardo Ortiz, Pimentel',
                              style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Reviews
              Text(
                'Reseñas de Clientes (${worker.reviews.length})',
                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              if (worker.reviews.isEmpty) ...[
                ChambaCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Aún no tiene reseñas públicas en su perfil.',
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                ...worker.reviews.map((rev) => _buildReviewCard(rev)),
              ],

              const SizedBox(height: 24),

              ChambaButton(
                label: 'Cerrar y Regresar',
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headlineSm.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSm.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildReviewCard(WorkerReview rev) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ChambaCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rev.clientName,
                  style: AppTypography.bodyLgMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral,
                  ),
                ),
                Text(
                  rev.date,
                  style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  Icons.star,
                  size: 14,
                  color: i < rev.rating.round() ? Colors.amber : Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rev.comment,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.neutral,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
