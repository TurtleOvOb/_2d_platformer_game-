import 'package:flutter/material.dart';
import 'package:_2d_platformergame/utils/audiomanage.dart';

enum ButtonAnimationType {
  scale, // 缩放动画
  bounce, // 弹跳动画
  pulse, // 脉冲动画
  shake, // 抖动动画
  glow, // 发光动画
  none, // 无动画
}

class ImageTextButton extends StatefulWidget {
  final String text; // 按钮文本
  final String imagePath; // 背景图片路径
  final VoidCallback onTap; // 点击回调
  final TextStyle? textStyle; // 文本样式
  final double? width; // 按钮宽度
  final double? height; // 按钮高度
  final ButtonAnimationType animationType; // 动画类型
  final Widget? icon; // 可选图标
  final EdgeInsets? padding; // 内边距
  final BoxFit imageFit; // 图像填充方式
  final Duration animationDuration; // 动画持续时间
  final String? buttonId; // 菜单按钮ID，用于选择边框
  final Function(String, Offset, Size)? onSelect; // 选择回调

  const ImageTextButton({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.onTap,
    this.textStyle,
    this.width,
    this.height,
    this.animationType = ButtonAnimationType.scale,
    this.icon,
    this.padding,
    this.imageFit = BoxFit.contain,
    this.animationDuration = const Duration(milliseconds: 200),
    this.buttonId,
    this.onSelect,
  }) : super(key: key);

  @override
  State<ImageTextButton> createState() => _ImageTextButtonState();
}

class _ImageTextButtonState extends State<ImageTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _shakeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器，添加状态监听
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // 添加状态监听器，确保动画完成后重置
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 对于有些动画，我们希望它完成后自动重置
        if (widget.animationType == ButtonAnimationType.bounce ||
            widget.animationType == ButtonAnimationType.pulse ||
            widget.animationType == ButtonAnimationType.shake) {
          _animationController.reset();
        }
      }
    });

    // 缩放动画
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 弹跳动画 - 使用更安全的曲线，避免值超出[0.0, 1.0]范围
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 脉冲动画
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 抖动动画
    _shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: Offset(0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset(0.02, 0), end: Offset(-0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset(-0.02, 0), end: Offset(0.01, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset(0.01, 0), end: Offset(-0.01, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset(-0.01, 0), end: Offset.zero),
        weight: 1,
      ),
    ]).animate(_animationController);

    // 发光动画
    _glowAnimation = Tween<double>(begin: 0.0, end: 0.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // 确保在销毁前停止所有动画
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  // 处理按钮按下时的动画
  void _handleButtonAnimation({required bool pressed}) {
    if (widget.animationType == ButtonAnimationType.none) {
      return;
    }

    if (pressed) {
      // 如果动画正在运行，先重置
      if (_animationController.isAnimating) {
        _animationController.reset();
      }
      // 按下时只播放一半的动画
      _animationController.forward(from: 0.0);
    }
    // onTapUp 和 onTapCancel 事件将在各自的处理程序中处理
  }

  @override
  Widget build(BuildContext context) {
    // 根据动画类型返回不同的动画Widget
    Widget buttonContent() {
      // 创建基础按钮内容
      Widget content = Stack(
        alignment: Alignment.center,
        children: [
          // 按钮背景图像
          Image.asset(
            widget.imagePath,
            width: widget.width,
            height: widget.height,
            fit: widget.imageFit,
          ),

          // 文本和图标布局
          Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[widget.icon!, SizedBox(width: 8)],
                Text(
                  widget.text,
                  style:
                      widget.textStyle ??
                      TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PixelMplus12-Regular',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );

      // 应用选定的动画
      switch (widget.animationType) {
        case ButtonAnimationType.scale:
          return ScaleTransition(scale: _scaleAnimation, child: content);

        case ButtonAnimationType.bounce:
          return AnimatedBuilder(
            animation: _bounceAnimation,
            builder:
                (context, child) => Transform.scale(
                  scale: _bounceAnimation.value,
                  child: child,
                ),
            child: content,
          );

        case ButtonAnimationType.pulse:
          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder:
                (context, child) =>
                    Transform.scale(scale: _pulseAnimation.value, child: child),
            child: content,
          );

        case ButtonAnimationType.shake:
          return AnimatedBuilder(
            animation: _shakeAnimation,
            builder:
                (context, child) => FractionalTranslation(
                  translation: _shakeAnimation.value,
                  child: child,
                ),
            child: content,
          );

        case ButtonAnimationType.glow:
          return AnimatedBuilder(
            animation: _glowAnimation,
            builder:
                (context, child) => Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(_glowAnimation.value),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: child,
                ),
            child: content,
          );

        case ButtonAnimationType.none:
          return content;
      }
    }

    // 主按钮构建
    return GestureDetector(
      onTapDown: (_) => _handleButtonAnimation(pressed: true),
      onTapUp: (_) {
        // 先播放音效
        AudioManage().playclick();
        // 判断是否需要等待动画完成后再执行回调
        if (widget.animationType != ButtonAnimationType.none) {
          if (_animationController.isAnimating) {
            _animationController.stop();
          }
          AnimationStatusListener? listener;
          listener = (status) {
            if (status == AnimationStatus.completed) {
              widget.onTap();
              _animationController.removeStatusListener(listener!);
            }
          };
          _animationController.addStatusListener(listener);
          _animationController.reset();
          _animationController.forward();
        } else {
          widget.onTap();
        }
      },
      onTapCancel: () {
        _animationController.reset();
      },
      child: buttonContent(),
    );
  }
}

// 构建按钮的便捷函数
Widget buildImageButton({
  required String text,
  required String imagePath,
  required VoidCallback onTap,
  TextStyle? textStyle,
  double? width,
  double? height,
  ButtonAnimationType animationType = ButtonAnimationType.scale,
  Widget? icon,
  EdgeInsets? padding,
}) {
  return ImageTextButton(
    text: text,
    imagePath: imagePath,
    onTap: onTap,
    textStyle: textStyle,
    width: width,
    height: height,
    animationType: animationType,
    icon: icon,
    padding: padding,
  );
}
