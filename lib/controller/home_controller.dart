import 'package:flutter/material.dart';
import 'package:supporthive1/model/activity.dart';
import 'package:supporthive1/model/music.dart';
import 'package:supporthive1/model/podcast.dart';
import 'package:supporthive1/model/quote.dart';
import 'package:supporthive1/model/wellness_resource.dart';
import 'package:supporthive1/view/widgets/podcast_player_screen.dart';

class HomeController extends ChangeNotifier {
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // 🔥 UPDATED: Dynamic podcast list
  final List<Podcast> _podcasts = [
    Podcast(
      title: 'The Anxiety Solution',
      author: 'Michael Roberts',
      category: 'Mental Health',
      duration: '11:00',
      audioUrl:
          "assets/audios/Secret_To_Mastering_Your_Emotions_Dr_Sweta_Adatia_Raj_Shama_podcast.mp3",
      isNew: true,
    ),
  ];

  // 🔥 NEW getter
  List<Podcast> get podcasts => _podcasts;

  // 🔥 NEW add method
  void addPodcast(Podcast podcast) {
    _podcasts.add(podcast);
    notifyListeners();
  }

  Quote getDailyQuote() {
    return Quote(
      text:
          '"Small steps in the right direction can turn out to be the biggest steps of your life."',
      author: 'Unknown',
    );
  }

  List<Activity> getTodaysActivities() {
    return [
      Activity(
        title: 'Morning Check-in',
        subtitle: "Share how you're feeling today",
        icon: Icons.wb_sunny,
        buttonText: 'Start',
      ),
      Activity(
        title: 'Mindfulness Session',
        subtitle: '15-minute guided meditation',
        icon: Icons.self_improvement,
        buttonText: 'Join',
      ),
      Activity(
        title: 'Connect with Support',
        subtitle: 'Chat with your wellness guide',
        icon: Icons.chat,
        buttonText: 'Chat',
      ),
    ];
  }

  List<Music> getRelaxingMusic() {
    return [
      Music(title: 'Nature Sounds', category: 'Nature', duration: '10:00'),
      Music(title: 'Rain & Thunder', category: 'Ambient', duration: '15:00'),
      Music(title: 'Ocean Waves', category: 'Nature', duration: '12:00'),
    ];
  }

  Map<String, dynamic> getWellnessStats() {
    return {
      'dailyCheckIns': 7,
      'activeChats': 3,
      'wellnessScore': '85%',
    };
  }

  void onOpenDiary() {}
  void onTakeQuiz() {}
  void onCheckWellnessStatus() {}
  void onPlayMusic(String musicTitle) {}

  void onListenPodcast(BuildContext context, Podcast podcast) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PodcastPlayerScreen(podcast: podcast),
      ),
    );
  }

  void onStartActivity(String activityTitle) {}
  void onOpenResource(String resourceTitle) {}
}