import 'package:flutter/material.dart';

/// 一个同步执行多个动画的容器组件
class SynchronizedAnimationGroup extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool staggered; // 是否使用错开效果
  final Duration staggerDelay; // 错开的延迟时间

  const SynchronizedAnimationGroup({
    Key? key,
    required this.children,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 100),
    this.curve = Curves.easeOutCubic,
    this.staggered = false,
    this.staggerDelay = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  State<SynchronizedAnimationGroup> createState() =>
      _SynchronizedAnimationGroupState();
}

class _SynchronizedAnimationGroupState extends State<SynchronizedAnimationGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // 为每个子元素创建一个动画
    _animations = List.generate(widget.children.length, (index) {
      if (widget.staggered) {
        // 如果使用错开效果，每个动画的开始时间都会稍微错开
        final startTime =
            index *
            widget.staggerDelay.inMilliseconds /
            widget.duration.inMilliseconds;
        final endTime = startTime + (1.0 - startTime); // 确保所有动画在同一时间完成

        return CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startTime.clamp(0.0, 1.0),
            endTime.clamp(0.0, 1.0),
            curve: widget.curve,
          ),
        );
      } else {
        // 同步动画，所有元素一起动画
        return CurvedAnimation(parent: _controller, curve: widget.curve);
      }
    });

    // 使用延迟启动动画
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        widget.children.length,
        (index) => FadeTransition(
          opacity: _animations[index],
          child: widget.children[index],
        ),
      ),
    );
  }
}

/// 用于包装和同步多个入场动画的容器
class AnimatedEntryGroup extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration delay;
  final bool staggered;
  final Duration staggerDelay;
  final Curve curve;

  const AnimatedEntryGroup({
    Key? key,
    required this.children,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 100),
    this.staggered = false,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SynchronizedAnimationGroup(
      children: children,
      duration: duration,
      delay: delay,
      staggered: staggered,
      staggerDelay: staggerDelay,
      curve: curve,
    );
  }
}
