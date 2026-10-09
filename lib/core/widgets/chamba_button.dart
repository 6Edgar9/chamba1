import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ChambaButtonVariant {
  primary,
  secondary,
  tertiaryPill,
  ghost,
}

class ChambaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ChambaButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final double? width;
  final double height;

  const ChambaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ChambaButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.width,
    this.height = 52.0,
  });

  const ChambaButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.width,
    this.height = 52.0,
  }) : variant = ChambaButtonVariant.secondary;

  const ChambaButton.pill({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.width,
    this.height = 38.0,
  }) : variant = ChambaButtonVariant.tertiaryPill;

  @override
  Widget build(BuildContext context) {
    if (variant == ChambaButtonVariant.tertiaryPill) {
      return SizedBox(
        height: height,
        width: width,
        child: Material(
          color: AppColors.quickCounterBg,
          borderRadius: BorderRadius.circular(9999),
          child: InkWell(
            borderRadius: BorderRadius.circular(9999),
            onTap: isLoading ? null : onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: AppColors.quickCounterBorder, width: 1),
              ),
              alignment: Alignment.center,
              child: _buildContent(AppColors.secondary, AppTypography.labelLg),
            ),
          ),
        ),
      );
    }

    final isPrimary = variant == ChambaButtonVariant.primary;
    final isGhost = variant == ChambaButtonVariant.ghost;

    final bgColor = isPrimary
        ? AppColors.secondary
        : (isGhost ? Colors.transparent : AppColors.card);
    final textColor = isPrimary ? AppColors.onSecondary : AppColors.primary;
    final borderColor = isPrimary
        ? Colors.transparent
        : (isGhost ? Colors.transparent : AppColors.primary);

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: isPrimary || isGhost ? 0 : 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: _buildContent(
              textColor,
              AppTypography.bodyLgMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor, TextStyle textStyle) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18, color: textColor),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle.copyWith(color: textColor),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 6),
          Icon(trailingIcon, size: 18, color: textColor),
        ],
      ],
    );
  }
}
