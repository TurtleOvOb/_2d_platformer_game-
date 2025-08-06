import 'package:flutter/material.dart';

// 使用Flutter内置图标创建背景图案
Widget createPatternBackground(double width, double height) {
  final iconSize = width * 0.12; // 图标大小
  final spacing = width * 0.17; // 图标间距

  return Stack(
    children: [
      // 使用多个Icon排列成网格图案
      for (double x = 0; x < width; x += spacing)
        for (double y = 0; y < height; y += spacing)
          Positioned(
            left: x,
            top: y,
            child: Transform.rotate(
              angle: 45 * (3.1415926 / 180), // 旋转45度
              child: Container(
                width: iconSize * 0.8,
                height: iconSize * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    47,
                    46,
                    46,
                  ).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(iconSize * 0.1), // 圆角半径
                ),
              ),
            ),
          ),

      // 添加不同方向的图标
      for (double x = spacing / 2; x < width; x += spacing)
        for (double y = spacing / 2; y < height; y += spacing)
          Positioned(
            left: x,
            top: y,
            child: Icon(
              Icons.star_border,
              color: Colors.white.withOpacity(0.15),
              size: iconSize * 0.8,
            ),
          ),
    ],
  );
}
