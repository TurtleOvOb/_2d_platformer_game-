import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenInfo {
  double? _width;
  double? _height;

  Future<void> initialize() async {
    // 获取屏幕尺寸
    final size = await _getScreenSize();
    _width = size.width;
    _height = size.height;
  }

  Future<Size> _getScreenSize() async {
    // 使用Flutter的方法获取屏幕尺寸
    final data = await SystemChannels.platform.invokeMethod('SystemChrome.getScreenSize');
    return Size(data['width'] as double, data['height'] as double);
  }

  double? get width => _width;
  double? get height => _height;

  Vector2? get screenSize {
    if (_width == null || _height == null) return null;
    return Vector2(_width!, _height!);
  }
}
