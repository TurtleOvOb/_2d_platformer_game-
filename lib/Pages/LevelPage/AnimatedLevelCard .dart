import 'package:flutter/material.dart';

class AnimatedLevelCard extends StatefulWidget {
  final int levelNumber;
  final bool isUnlocked;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const AnimatedLevelCard({
    super.key,
    required this.levelNumber,
    required this.isUnlocked,
    required this.width,
    required this.height,
    this.onTap,
  });

  @override
  State<AnimatedLevelCard> createState() => _AnimatedLevelCardState();
}

class _AnimatedLevelCardState extends State<AnimatedLevelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = widget.height * 0.11;

    return GestureDetector(
      onTapDown: widget.isUnlocked ? (_) => _controller.forward() : null,
      onTapUp:
          widget.isUnlocked
              ? (_) {
                _controller.reverse();
                widget.onTap?.call();
              }
              : null,
      onTapCancel: widget.isUnlocked ? () => _controller.reverse() : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width * 0.01,
          height: cardHeight,
          margin: EdgeInsets.all(widget.width * 0.03),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8F00),
            // borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.levelNumber}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: cardHeight * 0.8,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PixelMplus12-Regular',
                ),
              ),
              SizedBox(height: cardHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: widget.isUnlocked ? Colors.yellow : Colors.grey,
                    size: cardHeight * 0.5,
                  ),
                  Icon(
                    Icons.star,
                    color: widget.isUnlocked ? Colors.yellow : Colors.grey,
                    size: cardHeight * 0.5,
                  ),
                  Icon(
                    Icons.star,
                    color: widget.isUnlocked ? Colors.yellow : Colors.grey,
                    size: cardHeight * 0.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
