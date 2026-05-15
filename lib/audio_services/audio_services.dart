import 'package:audioplayers/audioplayers.dart';

class AudioServices {
  static Future<void> play(String path, [double? volume = 1.0]) async {
    final player = AudioPlayer();

    await player.setPlayerMode(PlayerMode.lowLatency);
    
    if (volume != null) await player.setVolume(volume);

    await player.play(AssetSource(path));

    player.onPlayerComplete.listen((_) {
      player.dispose();
    });
  }
}