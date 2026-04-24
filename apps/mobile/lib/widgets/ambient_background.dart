import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, this.child});

  final Widget? child;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;

    return Container(
      color: palette.surfaceLow,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
              children: [
                Positioned(
                  top: -120 + 40 * math.sin(_controller.value * 2 * math.pi),
                  right: -80 + 40 * math.cos(_controller.value * 2 * math.pi),
                  child: _Orb(
                    color: palette.orbTop,
                    size: 320,
                  ),
                ),
                Positioned(
                  bottom: -100 + 30 * math.cos(_controller.value * 2 * math.pi),
                  left: -60 + 30 * math.sin(_controller.value * 2 * math.pi),
                  child: _Orb(
                    color: palette.orbBottom,
                    size: 280,
                  ),
                ),
                Positioned(
                  top: size.height * 0.4 + 20 * math.sin(_controller.value * 2 * math.pi + math.pi),
                  left: -100 + 20 * math.cos(_controller.value * 2 * math.pi),
                  child: _Orb(
                    color: palette.primaryDim.withValues(alpha: 0.1),
                    size: 200,
                  ),
                ),
              ],
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    ),
  );
}
}

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.4),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

