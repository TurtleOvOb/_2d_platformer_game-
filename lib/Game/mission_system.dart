import 'package:_2d_platformergame/player/player.dart';

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
  0: Mission(maxTime: 60, maxDeath: 3, minCollectibles: 0),
  1: Mission(maxTime: 80, maxDeath: 2, minCollectibles: 8),
  2: Mission(maxTime: 100, maxDeath: 5, minCollectibles: 10),
  // 可继续添加更多关卡任务
};
