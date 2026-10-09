import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ChambaBadgeType {
  negotiating,
  confirmed,
  counterReceived,
  inProgress,
  verified,
  neutral,
}

class ChambaBadge extends StatelessWidget {
  final String label;
  final ChambaBadgeType type;
  final IconData? icon;

  const ChambaBadge({
    super.key,
    required this.label,
    this.type = ChambaBadgeType.neutral,
    this.icon,
  });

  const ChambaBadge.negotiating({
    super.key,
    this.label = 'Negociando',
    this.icon,
  }) : type = ChambaBadgeType.negotiating;

  const ChambaBadge.confirmed({
    super.key,
    this.label = 'Confirmado',
    this.icon = Icons.check_circle_outline,
  }) : type = ChambaBadgeType.confirmed;

  const ChambaBadge.counterReceived({
    super.key,
    this.label = 'Contraoferta Recibida',
    this.icon = Icons.sync_alt,
  }) : type = ChambaBadgeType.counterReceived;

  const ChambaBadge.verified({
    super.key,
    this.label = 'Verificado',
    this.icon = Icons.verified,
  }) : type = ChambaBadgeType.verified;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case ChambaBadgeType.negotiating:
        bg = AppColors.badgeNegotiatingBg;
        fg = AppColors.badgeNegotiatingText;
        break;
      case ChambaBadgeType.confirmed:
        bg = AppColors.badgeConfirmedBg;
        fg = AppColors.badgeConfirmedText;
        break;
      case ChambaBadgeType.counterReceived:
        bg = AppColors.badgeCounterBg;
        fg = AppColors.badgeCounterText;
        break;
      case ChambaBadgeType.inProgress:
        bg = const Color(0x1F284B5D);
        fg = AppColors.primary;
        break;
      case ChambaBadgeType.verified:
        bg = AppColors.badgeConfirmedBg;
        fg = AppColors.tertiary;
        break;
      case ChambaBadgeType.neutral:
        bg = const Color(0x14667085);
        fg = AppColors.muted;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
