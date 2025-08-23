import 'package:flutter/material.dart';

Widget buildCategoryButton(String category, double width, double height) {
  // 使用菜单栏宽度的80%作为按钮尺寸，确保明显变大
  double size = width * 0.10; // 按钮尺寸显著增大
  return Container(
    margin: EdgeInsets.zero, // 去掉边距，让按钮更大
    width: size,
    height: size,
    alignment: Alignment.center,
    child: Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Image.asset(
            'assets/images/containers/mask.png',
            fit: BoxFit.cover,
          ),
        ),
        Center(
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
        ),
      ],
    ),
  );
}
