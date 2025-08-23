import 'package:flutter/services.dart';
import 'dart:io' show exit, Platform;

void tapexit() {
  // 桌面端用exit，移动端用SystemNavigator.pop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
  }
}
