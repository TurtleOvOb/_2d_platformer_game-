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
              ScreenInfo.init(context); //初始化屏幕信息后面直接调用即可
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
