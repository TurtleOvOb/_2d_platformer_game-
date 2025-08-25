import 'package:_2d_platformergame/utils/audiomanage.dart';
import 'package:flutter/material.dart';

class AnimatedLevelCard extends StatefulWidget {
  final int levelNumber;
  final bool isUnlocked;
  final int starCount; // 新增：已获得星星数（0~3）
  final double width;
  final double height;
  final VoidCallback? onTap;

  const AnimatedLevelCard({
    super.key,
    required this.levelNumber,
    required this.isUnlocked,
    required this.starCount,
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
    final cardWidth = widget.width * 0.01;

    return GestureDetector(
      onTapDown:
          widget.isUnlocked
              ? (_) {
                AudioManage().playclick();
                _controller.forward();
              }
              : null,
      onTapUp:
          widget.isUnlocked
              ? (_) {
                _controller.reverse();
                widget.onTap?.call();
              }
              : null,
      onTapCancel: widget.isUnlocked ? () => _controller.reverse() : null,
      child: Opacity(
        opacity: widget.isUnlocked ? 1.0 : 0.5, // 未解锁半透明
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.all(widget.width * 0.03),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/containers/BackGround2.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
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
                      children: List.generate(
                        3,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: cardHeight * 0.02,
                          ),
                          child: Image.asset(
                            'assets/images/star.png',
                            width: cardHeight * 0.5,
                            height: cardHeight * 0.5,
                            color:
                                widget.isUnlocked
                                    ? (i < widget.starCount
                                        ? null
                                        : Colors.grey)
                                    : Colors.grey,
                            colorBlendMode:
                                widget.isUnlocked && i < widget.starCount
                                    ? null
                                    : BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
