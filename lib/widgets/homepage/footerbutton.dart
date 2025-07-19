// 构建底部按钮
import 'package:flutter/material.dart';

Widget buildFooterButton(
  String text,
  double width,
  IconData icon,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    splashColor: const Color.fromARGB(
      255,
      166,
      36,
      36,
    ).withOpacity(0.3), //触摸反馈颜色
    highlightColor: const Color.fromARGB(
      255,
      208,
      66,
      66,
    ).withOpacity(0.1), // 点击高亮颜色
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: width * 0.04),
        SizedBox(width: width * 0.01),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: width * 0.03,
            fontFamily: '851ShouShu',
            // decoration: TextDecoration.underline,
          ),
        ),
      ],
    ),
  );
}
