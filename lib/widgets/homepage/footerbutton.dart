// 构建底部按钮
import 'package:flutter/material.dart';

Widget buildFooterButton(
  String text,
  double width,
  IconData icon,
  VoidCallback onTap,
) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFFF9800),
      border: Border.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.zero, // 像素风格无圆角
    ),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: InkWell(
      onTap: onTap,
      splashColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: width * 0.04),
          SizedBox(width: width * 0.01),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.03,
              fontFamily: 'PixelMplus12-Regular',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    ),
  );
}
