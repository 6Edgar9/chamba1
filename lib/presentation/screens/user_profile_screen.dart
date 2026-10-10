import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_card.dart';
import '../state/app_state.dart';
import 'notifications_sheet.dart';
import 'settings_screen.dart';
import 'role_selection_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final AppState appState;

  const UserProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Mi Perfil',
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
            // User Header Card
            ChambaCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primary,
                    child: const Text(
                      'LF',
                      style: TextStyle(
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
                            Text(
                              appState.clientName,
                              style: AppTypography.headlineSm.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.neutral,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, size: 18, color: AppColors.tertiary),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appState.clientDistrict,
                          style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.clientPhone,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metrics Summary
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile('8', 'Chambas Realizadas', Icons.task_alt),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile('4.9 ★', 'Calificación Cliente', Icons.star),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mode Switcher Banner
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                appState.switchRole(UserRole.worker);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF284B5D)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F173B4D),
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
                      child: const Icon(Icons.handyman_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cambiar a Modo Chambeador',
                            style: AppTypography.labelLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Gana dinero ofreciendo tus servicios',
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
              icon: Icons.notifications_outlined,
              title: 'Notificaciones',
              subtitle: 'Avisos de ofertas y estado de servicios',
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
              icon: Icons.location_on_outlined,
              title: 'Direcciones Frecuentes',
              subtitle: appState.clientAddress,
              onTap: () {},
            ),
            _buildOptionTile(
              context,
              icon: Icons.payment_outlined,
              title: 'Métodos de Pago Preferidos',
              subtitle: 'Efectivo, Yape y Plin directo',
              onTap: () {},
            ),
            _buildOptionTile(
              context,
              icon: Icons.shield_outlined,
              title: 'Seguridad y Verificación DNI',
              subtitle: 'Identidad validada con RENIEC',
              onTap: () {},
            ),
            _buildOptionTile(
              context,
              icon: Icons.help_outline,
              title: 'Soporte y Ayuda',
              subtitle: 'Atención directa por WhatsApp en Chiclayo',
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

  Widget _buildMetricTile(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14202D33)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(height: 8),
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
