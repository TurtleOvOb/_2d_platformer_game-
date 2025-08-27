import 'package:shared_preferences/shared_preferences.dart';

/// 关卡数据结构
class LevelData {
  final int levelId;
  int starCount;
  bool isUnlocked;
  int deathCount;

  LevelData({
    required this.levelId,
    this.starCount = 0,
    this.isUnlocked = false,
    this.deathCount = 0,
  });
}

/// 关卡数据管理器（单例）
class LevelManager {
  static final LevelManager _instance = LevelManager._internal();
  factory LevelManager() => _instance;
  LevelManager._internal();

  final Map<int, LevelData> _levels = {};

  /// 清空所有关卡进度（调试用）
  Future<void> clearAllProgress(int totalLevels) async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < totalLevels; i++) {
      await prefs.remove('level_${i}_star');
      await prefs.remove('level_${i}_unlocked');
      await prefs.remove('level_${i}_death');
    }
    _levels.clear();
  }

  Future<void> loadLevels(int totalLevels) async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < totalLevels; i++) {
      int star = prefs.getInt('level_${i}_star') ?? 0;
      bool unlocked = prefs.getBool('level_${i}_unlocked') ?? (i == 0);
      int death = prefs.getInt('level_${i}_death') ?? 0;
      _levels[i] = LevelData(
        levelId: i,
        starCount: star,
        isUnlocked: unlocked,
        deathCount: death,
      );
    }
  }

  LevelData getLevel(int levelId) => _levels[levelId]!;

  void updateLevel(int levelId, int starCount, {int? deathCount}) async {
    final prefs = await SharedPreferences.getInstance();
    final level = _levels[levelId]!;
    if (starCount > level.starCount) {
      level.starCount = starCount;
      await prefs.setInt('level_${levelId}_star', starCount);
    }
    if (deathCount != null) {
      level.deathCount = deathCount;
      await prefs.setInt('level_${levelId}_death', deathCount);
    }
    // 只有达成3星才解锁下一关
    if (_levels.containsKey(levelId + 1) && starCount >= 3) {
      _levels[levelId + 1]!.isUnlocked = true;
      await prefs.setBool('level_${levelId + 1}_unlocked', true);
    }
  }

  List<LevelData> get allLevels => _levels.values.toList();
}
