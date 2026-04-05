import 'package:flutter/material.dart';
import 'package:supporthive1/model/Playlist_model.dart';
import 'package:supporthive1/view/widgets/Playlist_card.dart';

class MusicLibraryScreen extends StatefulWidget {
  const MusicLibraryScreen({super.key});

  @override
  State<MusicLibraryScreen> createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen> {
  int selectedTab = 0;

  final List<Playlist> playlists = [
    Playlist(
      title: "Calm Meditation",
      subtitle: "Peaceful music for deep meditation",
      songs: "12 songs",
      duration: "1h 25m",
      color: Colors.purple,
    ),
    Playlist(
      title: "Deep Sleep",
      subtitle: "Soothing sounds for better sleep",
      songs: "10 songs",
      duration: "2h 15m",
      color: Colors.blue,
    ),
    Playlist(
      title: "Stress Relief",
      subtitle: "Relax and release tension",
      songs: "8 songs",
      duration: "45m",
      color: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeader(),

          const SizedBox(height: 10),

          _buildTabs(),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: playlists.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "All Playlists",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                final playlist = playlists[index - 1];

                return PlaylistCard(
                  playlist: playlist,
                  onPlay: () {
                    print("Playing ${playlist.title}");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 HEADER
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF3D7A2A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const Spacer(),
              const Icon(Icons.settings, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Music Library",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const Text(
            "Discover wellness through music",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Search
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: "Search songs, artists, or albums...",
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip("All", true),
                _chip("Meditation", false),
                _chip("Sleep", false),
                _chip("Relaxation", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Tabs
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _tab("Playlists", 0),
          _tab("All Songs", 1),
          _tab("Library", 2),
        ],
      ),
    );
  }

  Widget _tab(String text, int index) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedTab = index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(text),
        backgroundColor: selected ? Colors.white : Colors.green.shade700,
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}