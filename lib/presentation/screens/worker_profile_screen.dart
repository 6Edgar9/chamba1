import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_badge.dart';
import '../../core/widgets/before_after_slider.dart';
import '../widgets/worker_earnings_dashboard.dart';
import '../state/app_state.dart';
import 'create_worker_profile_screen.dart';
import 'notifications_sheet.dart';
import 'settings_screen.dart';
import 'role_selection_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  final AppState appState;

  const WorkerProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final profile = appState.currentWorkerProfile;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mi Perfil de Chambeador',
          style: AppTypography.headlineSm.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(appState: appState),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Worker Identity Card
            ChambaCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          profile.avatarInitials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    profile.name,
                                    style: AppTypography.headlineSm.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.neutral,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (profile.isVerified)
                                  const Icon(Icons.verified, size: 18, color: AppColors.tertiary),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.district,
                              style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${profile.rating}',
                                  style: AppTypography.labelSm.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.neutral,
                                  ),
                                ),
                                Text(
                                  ' (${profile.completedJobs} chambas)',
                                  style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TrustShieldBadgesRow(
                    isIdVerified: profile.isIdVerified,
                    hasCleanRecord: profile.hasCleanRecord,
                    offersWarranty: profile.offersWarranty,
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0x14202D33)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tarifa base orientativa',
                        style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                      ),
                      Text(
                        'S/. ${profile.baseRate.toStringAsFixed(0)} / servicio',
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

            // FEATURE 4: Worker Wallet, Weekly Bar Chart, and Gamification Level Dashboard
            WorkerEarningsDashboard(appState: appState),
            const SizedBox(height: 16),

            // Portfolio Before & After Section for Worker
            if (profile.portfolioCases.isNotEmpty) ...[
              ChambaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mi Portafolio Antes y Después',
                          style: AppTypography.headlineSm.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.workerAccent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${profile.portfolioCases.length} obras',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.workerAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tus clientes pueden deslizar la barra interactiva para validar tu calidad de acabado.',
                      style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 12),
                    ...profile.portfolioCases.take(2).map((caseItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              caseItem.title,
                              style: AppTypography.bodyLgMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            BeforeAfterSlider(caseData: caseItem),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 20),

            // Switch to Client Mode Banner
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                appState.switchRole(UserRole.client);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, Color(0xFFC75B2E)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1FB84A1C),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cambiar a Modo Cliente',
                            style: AppTypography.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Publica una necesidad para tu hogar',
                            style: AppTypography.labelSm.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.swap_horiz, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Options List
            _buildOptionTile(
              context,
              icon: Icons.edit_note_rounded,
              title: 'Editar Datos y Oficios',
              subtitle: 'Categorías, experiencia y tarifas',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateWorkerProfileScreen(appState: appState),
                  ),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notificaciones',
              subtitle: 'Avisos de chambas y contraofertas',
              badgeCount: appState.unreadNotificationsCount,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => NotificationsSheet(appState: appState),
                );
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.rate_review_outlined,
              title: 'Reseñas de Clientes',
              subtitle: '${profile.reviews.length} opiniones recibidas en Chiclayo',
              onTap: () {},
            ),
            _buildOptionTile(
              context,
              icon: Icons.badge_outlined,
              title: 'Verificación de Identidad',
              subtitle: 'DNI validado con antecedentes limpios',
              onTap: () {},
            ),
            _buildOptionTile(
              context,
              icon: Icons.logout,
              title: 'Elegir Modo de Uso',
              subtitle: 'Volver a la selección inicial de roles',
              textColor: AppColors.secondary,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    int? badgeCount,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ChambaCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: textColor ?? AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLgMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor ?? AppColors.neutral,
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
            if (badgeCount != null && badgeCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}
