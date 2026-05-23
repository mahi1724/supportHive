import 'package:just_audio/just_audio.dart';

/// Global singleton audio player. One instance for the entire app lifecycle.
/// Screens subscribe to streams rather than owning the player.
class AudioService {
  AudioService._();

  static final AudioPlayer _player = AudioPlayer();
  static AudioPlayer get player => _player;

  static String _currentUrl = '';
  static String get currentUrl => _currentUrl;

  // ── Playback ────────────────────────────────────────────────────────────────

  static Future<void> play(String url, {bool isAsset = false}) async {
    if (url.isEmpty) throw ArgumentError('url must not be empty');

    if (url == _currentUrl && _player.audioSource != null) {
      await _player.play();
      return;
    }
    _currentUrl = url;

    if (isAsset) {
      await _player.setAsset(url);
    } else {
      await _player.setUrl(url);
    }
    await _player.play();
  }

  static Future<void> pause() => _player.pause();

  static Future<void> stop() async {
    _currentUrl = '';
    await _player.stop();
  }

  static Future<void> seekTo(Duration position) {
    final dur = _player.duration;
    if (dur != null) {
      final clamped = position.isNegative
          ? Duration.zero
          : (position > dur ? dur : position);
      return _player.seek(clamped);
    }
    return _player.seek(position);
  }

  static Future<void> skipForward({int seconds = 10}) async {
    final pos = _player.position;
    await seekTo(pos + Duration(seconds: seconds));
  }

  static Future<void> skipBackward({int seconds = 10}) async {
    final pos = _player.position;
    await seekTo(pos - Duration(seconds: seconds));
  }

  static Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  // ── State ───────────────────────────────────────────────────────────────────

  static bool get isPlaying => _player.playing;
  static Duration get position => _player.position;
  static Duration? get duration => _player.duration;

  static Stream<Duration> get positionStream => _player.positionStream;
  static Stream<Duration?> get durationStream => _player.durationStream;
  static Stream<bool> get playingStream => _player.playingStream;
  static Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;

  // ── Cleanup ─────────────────────────────────────────────────────────────────

  static Future<void> dispose() => _player.dispose();
}