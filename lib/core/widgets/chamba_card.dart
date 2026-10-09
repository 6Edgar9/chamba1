import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ChambaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;
  final double borderRadius;

  const ChambaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.border,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final cardBorder = border ??
        Border.all(
          color: const Color(0x14202D33), // rgba(32, 45, 51, 0.08)
          width: 1,
        );

    final decoration = BoxDecoration(
      color: color ?? AppColors.card,
      borderRadius: BorderRadius.circular(borderRadius),
      border: cardBorder,
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D173B4D), // 5% opacity
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );

    if (onTap != null) {
      return Container(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: decoration,
      padding: padding,
      child: child,
    );
  }
}
