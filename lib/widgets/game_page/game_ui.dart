import 'package:_2d_platformergame/device_information/screeninfo.dart';
import 'package:_2d_platformergame/widgets/game_page/timer_count.dart';
import 'package:flutter/material.dart';

class GameUi extends StatefulWidget {
  const GameUi({super.key});

  @override
  State<GameUi> createState() => _GameUiState();
}

class _GameUiState extends State<GameUi> {
  late ScreenInfo _screenInfo;
  double _width = 0;

  @override
  void initState() {
    super.initState();
    _screenInfo = ScreenInfo();
    _initializeScreenInfo();
  }

  Future<void> _initializeScreenInfo() async {
    await _screenInfo.initialize();
    setState(() {
      _width = _screenInfo.width ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: _width * 1.2, // 增加总宽度
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: _width * 0.01), // 减小起始间距
          Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.hourglass_empty,
              color: const Color.fromARGB(255, 111, 111, 109),
              size: _width * 0.04,
            ),
          ),
          SizedBox(width: _width * 0.005), // 减小图标间距
          Opacity(opacity: 0.5, child: TimerCount(size: _width * 0.035)),
          Spacer(flex: 2), // 调整Spacer的权重

          Opacity(
            opacity: 0.4,
            child: InkWell(
              onTap: () {},
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
                  size: _width * 0.035,
                ),
              ),
            ),
          ),

          SizedBox(width: _width * 0.01), // 减小图标间距

          Opacity(
            opacity: 0.4,
            child: InkWell(
              onTap: () {
                //用inkwell实现点击
              },
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
                  size: _width * 0.035,
                ),
              ),
            ),
          ),
          SizedBox(width: _width * 0.01), // 减小图标间距

          Opacity(
            opacity: 0.4,
            child: InkWell(
              onTap: () {},
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
                  size: _width * 0.035,
                ),
              ),
            ),
          ),
          SizedBox(width: _width * 0.01), // 减小结束间距
        ],
      ),
    );
  }
}
