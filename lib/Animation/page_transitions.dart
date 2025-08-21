import 'package:flutter/material.dart';

/// 页面过渡动画类型
enum PageTransitionType {
  fade, // 淡入淡出
  scale, // 缩放
  rotate, // 旋转
  slideRight, // 从右滑入
  slideLeft, // 从左滑入
  slideBottom, // 从底部滑入
  slideTop, // 从顶部滑入
  rightToLeftWithFade, // 从右到左带淡入效果
  leftToRightWithFade, // 从左到右带淡入效果
}

/// 创建带有自定义过渡动画的路由
Route createRoute(
  Widget page, {
  PageTransitionType type = PageTransitionType.fade,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 使用 Curves.ease 作为所有动画的默认缓动曲线

      final linear = CurveTween(curve: Curves.easeInOutSine);
      switch (type) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: animation.drive(linear), child: child);
        case PageTransitionType.scale:
          return ScaleTransition(
            scale: animation.drive(linear),
            child: child,
            alignment: Alignment.center,
          );
        case PageTransitionType.rotate:
          return RotationTransition(
            turns: animation.drive(linear),
            child: FadeTransition(
              opacity: animation.drive(linear),
              child: child,
            ),
          );
        case PageTransitionType.slideRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation.drive(linear)),
            child: child,
          );
        case PageTransitionType.slideLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation.drive(linear)),
            child: child,
          );
        case PageTransitionType.slideBottom:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation.drive(linear)),
            child: child,
          );
        case PageTransitionType.slideTop:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).animate(animation.drive(linear)),
            child: child,
          );
        case PageTransitionType.rightToLeftWithFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.2, 0.0),
              end: Offset.zero,
            ).animate(animation.drive(linear)),
            child: FadeTransition(
              opacity: animation.drive(linear),
              child: child,
            ),
          );
        case PageTransitionType.leftToRightWithFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-0.2, 0.0),
              end: Offset.zero,
            ).animate(animation.drive(linear)),
            child: FadeTransition(
              opacity: animation.drive(linear),
              child: child,
            ),
          );
      }
    },
  );
}
