import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import 'role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Brand logo & Peruvian identity badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'CHAMBA',
                    style: AppTypography.headlineXl.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PERÚ 🇵🇪',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Hero card / illustration banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0x14202D33),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F173B4D),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surfaceContainerHighest, width: 2),
                      ),
                      child: const Icon(
                        Icons.home_repair_service_rounded,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Servicios del hogar con negociación justa y directa',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMd.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tú propones el presupuesto en Soles o recibes contraofertas en tiempo real con técnicos verificados de tu distrito.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.muted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Color(0x14202D33)),
                    const SizedBox(height: 18),
                    // Trust pills
                    _buildTrustRow(
                      Icons.verified_user_outlined,
                      '100% Técnicos verificados con DNI y antecedentes',
                    ),
                    const SizedBox(height: 12),
                    _buildTrustRow(
                      Icons.price_check_outlined,
                      'Precios transparentes en S/. sin comisiones abusivas',
                    ),
                    const SizedBox(height: 12),
                    _buildTrustRow(
                      Icons.flash_on_outlined,
                      'Respuestas y contraofertas en menos de 5 minutos',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Action buttons
              ChambaButton(
                label: 'Empezar Ahora',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RoleSelectionScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Text(
                'Al continuar aceptas las condiciones de servicio de CHAMBA Perú.',
                textAlign: TextAlign.center,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.tertiary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMdMedium.copyWith(
              fontSize: 13,
              color: AppColors.neutral,
            ),
          ),
        ),
      ],
    );
  }
}
