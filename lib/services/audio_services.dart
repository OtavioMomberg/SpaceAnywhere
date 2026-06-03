import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> init() async {
    await _player.setPlayerMode(PlayerMode.lowLatency);
    await _player.setVolume(1.0);
  }

  static Future<void> play({required String path, double? volume = 1.0}) async {
    await _player.stop();
    if (volume != null) await _player.setVolume(volume);
    await _player.play(AssetSource(path));
  }
}