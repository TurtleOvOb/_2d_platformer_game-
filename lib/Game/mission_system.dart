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
