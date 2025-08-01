import 'package:flutter/material.dart';

class ScreenInfo {
  static double? _width;
  static double? _height;
  static void init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  static double? get width => _width;
  static double? get height => _height;
}
