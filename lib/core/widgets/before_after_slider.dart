import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../data/models/worker_profile.dart';

class BeforeAfterSlider extends StatefulWidget {
  final BeforeAfterCase? caseData;
  final Widget? beforeChild;
  final Widget? afterChild;
  final String beforeLabel;
  final String afterLabel;
  final double height;
  final double initialPosition; // 0.0 to 1.0

  const BeforeAfterSlider({
    super.key,
    this.caseData,
    this.beforeChild,
    this.afterChild,
    this.beforeLabel = 'ANTES',
    this.afterLabel = 'DESPUÉS',
    this.height = 240.0,
    this.initialPosition = 0.5,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _dividerPosition; // 0.0 to 1.0

  @override
  void initState() {
    super.initState();
    _dividerPosition = widget.initialPosition;
  }

  void _handleDrag(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _dividerPosition = (_dividerPosition + details.delta.dx / maxWidth).clamp(0.05, 0.95);
    });
  }

  void _handleTap(TapDownDetails details, double maxWidth) {
    setState(() {
      _dividerPosition = (details.localPosition.dx / maxWidth).clamp(0.05, 0.95);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final splitX = maxWidth * _dividerPosition;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: widget.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x1F173B4D), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12173B4D),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) => _handleDrag(details, maxWidth),
                onTapDown: (details) => _handleTap(details, maxWidth),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Bottom layer: "DESPUÉS" (Solución concluida)
                    widget.afterChild ?? _buildDefaultAfterView(),

                    // Top layer: "ANTES" clipped to splitX
                    ClipRect(
                      clipper: _LeftSplitClipper(splitX),
                      child: widget.beforeChild ?? _buildDefaultBeforeView(),
                    ),

                    // Draggable Vertical Divider Line
                    Positioned(
                      left: splitX - 1.5,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 3.0,
                        color: Colors.white,
                      ),
                    ),

                    // Central Slider Thumb (Interactive knob)
                    Positioned(
                      left: splitX - 20,
                      top: (widget.height / 2) - 20,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x4D000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_left, size: 14, color: Colors.white),
                            Icon(Icons.arrow_right, size: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    // Floating Badge: "ANTES" (Top Left)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xCCB42318), // Crimson badge
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Color(0x26000000), blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              widget.beforeLabel,
                              style: AppTypography.labelSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Floating Badge: "DESPUÉS" (Top Right)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xCC059669), // Emerald badge
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Color(0x26000000), blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              widget.afterLabel,
                              style: AppTypography.labelSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Interactive instruction hint at bottom
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Desliza el botón ◀ ▶ para comparar',
                            style: AppTypography.labelSm.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.caseData != null) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.caseData!.title,
                          style: AppTypography.bodyLgMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _dividerPosition > 0.5
                              ? '⚠️ Antes: ${widget.caseData!.beforeDescription}'
                              : '✅ Después: ${widget.caseData!.afterDescription}',
                          style: AppTypography.labelSm.copyWith(
                            color: _dividerPosition > 0.5 ? AppColors.secondary : AppColors.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'S/. ${widget.caseData!.cost.toStringAsFixed(0)}',
                      style: AppTypography.numericBid.copyWith(
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDefaultBeforeView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3E1F1A), Color(0xFF6B2D24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.plumbing_rounded,
              size: 42,
              color: Color(0xFFFCA5A5),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.caseData?.beforeDescription ?? 'Fuga Severa e Inundación',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'ESTADO INICIAL: DAÑO CRÍTICO',
              style: TextStyle(
                color: Color(0xFFFECACA),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAfterView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F3E2E), Color(0xFF1B6A4C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 42,
              color: Color(0xFF86EFAC),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.caseData?.afterDescription ?? 'Reparación Certificada y Sellada',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'ESTADO FINAL: GARANTÍA 7 DÍAS',
              style: TextStyle(
                color: Color(0xFFBBF7D0),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftSplitClipper extends CustomClipper<Rect> {
  final double splitX;

  _LeftSplitClipper(this.splitX);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, splitX, size.height);
  }

  @override
  bool shouldReclip(_LeftSplitClipper oldClipper) => oldClipper.splitX != splitX;
}
