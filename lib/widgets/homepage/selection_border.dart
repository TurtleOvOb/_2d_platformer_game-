import 'package:flutter/material.dart';

class SelectionBorder extends StatelessWidget {
  final double width;
  final Offset? position;
  final Size? size;
  final Duration duration;
  final Curve curve;
  final Color borderColor;
  final double? borderRadius;

  const SelectionBorder({
    super.key,
    required this.width,
    this.position,
    this.size,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.borderColor = Colors.white,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (position == null || size == null) return const SizedBox.shrink();

    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      left: position!.dx,
      top: position!.dy,
      child: Container(
        width: size!.width,
        height: size!.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          border: Border.all(color: borderColor, width: width * 0.008),
        ),
      ),
    );
  }
}
