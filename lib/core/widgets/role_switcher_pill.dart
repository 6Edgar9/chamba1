import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../presentation/state/app_state.dart';

class RoleSwitcherPill extends StatefulWidget {
  final AppState appState;
  final bool compact;

  const RoleSwitcherPill({
    super.key,
    required this.appState,
    this.compact = false,
  });

  @override
  State<RoleSwitcherPill> createState() => _RoleSwitcherPillState();
}

class _RoleSwitcherPillState extends State<RoleSwitcherPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleSwitch() {
    _animController.forward(from: 0.0);
    final targetIsWorker = widget.appState.isClient; // will become worker

    widget.appState.toggleUserRole();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              targetIsWorker ? Icons.handyman_rounded : Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                targetIsWorker
                    ? '¡Bienvenido a Modo Chamba! Verás pedidos en tiempo real.'
                    : '¡Modo Cliente activo! Publica y contrata técnicos.',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: targetIsWorker ? AppColors.workerPrimary : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isClient = widget.appState.isClient;
    final nextRoleLabel = isClient ? 'Modo Chamba' : 'Modo Cliente';
    final currentRoleLabel = isClient ? 'Cliente' : 'Técnico';

    final pillBg = isClient
        ? AppColors.surfaceContainer
        : AppColors.workerSurfaceContainer;
    final pillBorder = isClient
        ? AppColors.primary.withValues(alpha: 0.25)
        : AppColors.workerAccent.withValues(alpha: 0.4);
    final pillFg = isClient ? AppColors.primary : AppColors.workerPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleSwitch,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 10 : 12,
            vertical: widget.compact ? 5 : 7,
          ),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: pillBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: pillFg.withValues(alpha: 0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_animController),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isClient ? AppColors.primary : AppColors.workerAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isClient ? Icons.handyman_rounded : Icons.person_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.compact ? currentRoleLabel : 'Modo: $currentRoleLabel',
                    style: AppTypography.labelSm.copyWith(
                      color: pillFg,
                      fontWeight: FontWeight.w800,
                      fontSize: 10.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (!widget.compact)
                    Text(
                      'Tocar para $nextRoleLabel',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.muted,
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.swap_horiz_rounded,
                size: 16,
                color: pillFg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
