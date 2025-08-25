import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Task extends StatelessWidget {
  final bool val;
  final String title;
  const Task(this.val, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(0, 232, 206, 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: val, onChanged: null),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'PixelMplus12-Regular',
              color: Color.fromARGB(255, 248, 248, 248),
            ),
          ),
        ],
      ),
    );
  }
}
