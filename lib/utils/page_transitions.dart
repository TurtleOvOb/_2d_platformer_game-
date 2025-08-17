import 'package:flutter/material.dart';

/// 自定义页面转场动画类型
enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

/// 自定义页面转场动画
class CustomPageTransition extends PageRouteBuilder {
  final Widget page;
  final PageTransitionType type;
  final Curve curve;
  final Alignment? alignment;
  final Duration duration;

  CustomPageTransition({
    required this.page,
    this.type = PageTransitionType.rightToLeft,
    this.curve = Curves.easeInOut,
    this.alignment,
    this.duration = const Duration(milliseconds: 250),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           animation = CurvedAnimation(parent: animation, curve: curve);

           switch (type) {
             case PageTransitionType.fade:
               return FadeTransition(opacity: animation, child: child);
             case PageTransitionType.rightToLeft:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(1, 0),
                   end: Offset.zero,
                 ).animate(animation),
                 child: child,
               );
             case PageTransitionType.leftToRight:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(-1, 0),
                   end: Offset.zero,
                 ).animate(animation),
                 child: child,
               );
             case PageTransitionType.topToBottom:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(0, -1),
                   end: Offset.zero,
                 ).animate(animation),
                 child: child,
               );
             case PageTransitionType.bottomToTop:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(0, 1),
                   end: Offset.zero,
                 ).animate(animation),
                 child: child,
               );
             case PageTransitionType.scale:
               return ScaleTransition(
                 scale: animation,
                 alignment: alignment ?? Alignment.center,
                 child: child,
               );
             case PageTransitionType.rotate:
               return RotationTransition(
                 turns: animation,
                 alignment: alignment ?? Alignment.center,
                 child: ScaleTransition(
                   scale: animation,
                   child: FadeTransition(opacity: animation, child: child),
                 ),
               );
             case PageTransitionType.size:
               return Align(
                 alignment: alignment ?? Alignment.center,
                 child: SizeTransition(
                   sizeFactor: animation,
                   axisAlignment: 0.0,
                   child: child,
                 ),
               );
             case PageTransitionType.rightToLeftWithFade:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(1.0, 0.0),
                   end: Offset.zero,
                 ).animate(animation),
                 child: FadeTransition(
                   opacity: animation,
                   child: SlideTransition(
                     position: Tween<Offset>(
                       begin: const Offset(0.5, 0.0),
                       end: Offset.zero,
                     ).animate(animation),
                     child: child,
                   ),
                 ),
               );
             case PageTransitionType.leftToRightWithFade:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(-1.0, 0.0),
                   end: Offset.zero,
                 ).animate(animation),
                 child: FadeTransition(
                   opacity: animation,
                   child: SlideTransition(
                     position: Tween<Offset>(
                       begin: const Offset(-0.5, 0.0),
                       end: Offset.zero,
                     ).animate(animation),
                     child: child,
                   ),
                 ),
               );
             // 所有类型已经处理完毕，不需要默认情况
           }
         },
       );
}

// 页面转场动画的便捷使用方法
Route createRoute(
  Widget page, {
  PageTransitionType type = PageTransitionType.rightToLeft,
}) {
  return CustomPageTransition(
    page: page,
    type: type,
    duration: const Duration(milliseconds: 250),
  );
}
