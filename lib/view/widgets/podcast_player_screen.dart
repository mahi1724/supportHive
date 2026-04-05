import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:supporthive1/model/podcast.dart';
import 'package:supporthive1/view/widgets/create_podcast_screen.dart';

class PodcastPlayerScreen extends StatefulWidget {
  final Podcast podcast;

  const PodcastPlayerScreen({super.key, required this.podcast});

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      print("Loading audio: ${widget.podcast.audioUrl}");

      // 🔥 FIX: Use setAsset for local audio
      await _player.setAsset(widget.podcast.audioUrl);

      // Listen duration
      _player.durationStream.listen((d) {
        if (d != null) {
          setState(() {
            _duration = d;
            _isLoading = false;
          });
        }
      });

      // Listen position
      _player.positionStream.listen((p) {
        setState(() => _position = p);
      });
    } catch (e) {
      print("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    final podcast = widget.podcast;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // 🔹 Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Podcast Player",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Cover
                  Container(
                    height: 220,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(Icons.mic,
                              size: 100, color: Colors.white70),
                        ),
                        if (podcast.isNew)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "NEW",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Title
                  Text(
                    podcast.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    podcast.author,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Slider
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _player.seek(Duration(seconds: value.toInt()));
                    },
                  ),

                  // 🔹 Time
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(_position)),
                        Text(formatTime(_duration)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ⏪ Backward
                      IconButton(
                        icon: const Icon(Icons.replay_10),
                        onPressed: () {
                          _player.seek(
                              _position - const Duration(seconds: 10));
                        },
                      ),

                      // ▶️ Play / Pause
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playing =
                              snapshot.data?.playing ?? false;

                          return IconButton(
                            icon: Icon(
                              playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40,
                            ),
                            onPressed: () async {
                              if (playing) {
                                await _player.pause();
                              } else {
                                await _player.play();
                              }
                            },
                          );
                        },
                      ),

                      // ⏩ Forward
                      IconButton(
                        icon: const Icon(Icons.forward_10),
                        onPressed: () {
                          _player.seek(
                              _position + const Duration(seconds: 10));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Bottom Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const CreatePodcastScreen(),
                          ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D7A2A),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(height: 4),
                        Text("CREATE",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}