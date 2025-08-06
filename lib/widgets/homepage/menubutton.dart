import 'package:flutter/material.dart';

// 构建菜单按钮
Widget buildMenuButton(
  String text,
  double width,
  double height,
  IconData icon,
  VoidCallback onPressed,
) {
  return Material(
    shadowColor: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
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

      child: Container(
        width: double.infinity,
        height: height * 0.1,
        decoration: BoxDecoration(
          color: const Color(0xFFFF9800),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4, //模糊半径
              offset: const Offset(2, 2), //阴影偏移
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: width * 0.05),
            SizedBox(width: width * 0.02),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500,
                fontFamily: '851ShouShu',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
