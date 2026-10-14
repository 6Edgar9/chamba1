import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_card.dart';
import '../../core/widgets/chamba_button.dart';
import '../state/app_state.dart';

class WorkerEarningsDashboard extends StatefulWidget {
  final AppState appState;
  final bool compact;

  const WorkerEarningsDashboard({
    super.key,
    required this.appState,
    this.compact = false,
  });

  @override
  State<WorkerEarningsDashboard> createState() => _WorkerEarningsDashboardState();
}

class _WorkerEarningsDashboardState extends State<WorkerEarningsDashboard> {
  int? _hoveredDayIndex;

  final List<Map<String, dynamic>> _weeklyData = const [
    {'day': 'Lun', 'amount': 80.0},
    {'day': 'Mar', 'amount': 110.0},
    {'day': 'Mié', 'amount': 65.0},
    {'day': 'Jue', 'amount': 95.0},
    {'day': 'Vie', 'amount': 140.0},
    {'day': 'Sáb', 'amount': 190.0, 'isBest': true},
    {'day': 'Dom', 'amount': 20.0},
  ];

  void _showWithdrawModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.workerAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.workerAccent, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Retiro Inmediato de Fondos',
                            style: AppTypography.headlineSm.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Tus ganancias liberadas van directo a tu billetera',
                            style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Disponible para retirar:', style: AppTypography.labelSm.copyWith(color: AppColors.muted)),
                          const SizedBox(height: 2),
                          Text(
                            'S/. 480.00',
                            style: AppTypography.numericBidLarge.copyWith(
                              color: AppColors.primary,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.workerAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Sin comisión',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.workerAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Destino de transferencia en Chiclayo:', style: AppTypography.labelLg.copyWith(color: AppColors.neutral)),
                const SizedBox(height: 8),
                _buildWithdrawOption('Yape BCP', '+51 974 812 345 • Jorge Quispe B.', Icons.qr_code_2, true),
                _buildWithdrawOption('Plin Interbank', '+51 974 812 345', Icons.phone_android, false),
                const SizedBox(height: 20),
                ChambaButton(
                  label: 'Confirmar Retiro de S/. 480.00 a Yape',
                  leadingIcon: Icons.bolt_rounded,
                  backgroundColor: AppColors.workerAccent,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('💸 ¡Transferencia enviada con éxito! S/. 480.00 transferidos a tu Yape.'),
                        backgroundColor: Color(0xFF047857),
                        behavior: SnackBarBehavior.floating,
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
  }

  Widget _buildWithdrawOption(String title, String subtitle, IconData icon, bool isDefault) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? AppColors.workerAccent : const Color(0x1F202D33),
          width: isDefault ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDefault ? AppColors.workerAccent : AppColors.muted, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyLgMedium.copyWith(fontWeight: FontWeight.w700)),
                Text(subtitle, style: AppTypography.labelSm.copyWith(color: AppColors.muted)),
              ],
            ),
          ),
          if (isDefault)
            const Icon(Icons.check_circle, color: AppColors.workerAccent, size: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double maxBarHeight = 85.0;
    const double maxAmount = 190.0;

    return ChambaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.workerAccent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.workerAccent, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mi Billetera y Rendimiento Semanal',
                  style: AppTypography.headlineSm.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Semana Actual',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Balances Row: Disponible vs Escrow en Custodia
          Row(
            children: [
              // Card 1: Disponible
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Disponible',
                            style: AppTypography.labelSm.copyWith(
                              color: const Color(0xFF166534),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.arrow_downward_rounded, size: 14, color: Color(0xFF16A34A)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/. 480.00',
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF14532D),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          onPressed: _showWithdrawModal,
                          child: const Text('Retirar', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Card 2: En Custodia (Escrow)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'En Custodia (Escrow)',
                            style: AppTypography.labelSm.copyWith(
                              color: const Color(0xFF1E40AF),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.lock_clock_rounded, size: 14, color: Color(0xFF2563EB)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/. 220.00',
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A8A),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '2 obras en proceso',
                          style: AppTypography.labelSm.copyWith(
                            color: const Color(0xFF1E40AF),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!widget.compact) ...[
            const SizedBox(height: 18),

            // PURE FLUTTER WEEKLY EARNINGS BAR CHART
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ingresos de la Semana: S/. 700.00',
                  style: AppTypography.bodyLgMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.neutral,
                  ),
                ),
                if (_hoveredDayIndex != null)
                  Text(
                    '${_weeklyData[_hoveredDayIndex!]["day"]}: S/. ${_weeklyData[_hoveredDayIndex!]["amount"].toStringAsFixed(0)}',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.workerAccent,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                else
                  Text(
                    'Sábado top día ⭐',
                    style: AppTypography.labelSm.copyWith(color: AppColors.muted, fontSize: 11),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_weeklyData.length, (index) {
                  final item = _weeklyData[index];
                  final double amount = item['amount'];
                  final String day = item['day'];
                  final bool isBest = item['isBest'] ?? false;
                  final barHeight = (amount / maxAmount) * maxBarHeight;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _hoveredDayIndex = index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'S/.${amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isBest ? FontWeight.w800 : FontWeight.w600,
                            color: isBest ? AppColors.secondary : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 24,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isBest
                                  ? [AppColors.secondary, const Color(0xFFEA580C)]
                                  : [AppColors.workerAccent, const Color(0xFF0F766E)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            boxShadow: isBest
                                ? [
                                    BoxShadow(
                                      color: AppColors.secondary.withValues(alpha: 0.35),
                                      blurRadius: 6,
                                      offset: const Offset(0, -2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isBest ? FontWeight.w800 : FontWeight.w600,
                            color: isBest ? AppColors.secondary : AppColors.neutral,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
          const SizedBox(height: 18),

          // GAMIFICATION: NIVEL CHAMBA (NIVEL PLATA ➔ MAESTRO CHAMBA ORO)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x20000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Nivel Plata',
                          style: AppTypography.bodyLgMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Próximo: Maestro Chamba Oro',
                      style: AppTypography.labelSm.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress Bar (142/150 = 94%)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 142 / 150,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '142 / 150 chambas (Faltan 8)',
                      style: AppTypography.labelSm.copyWith(color: Colors.white70, fontSize: 11),
                    ),
                    Text(
                      '95% completado',
                      style: AppTypography.labelSm.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Colors.white12),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.card_giftcard_rounded, color: Color(0xFF34D399), size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '0% comisión en tus próximas 3 chambas SOS desbloqueado.',
                        style: AppTypography.labelSm.copyWith(
                          color: const Color(0xFF34D399),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
