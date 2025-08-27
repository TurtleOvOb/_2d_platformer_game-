import 'package:shared_preferences/shared_preferences.dart';
import 'package:_2d_platformergame/player/player.dart';

Future<void> unlockAllLevels({int maxLevel = 20}) async {
  final prefs = await SharedPreferences.getInstance();
  for (int i = 0; i < maxLevel; i++) {
    await prefs.setBool('level_${i}_unlocked', true);
  }
  print('所有关卡已解锁');
}

/// 关卡任务目标
class Mission {
  /// 通关时间上限（秒）
  final double maxTime;

  /// 死亡次数上限
  final int maxDeath;

  /// 最少收集品数量
  final int minCollectibles;

  Mission({
    required this.maxTime,
    required this.maxDeath,
    required this.minCollectibles,
  });

  /// 检查玩家是否达成任务目标
  MissionResult check(Player player) {
    return MissionResult(
      timeOk: player.levelTime <= maxTime,
      deathOk: player.deathCount <= maxDeath,
      collectOk: player.collectiblesCount >= minCollectibles,
    );
  }
}

/// 任务完成情况
class MissionResult {
  final bool timeOk;
  final bool deathOk;
  final bool collectOk;

  MissionResult({
    required this.timeOk,
    required this.deathOk,
    required this.collectOk,
  });

  /// 是否所有任务都完成
  bool get allOk => timeOk && deathOk && collectOk;
}

/// 关卡任务配置
final Map<int, Mission> missionMap = {
  0: Mission(maxTime: 30, maxDeath: 3, minCollectibles: 0),
  1: Mission(maxTime: 45, maxDeath: 2, minCollectibles: 2),
  2: Mission(maxTime: 60, maxDeath: 4, minCollectibles: 3),
  3: Mission(maxTime: 45, maxDeath: 4, minCollectibles: 3),
  4: Mission(maxTime: 60, maxDeath: 3, minCollectibles: 3),
  5: Mission(maxTime: 35, maxDeath: 4, minCollectibles: 3),
  6: Mission(maxTime: 15, maxDeath: 3, minCollectibles: 2),
  7: Mission(maxTime: 30, maxDeath: 3, minCollectibles: 3),
  8: Mission(maxTime: 30, maxDeath: 5, minCollectibles: 3),
  9: Mission(maxTime: 45, maxDeath: 5, minCollectibles: 3),
  10: Mission(maxTime: 25, maxDeath: 3, minCollectibles: 3),
  11: Mission(maxTime: 20, maxDeath: 3, minCollectibles: 2),
  12: Mission(maxTime: 25, maxDeath: 3, minCollectibles: 1),
  13: Mission(maxTime: 30, maxDeath: 6, minCollectibles: 3),
  14: Mission(maxTime: 140, maxDeath: 12, minCollectibles: 3),
  15: Mission(maxTime: 120, maxDeath: 20, minCollectibles: 5),
  // 可继续添加更多关卡任务
};
