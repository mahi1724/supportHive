import 'package:flutter/material.dart';
import 'package:supporthive1/model/music.dart';
import 'package:supporthive1/service/audio_service.dart';
import 'dart:async';
import 'package:supporthive1/view/widgets/music_library_screen.dart';

class MusicSection extends StatefulWidget {
  final List<Music> musicList;
  final Function(String) onPlayMusic;

  const MusicSection({
    super.key,
    required this.musicList,
    required this.onPlayMusic,
  });

  @override
  State<MusicSection> createState() => _MusicSectionState();
}

class _MusicSectionState extends State<MusicSection> {
  int _currentPage = 0;
  Timer? _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || widget.musicList.isEmpty) return;

      int nextPage = _currentPage + 1;

      if (nextPage >= widget.musicList.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade100, Colors.purple.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.music_note, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Relaxing Music',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  AudioService.stop(); // 🔥 stop before navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MusicLibraryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // PAGE VIEW
          SizedBox(
            height: 260, // 🔥 increased height (fix overflow)
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: widget.musicList
                  .map((music) => _buildMusicCard(music))
                  .toList(),
            ),
          ),

          const SizedBox(height: 12),

          // DOT INDICATOR
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.musicList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.purple
                        : Colors.purple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 FIXED MUSIC CARD (NO OVERFLOW)
  Widget _buildMusicCard(Music music) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView( // 🔥 prevents overflow
        child: Column(
          children: [
            const SizedBox(height: 12),

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4A6741),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.music_note,
                  color: Colors.white, size: 40),
            ),

            const SizedBox(height: 10),

            Text(
              music.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              music.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                AudioService.stop(); // 🔥 prevent overlap
                AudioService.play(music.source,
                    isAsset: music.isAsset);
              },
              icon: const Icon(Icons.play_arrow, size: 16),
              label: const Text('Play'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6741),
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            ElevatedButton.icon(
              onPressed: () {
                AudioService.pause();
              },
              icon: const Icon(Icons.pause, size: 16),
              label: const Text('Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade700,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}