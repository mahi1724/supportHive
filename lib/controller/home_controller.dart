import 'package:flutter/material.dart';
import 'package:supporthive1/model/activity.dart';
import 'package:supporthive1/model/music.dart';
import 'package:supporthive1/model/podcast.dart';
import 'package:supporthive1/model/quote.dart';
import 'package:supporthive1/model/wellness_resource.dart';


class HomeController extends ChangeNotifier {
  // Navigation
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // Quote Data
  Quote getDailyQuote() {
    return Quote(
      text: '"Small steps in the right direction can turn out to be the biggest steps of your life."',
      author: 'Unknown',
      
    );
  }

  // Activities Data
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

  // Music Data
  List<Music> getRelaxingMusic() {
    return [
      Music(
        title: 'Nature Sounds',
        category: 'Nature',
        duration: '10:00',
      ),
      Music(
        title: 'Rain & Thunder',
        category: 'Ambient',
        duration: '15:00',
      ),
      Music(
        title: 'Ocean Waves',
        category: 'Nature',
        duration: '12:00',
      ),
    ];
  }

  // Podcast Data
  List<Podcast> getNewPodcasts() {
    return [
      Podcast(
        title: 'The Anxiety Solution',
        author: 'Michael Roberts',
        category: 'Mental Health',
        duration: '32:15',
        isNew: true,
      ),
    ];
  }

  // Wellness Resources Data
  // List<WellnessResource> getWellnessResources() {
  //   return [
  //     WellnessResource(
  //       emoji: '⚠️',
  //       title: 'Stress Management',
  //       description: 'Learn techniques to manage daily stress',
  //     ),
  //     WellnessResource(
  //       emoji: '💪',
  //       title: 'Building Resilience',
  //       description: 'Strengthen your mental wellness',
  //     ),
  //     WellnessResource(
  //       emoji: '☀️',
  //       title: 'Self-Care Tips',
  //       description: 'Daily practices for better wellbeing',
  //     ),
  //     WellnessResource(
  //       emoji: '📔',
  //       title: 'Guided Journals',
  //       description: 'Reflect on your wellness journey',
  //     ),
  //   ];
  // }

  // Stats Data
  Map<String, dynamic> getWellnessStats() {
    return {
      'dailyCheckIns': 7,
      'activeChats': 3,
      'wellnessScore': '85%',
    };
  }

  // Button Actions (UI only - no actual functionality)
  void onOpenDiary() {
    // UI only action
  }

  void onTakeQuiz() {
    // UI only action
  }

  void onCheckWellnessStatus() {
    // UI only action
  }

  void onPlayMusic(String musicTitle) {
    // UI only action
  }

  void onListenPodcast(String podcastTitle) {
    // UI only action
  }

  void onStartActivity(String activityTitle) {
    // UI only action
  }

  void onOpenResource(String resourceTitle) {
    // UI only action
  }
}