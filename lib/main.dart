import 'package:_2d_platformergame/MyApp/MyApp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then(
    (_) {
      runApp(const MyApp());
    },
  ); //锁定屏幕方向为横向
}
