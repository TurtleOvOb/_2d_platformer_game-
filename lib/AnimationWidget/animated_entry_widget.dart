import 'package:flutter/material.dart';

enum EntryAnimationType {
  slideFromLeft,
  slideFromRight,
  slideFromTop,
  slideFromBottom,
  fadeIn,
  scaleIn,
  rotateIn,
  bounceIn,
}

class AnimatedEntryWidget extends StatefulWidget {
  final Widget child;
  final EntryAnimationType animationType;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const AnimatedEntryWidget({
    Key? key,
    required this.child,
    this.animationType = EntryAnimationType.slideFromLeft,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  State<AnimatedEntryWidget> createState() => _AnimatedEntryWidgetState();
}

class _AnimatedEntryWidgetState extends State<AnimatedEntryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    // 根据不同的动画类型配置不同的动画
    switch (widget.animationType) {
      case EntryAnimationType.slideFromLeft:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(_animation);
        break;
      case EntryAnimationType.slideFromRight:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(_animation);
        break;
      case EntryAnimationType.slideFromTop:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(_animation);
        break;
      case EntryAnimationType.slideFromBottom:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(_animation);
        break;
      case EntryAnimationType.fadeIn:
        // fadeIn动画不需要配置slideAnimation，但我们还是给它一个默认值
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animation);
        break;
      case EntryAnimationType.scaleIn:
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animation);
        break;
      case EntryAnimationType.rotateIn:
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animation);
        _rotateAnimation = Tween<double>(
          begin: -0.5,
          end: 0.0,
        ).animate(_animation);
        break;
      case EntryAnimationType.bounceIn:
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(_animation);
        break;
    }

    // 使用延迟启动动画
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case EntryAnimationType.slideFromLeft:
      case EntryAnimationType.slideFromRight:
      case EntryAnimationType.slideFromTop:
      case EntryAnimationType.slideFromBottom:
        return SlideTransition(position: _slideAnimation, child: widget.child);

      case EntryAnimationType.fadeIn:
        return FadeTransition(opacity: _animation, child: widget.child);

      case EntryAnimationType.scaleIn:
        return ScaleTransition(scale: _animation, child: widget.child);

      case EntryAnimationType.rotateIn:
        return RotationTransition(
          turns: _rotateAnimation,
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(scale: _animation, child: widget.child),
          ),
        );

      case EntryAnimationType.bounceIn:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // 使用弹跳效果的曲线
            double value = Curves.elasticOut.transform(_animation.value);
            return Transform.scale(
              scale: value,
              child: FadeTransition(opacity: _animation, child: widget.child),
            );
          },
        );
    }
  }
}
