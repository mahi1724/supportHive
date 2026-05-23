import 'package:flutter/material.dart';
import 'package:supporthive1/model/Playlist_model.dart';
import 'package:supporthive1/model/music.dart';
import 'package:supporthive1/service/audio_service.dart';
import 'package:supporthive1/view/widgets/Playlist_card.dart';

class MusicLibraryScreen extends StatefulWidget {
  const MusicLibraryScreen({super.key});

  @override
  State<MusicLibraryScreen> createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen> {

  @override
void dispose() {
  AudioService.stop(); // 🔥 stop when leaving screen
  super.dispose();
}
  int selectedTab = 0;

  // 🎵 SONG LIST
  final List<Music> musicList = [
    Music(
        title: 'Nature Sounds',
        category: 'Nature',
        duration: '03:02',
        //url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        source: "assets/audios/nature_sound.mp3",
        isAsset: true,
      ),
      Music(
        title: 'Relaxation and Stress Relief',
        category: 'Relaxation',
        duration: '15:15',
        //url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        source: "assets/audios/deep_relaxation_stress_relief.mp3",
        isAsset: true ,
      ),
      Music(
        title: 'Positive Energy',
        category: 'Nature',
        duration: '03:04',
        //url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        source: "assets/audios/piano_music_positive_energy.mp3",
        isAsset: true,
      ),
      Music(
        title: 'Ocean Waves',
        category: 'Waves',
        duration: '03:01',
        //url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        source: "assets/audios/meditation_music_with_ocean_waves.mp3",
        isAsset: true,
      ),
      
  ];

  // 🎧 PLAYLIST LIST (FIXED ERROR)
  final List<Playlist> playlists = [
    Playlist(
      title: "Calm Meditation",
      subtitle: "Peaceful music",
      songs: "12 songs",
      duration: "1h 25m",
      color: Colors.purple,
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    ),
    Playlist(
      title: "Deep Sleep",
      subtitle: "Sleep sounds",
      songs: "10 songs",
      duration: "2h 15m",
      color: Colors.blue,
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    ),
    Playlist(
      title: "Stress Relief",
      subtitle: "Relax your mind",
      songs: "8 songs",
      duration: "45m",
      color: Colors.green,
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
    ),
    // Playlist(
    //   title: "Divine Meditation Music",
    //   subtitle: "Relax your mind",
    //   songs: "25 songs",
    //   duration: "100m",
    //   color: Colors.green,
    //   url: "https://youtube.com/playlist?list=PLmeAnT0Oi8bvS4oMI-eD2KSdHf3Bd7Umz&si=ZKkZJm-J1xAbS3cO",
    // ),
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

          // 🔥 TAB SWITCH LOGIC
          Expanded(
            child: selectedTab == 0
                ? _buildPlaylistView()
                : _buildSongsView(),
          ),
        ],
      ),
    );
  }

  // ================= PLAYLIST VIEW =================
  Widget _buildPlaylistView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: playlists.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "All Playlists",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        final playlist = playlists[index - 1];

        return PlaylistCard(
          playlist: playlist,
          onPlay: () {
            AudioService.play(playlist.url); // 🔥 FIXED
          },
        );
      },
    );
  }

  // ================= SONG VIEW =================
  Widget _buildSongsView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        final music = musicList[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(music.title),
            subtitle: Text(music.subtitle),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                AudioService.play(music.source, isAsset: music.isAsset); // 🔥 PLAY SONG
              },
            ),
          ),
        );
      },
    );
  }

  // ================= HEADER =================
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
        ],
      ),
    );
  }

  // ================= TABS =================
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