import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/device_information/screeninfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); //屏幕全屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then(
    (_) {
      //runApp(const MyApp());
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,

          home: Builder(
            builder: (context) {
              // 屏幕信息初始化已在My_Game中完成
              return Scaffold(
                backgroundColor: Colors.orange,
                body: ProviderScope(child: GameScreen()),
              );
            },
          ),
        ),
      );
    },
  ); //锁定屏幕方向为横向
}
