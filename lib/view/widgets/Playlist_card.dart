import 'package:flutter/material.dart';
import 'package:supporthive1/model/Playlist_model.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onPlay;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: playlist.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.music_note, color: Colors.white),
          ),

          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  playlist.subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text("🎵 ${playlist.songs}",
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 10),
                    Text("⏱ ${playlist.duration}",
                        style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          ),

          // Play button
          CircleAvatar(
            backgroundColor: const Color(0xFF3D7A2A),
            child: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: onPlay,
            ),
          )
        ],
      ),
    );
  }
}