import 'package:_2d_platformergame/device_information/screeninfo.dart';
import 'package:_2d_platformergame/widgets/game_page/timer_count.dart';
import 'package:flutter/material.dart';

class GameUi extends StatefulWidget {
  const GameUi({super.key});

  @override
  State<GameUi> createState() => _GameUiState();
}

class _GameUiState extends State<GameUi> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: (ScreenInfo.width ?? 0) * 0.03),
        Opacity(
          opacity: 0.5,
          child: Icon(
            Icons.hourglass_empty,
            color: const Color.fromARGB(255, 111, 111, 109),
            size: (ScreenInfo.width ?? 0) * 0.04,
          ),
        ),
        SizedBox(width: (ScreenInfo.width ?? 0) * 0.01),
        Opacity(
          opacity: 0.5,
          child: TimerCount(size: (ScreenInfo.width ?? 0) * 0.035),
        ),
        Spacer(),

        Opacity(
          opacity: 0.4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 53, 53, 51),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.library_books,
              color: const Color.fromARGB(255, 53, 53, 51),
              size: (ScreenInfo.width ?? 0) * 0.035,
            ),
          ),
        ),

        SizedBox(width: (ScreenInfo.width ?? 0) * 0.02),
        Opacity(
          opacity: 0.4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 53, 53, 51),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.pause_rounded,
              color: const Color.fromARGB(255, 53, 53, 51),
              size: (ScreenInfo.width ?? 0) * 0.035,
            ),
          ),
        ),
        SizedBox(width: (ScreenInfo.width ?? 0) * 0.02),
        Opacity(
          opacity: 0.4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 53, 53, 51),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.settings,
              color: const Color.fromARGB(255, 53, 53, 51),
              size: (ScreenInfo.width ?? 0) * 0.035,
            ),
          ),
        ),
        SizedBox(width: (ScreenInfo.width ?? 0) * 0.03),
      ],
    );
  }
}
