import 'package:flutter/material.dart';

// 构建菜单按钮
Widget buildMenuButton(
  String text,
  double width,
  double height,
  IconData icon,
  VoidCallback onPressed,
) {
  final borderRadius = BorderRadius.circular(20);

  return Container(
    width: double.infinity,
    height: height * 0.1,
    decoration: BoxDecoration(
      color: const Color(0xFFFF9800),
      borderRadius: borderRadius,
      border: Border.all(color: Colors.white, width: width * 0.004),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: const Color.fromARGB(255, 166, 36, 36).withOpacity(0.3),
          highlightColor: const Color.fromARGB(
            255,
            208,
            66,
            66,
          ).withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: width * 0.05),
              SizedBox(width: width * 0.02),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                  fontFamily: '851ShouShu',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
