import 'package:flutter/material.dart';

Widget buildCategoryButton(String category, double width, double height) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: height * 0.03),
    padding: EdgeInsets.symmetric(
      vertical: height * 0.01,
      horizontal: width * 0.02,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFFFCC80),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        category,
        style: TextStyle(color: Colors.black, fontSize: width * 0.05),
      ),
    ),
  );
}
