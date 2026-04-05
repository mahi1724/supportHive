import 'package:flutter/material.dart';
import 'package:supporthive1/model/podcast.dart';

class PodcastSection extends StatelessWidget {
  final List<Podcast> podcasts;
  final Function(Podcast) onListenPodcast;

  const PodcastSection({
    super.key,
    required this.podcasts,
    required this.onListenPodcast,
  });

  @override
  Widget build(BuildContext context) {
    if (podcasts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.mic, color: Color(0xFF4A6741)),
              SizedBox(width: 8),
              Text(
                'New Podcasts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔥 UPDATED: Loop through all podcasts
          Column(
            children: podcasts.map((podcast) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // 🔥 NEW badge per podcast
                    if (podcast.isNew)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.mic, color: Colors.white, size: 40),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      podcast.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      podcast.author,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),

                    Text(
                      '${podcast.category} • ${podcast.duration}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => onListenPodcast(podcast),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Listen Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6741),
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}