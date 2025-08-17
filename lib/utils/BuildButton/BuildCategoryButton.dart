import 'package:flutter/material.dart';

Widget buildCategoryButton(String category, double width, double height) {
  // 使用菜单栏宽度的80%作为按钮尺寸，确保明显变大
  double size = width * 0.10; // 按钮尺寸显著增大
  return Container(
    margin: EdgeInsets.zero, // 去掉边距，让按钮更大
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFFFCC80),
      border: Border.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.zero,
    ),
    alignment: Alignment.center,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        category,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: size * 0.5,
          fontFamily: 'PixelMplus12-Regular',
          letterSpacing: 1.2,
        ),
      ),
    ),
  );
}
