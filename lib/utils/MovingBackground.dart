import 'package:flutter/material.dart';

class MovingBackground extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;
  final double speed;
  final double scale;
  const MovingBackground({
    required this.imagePath,
    required this.width,
    required this.height,
    this.speed = 30,
    this.scale = 10,
    super.key,
  });
  @override
  State<MovingBackground> createState() => _MovingBackgroundState();
}

class _MovingBackgroundState extends State<MovingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double offsetX = 0;
  double offsetY = 0;

  @override
  void initState() {
    super.initState();
    final scaledWidth = widget.width * widget.scale;
    final scaledHeight = widget.height * widget.scale;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: ((scaledWidth + scaledHeight) ~/ widget.speed),
      ),
    )..addListener(() {
      setState(() {
        double total = scaledWidth + scaledHeight;
        double move = _controller.value * total;
        offsetX = move % scaledWidth;
        offsetY = move % scaledHeight;
      });
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaledWidth = widget.width * widget.scale;
    final scaledHeight = widget.height * widget.scale;
    final dx0 = (scaledWidth - widget.width) / 2;
    final dy0 = (scaledHeight - widget.height) / 2;
    return ClipRect(
      child: Stack(
        children:
            List.generate(
              2,
              (dx) => List.generate(
                2,
                (dy) => Positioned(
                  left: -offsetX + dx * scaledWidth - dx0,
                  top: -offsetY + dy * scaledHeight - dy0,
                  child: Image.asset(
                    widget.imagePath,
                    width: scaledWidth,
                    height: scaledHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ).expand((e) => e).toList(),
      ),
    );
  }
}
