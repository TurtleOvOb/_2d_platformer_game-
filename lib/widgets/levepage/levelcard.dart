import 'package:flutter/material.dart';

Widget buildLevelCard(
  int levelNumber,
  bool isUnlocked,
  double width,
  double height,
  VoidCallback? onTap,
) {
  // 卡片高度的参考值（用于约束内部元素）
  final cardHeight = height * 0.11;

  return GestureDetector(
    onTap: isUnlocked ? onTap : null, // 未解锁的关卡不可点击
    child: Container(
      width: width * 0.01,
      height: cardHeight, // 固定卡片高度
      margin: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8F00),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$levelNumber',
            style: TextStyle(
              color: Colors.black,
              // 文字大小改为卡片高度的40%（避免过高）
              fontSize: cardHeight * 0.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          // 增加小间距，避免文字和星星挤在一起
          SizedBox(height: cardHeight * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: isUnlocked ? Colors.yellow : Colors.grey,
                // 星星大小改为卡片高度的20%（控制总高度）
                size: cardHeight * 0.5,
              ),
              Icon(
                Icons.star,
                color: isUnlocked ? Colors.yellow : Colors.grey,
                size: cardHeight * 0.5,
              ),
              Icon(
                Icons.star,
                color: isUnlocked ? Colors.yellow : Colors.grey,
                size: cardHeight * 0.5,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
