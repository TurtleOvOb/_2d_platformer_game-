import 'package:firsgame/pages/levelpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then(
    (_) {
      runApp(const MyApp());
    },
  ); //锁定屏幕方向为横向
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LevelScreen(),
    );
  }
}
