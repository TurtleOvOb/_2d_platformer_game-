import 'package:flame_audio/flame_audio.dart';

class AudioManage {
  static double volume = 1.0;
  void play(String name) {
    FlameAudio.play(name, volume: volume);
  }

  void playclick() {
    FlameAudio.play('按钮点击.mp3', volume: volume);
  }

  void playgameover() {
    FlameAudio.play('玩家死亡.mp3', volume: volume);
  }

  void playjump3() {
    FlameAudio.play('跳跃3.mp3', volume: volume);
  }

  void playjump2() {
    FlameAudio.play('跳跃2.mp3', volume: volume);
  }

  void playkey1() {
    FlameAudio.play('拾取钥匙1.mp3', volume: volume);
  }

  void playlevelcomplete() {
    FlameAudio.play('游戏胜利1.mp3', volume: volume);
  }

  void playkey2() {
    FlameAudio.play('拾取钥匙2.mp3', volume: volume);
  }
}
