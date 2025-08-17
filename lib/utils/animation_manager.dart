import 'package:flutter/material.dart';

/// 一个用于管理和控制整个应用程序动画的类
class AnimationManager {
  /// 单例模式实现
  AnimationManager._internal();
  static final AnimationManager _instance = AnimationManager._internal();
  static AnimationManager get instance => _instance;

  /// 存储页面与动画控制器的映射
  final Map<String, List<AnimationController>> _pageControllers = {};

  /// 注册一个动画控制器到指定页面
  void registerController(String pageName, AnimationController controller) {
    if (!_pageControllers.containsKey(pageName)) {
      _pageControllers[pageName] = [];
    }
    _pageControllers[pageName]!.add(controller);
  }

  /// 取消注册页面的所有动画控制器
  void unregisterPage(String pageName) {
    _pageControllers.remove(pageName);
  }

  /// 播放特定页面的所有动画
  void playPageAnimations(String pageName) {
    if (_pageControllers.containsKey(pageName)) {
      for (var controller in _pageControllers[pageName]!) {
        controller.forward(from: 0.0);
      }
    }
  }

  /// 重置特定页面的所有动画
  void resetPageAnimations(String pageName) {
    if (_pageControllers.containsKey(pageName)) {
      for (var controller in _pageControllers[pageName]!) {
        controller.reset();
      }
    }
  }

  /// 停止特定页面的所有动画
  void stopPageAnimations(String pageName) {
    if (_pageControllers.containsKey(pageName)) {
      for (var controller in _pageControllers[pageName]!) {
        controller.stop();
      }
    }
  }

  /// 反向播放特定页面的所有动画
  void reversePageAnimations(String pageName) {
    if (_pageControllers.containsKey(pageName)) {
      for (var controller in _pageControllers[pageName]!) {
        if (controller.isCompleted) {
          controller.reverse();
        }
      }
    }
  }

  /// 清理所有动画控制器
  void dispose() {
    for (var controllers in _pageControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    _pageControllers.clear();
  }
}

/// 用于创建带有出场入场动画的 StatefulWidget
abstract class AnimatedPage extends StatefulWidget {
  final String pageName;

  const AnimatedPage({Key? key, required this.pageName}) : super(key: key);

  @override
  AnimatedPageState createState();
}

/// 用于创建带有出场入场动画的 State
abstract class AnimatedPageState<T extends AnimatedPage> extends State<T>
    with TickerProviderStateMixin {
  /// 用于控制此页面所有入场动画的控制器
  late AnimationController _entryAnimationController;

  /// 用于控制此页面所有出场动画的控制器
  late AnimationController _exitAnimationController;

  /// 获取入场动画
  Animation<double> get entryAnimation => _entryAnimationController;

  /// 获取出场动画
  Animation<double> get exitAnimation => _exitAnimationController;

  /// 覆盖这个方法来构建动画的内容部分
  Widget buildAnimatedContent(BuildContext context);

  @override
  void initState() {
    super.initState();

    // 初始化入场动画控制器，使用曲线动画
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
      if (mounted) setState(() {});
    });

    // 初始化出场动画控制器
    _exitAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      if (mounted) setState(() {});
    });

    // 注册动画控制器到动画管理器
    AnimationManager.instance.registerController(
      widget.pageName,
      _entryAnimationController,
    );

    AnimationManager.instance.registerController(
      widget.pageName,
      _exitAnimationController,
    );

    // 自动开始入场动画
    _entryAnimationController.forward();
  }

  /// 触发出场动画并在完成后执行回调函数
  void triggerExitAnimation(VoidCallback onComplete) {
    _exitAnimationController.forward(from: 0.0).then((_) {
      onComplete();
    });
  }

  @override
  void dispose() {
    // 确保动画控制器被正确释放
    _entryAnimationController.dispose();
    _exitAnimationController.dispose();
    super.dispose();
  }
}
