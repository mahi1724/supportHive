import 'dart:io';
import 'package:flutter/foundation.dart';
import '../model/podcast.dart';
import '../service/audio_service.dart';
import '../service/cloudinary_service.dart';
import '../service/firestore_service.dart';

enum PodcastStatus { idle, loading, success, error }

/// Manages all podcast-related state and business logic.
/// Consumed via [ChangeNotifierProvider] in the widget tree.
class PodcastController extends ChangeNotifier {
  // ── Dependencies ────────────────────────────────────────────────────────────
  final FirestoreService _firestoreService = FirestoreService.instance;

  // ── State ───────────────────────────────────────────────────────────────────
  List<Podcast> _podcasts = [];
  List<Podcast> get podcasts => List.unmodifiable(_podcasts);

  Podcast? _currentPodcast;
  Podcast? get currentPodcast => _currentPodcast;

  PodcastStatus _status = PodcastStatus.idle;
  PodcastStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Upload-specific progress (0.0 – 1.0)
  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  // ── Firestore stream ────────────────────────────────────────────────────────

  void startListening() {
    _firestoreService.podcastsStream().listen(
      (list) {
        _podcasts = list;
        _status = PodcastStatus.success;
        notifyListeners();
      },
      onError: (e) {
        _setError(e.toString());
      },
    );
  }

  // ── Playback ────────────────────────────────────────────────────────────────

  Future<void> playPodcast(Podcast podcast) async {
    try {
      _currentPodcast = podcast;
      notifyListeners();

      // Use videoUrl if present (Cloudinary hosted), otherwise audioUrl
      final url = podcast.videoUrl.isNotEmpty ? podcast.videoUrl : podcast.audioUrl;
      if (url.isEmpty) throw Exception('No playable URL for this podcast.');

      await AudioService.play(url);

      // Increment play count without blocking UI
      if (podcast.id.isNotEmpty) {
        _firestoreService.incrementPlayCount(podcast.id).catchError((_) {});
      }
    } catch (e) {
      _setError('Playback error: $e');
    }
  }

  Future<void> stopPlayback() async {
    await AudioService.stop();
    _currentPodcast = null;
    notifyListeners();
  }

  // ── Create podcast ──────────────────────────────────────────────────────────

  /// Uploads [mediaFile] to Cloudinary, then saves podcast metadata to Firestore.
  ///
  /// Returns `true` on success, `false` on failure (error stored in [errorMessage]).
  Future<bool> createPodcast({
    required String title,
    required String author,
    required String category,
    required String description,
    required File mediaFile,
    String imageUrl = '',
  }) async {
    if (title.isEmpty || author.isEmpty || category.isEmpty) {
      _setError('Title, author, and category are required.');
      return false;
    }

    _isUploading = true;
    _uploadProgress = 0.0;
    _status = PodcastStatus.loading;
    notifyListeners();

    try {
      // 1. Upload media to Cloudinary
      final result = await CloudinaryService.uploadMedia(
        mediaFile,
        resourceType: 'video', // handles audio & video
        onProgress: (p) {
          _uploadProgress = p;
          notifyListeners();
        },
      );

      // 2. Derive a human-readable duration string from Cloudinary metadata
      final durationStr = _formatDuration(result.duration);

      // 3. Build podcast model
      final podcast = Podcast(
        id: '', // Firestore generates this
        title: title,
        author: author,
        authorId: '', // FirestoreService fills this from FirebaseAuth
        category: category,
        duration: durationStr,
        audioUrl: result.resourceType == 'video' ? '' : result.secureUrl,
        videoUrl: result.resourceType == 'video' ? result.secureUrl : '',
        imageUrl: imageUrl,
        description: description,
        isNew: true,
        createdAt: DateTime.now(),
      );

      // 4. Save to Firestore
      await _firestoreService.addPodcast(podcast);

      _isUploading = false;
      _status = PodcastStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _isUploading = false;
      _setError('Upload failed: $e');
      return false;
    }
  }

  /// Deletes a podcast from Firestore (and optionally from Cloudinary via a
  /// Cloud Function trigger — not done here to avoid leaking API secret).
  Future<bool> deletePodcast(String id) async {
    try {
      await _firestoreService.deletePodcast(id);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _setError(String message) {
    _errorMessage = message;
    _status = PodcastStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    if (_status == PodcastStatus.error) {
      _status = PodcastStatus.idle;
    }
    notifyListeners();
  }

  static String _formatDuration(int seconds) {
    if (seconds <= 0) return '00:00';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    // Do NOT dispose AudioService here — it is a global singleton.
    super.dispose();
  }
}