import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:_2d_platformergame/pages/LevelCompletePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); //屏幕全屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then(
    (_) {
      runApp(
        ProviderScope(
          // 将 ProviderScope 移到这里，包裹整个应用
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  backgroundColor: Colors.orange,
                  body: HomeScreen(), // HomeScreen 不再需要单独的 ProviderScope
                );
              },
            ),
          ),
        ),
      );
    },
  ); //锁定屏幕方向为横向
}
