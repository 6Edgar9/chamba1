import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'chamba_button.dart';

class PriceDialStepper extends StatelessWidget {
  final double currentPrice;
  final ValueChanged<double> onPriceChanged;
  final double step;
  final double minPrice;
  final double maxPrice;
  final String label;
  final List<double> quickIncrements;

  const PriceDialStepper({
    super.key,
    required this.currentPrice,
    required this.onPriceChanged,
    this.step = 5.0,
    this.minPrice = 10.0,
    this.maxPrice = 2000.0,
    this.label = 'Tu Oferta Propuesta',
    this.quickIncrements = const [-5.0, 5.0, 10.0, 20.0],
  });

  void _adjust(double delta) {
    final next = (currentPrice + delta).clamp(minPrice, maxPrice);
    onPriceChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1F202D33), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A173B4D),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelMd.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCircularStepButton(
                icon: Icons.remove,
                enabled: currentPrice > minPrice,
                onTap: () => _adjust(-step),
              ),
              const SizedBox(width: 20),
              // Prominent numeric bid display
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'S/. ',
                    style: AppTypography.headlineLg.copyWith(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    currentPrice.toStringAsFixed(0),
                    style: AppTypography.numericBidLarge.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              _buildCircularStepButton(
                icon: Icons.add,
                enabled: currentPrice < maxPrice,
                onTap: () => _adjust(step),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Quick pills: -S/.5, +S/.5, +S/.10, +S/.20
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: quickIncrements.map((increment) {
                final isNegative = increment < 0;
                final sign = isNegative ? '' : '+';
                final labelText = '${sign}S/.${increment.abs().toStringAsFixed(0)}';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChambaButton.pill(
                    label: labelText,
                    onPressed: () => _adjust(increment),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularStepButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: enabled ? AppColors.surfaceContainer : AppColors.surfaceContainerLow,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Center(
            child: Icon(
              icon,
              size: 24,
              color: enabled ? AppColors.primary : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
