import 'package:flutter/material.dart';

class AnimatedMenuButton extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedMenuButton({
    Key? key,
    required this.text,
    required this.width,
    required this.height,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
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
    final borderRadius = BorderRadius.circular(20);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: widget.height * 0.1,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white,
              width: widget.width * 0.004,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(borderRadius: borderRadius),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: widget.width * 0.05,
                    ),
                    SizedBox(width: widget.width * 0.02),
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.width * 0.04,
                        fontWeight: FontWeight.w500,
                        fontFamily: '851ShouShu',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 构建菜单按钮
Widget buildMenuButton(
  String text,
  double width,
  double height,
  IconData icon,
  VoidCallback onPressed,
) {
  return AnimatedMenuButton(
    text: text,
    width: width,
    height: height,
    icon: icon,
    onPressed: onPressed,
  );
}
