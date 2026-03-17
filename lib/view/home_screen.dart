// import 'package:flutter/material.dart';
// import 'package:supporthive1/controller/home_controller.dart';
// import 'package:supporthive1/view/widgets/bottom_navigation_bar.dart';
// import 'widgets/motivational_quote_card.dart';
// import 'widgets/quiz_journal_section.dart';
// import 'widgets/music_section.dart';
// import 'widgets/podcast_section.dart';
// import 'widgets/activities_section.dart';
// import 'widgets/wellness_resources_section.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final HomeController _controller = HomeController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F0),
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//       bottomNavigationBar: CustomBottomNavigationBar(controller: _controller),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 1,
//       leading: IconButton(
//         icon: const Icon(Icons.menu, color: Colors.black87),
//         onPressed: () {},
//       ),
//       title: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.spa_outlined, color: Colors.teal.shade600, size: 24),
//           const SizedBox(width: 8),
//           const Text(
//             'SUPPORTHIVE',
//             style: TextStyle(
//               color: Color(0xFF4A6741),
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1,
//             ),
//           ),
//         ],
//       ),
//       centerTitle: true,
//       actions: [
//         Stack(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
//               onPressed: () {},
//             ),
//             Positioned(
//               right: 12,
//               top: 12,
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//                 constraints: const BoxConstraints(
//                   minWidth: 8,
//                   minHeight: 8,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const Padding(
//           padding: EdgeInsets.only(right: 8.0),
//           child: CircleAvatar(
//             backgroundColor: Color(0xFF4A6741),
//             radius: 18,
//             child: Text(
//               'G',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Tab Router ──
//   Widget _buildBody() {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         switch (_controller.selectedTabIndex) {
//           case 0:
//             return _buildHomeTab();
//           case 1:
//             return const SearchScreen();
//           case 2:
//             return const CounsellingScreen();
//           case 3:
//             return const QuizScreen();
//           default:
//             return _buildHomeTab();
//         }
//       },
//     );
//   }

//   Widget _buildHomeTab() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildWelcomeCard(),
//           MotivationalQuoteCard(quote: _controller.getDailyQuote()),
//           QuizJournalSection(
//             onOpenDiary: _controller.onOpenDiary,
//             onTakeQuiz: _controller.onTakeQuiz,
//             onCheckStatus: _controller.onCheckWellnessStatus,
//           ),
//           MusicSection(
//             musicList: _controller.getRelaxingMusic(),
//             onPlayMusic: _controller.onPlayMusic,
//           ),
//           PodcastSection(
//             podcasts: _controller.getNewPodcasts(),
//             onListenPodcast: _controller.onListenPodcast,
//           ),
//           _buildMindfulGamesSection(),
//           ActivitiesSection(
//             activities: _controller.getTodaysActivities(),
//             onStartActivity: _controller.onStartActivity,
//           ),
//           WellnessResourcesSection(
//             resources: _controller.getWellnessResources(),
//             onOpenResource: _controller.onOpenResource,
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeCard() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.green.shade100, Colors.green.shade50],
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Welcome back, Google User! 👋',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade900,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Relax, Recharge, Reflect - Your wellness journey continues today',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMindfulGamesSection() {
//     final stats = _controller.getWellnessStats();

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   const Icon(Icons.games, color: Color(0xFF4A6741)),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Mindful Games',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               IconButton(
//                 icon: const Icon(Icons.arrow_forward_ios, size: 18),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           Text(
//             'Relax through play',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Colors.blue, Colors.lightBlue],
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.gamepad, color: Colors.white, size: 40),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Bubble Breathing',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const Text(
//                   'Breathe and unwind',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatCard(
//                   'Daily Checkins',
//                   stats['dailyCheckIns'].toString(),
//                   const Color(0xFF4A6741),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildStatCard(
//                   'Active Chats',
//                   stats['activeChats'].toString(),
//                   const Color(0xFF4A6741),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildStatCard(
//             'Wellness Score',
//             stats['wellnessScore'],
//             const Color(0xFF4A6741),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF4A6741),
//                 ),
//               ),
//             ],
//           ),
//           CircleAvatar(
//             backgroundColor: color,
//             radius: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Tab Screens ───────────────────────────────────────────────────────────────
// // Replace each body with your actual screen widget when ready

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Search Screen'));
//   }
// }

// class CounsellingScreen extends StatelessWidget {
//   const CounsellingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Counselling Screen'));
//   }
// }

// class QuizScreen extends StatelessWidget {
//   const QuizScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Quiz Screen'));
//   }
// }

// import 'package:flutter/material.dart';

// class SearchScreen {
//   final TextEditingController _controller = TextEditingController();
//   bool _hasText = false;

//   final List<_CategoryItem> _categories = const [
//     _CategoryItem(
//       label: 'Music',
//       icon: Icons.music_note,
//       color: Color(0xFF7C3AED),
//     ),
//     _CategoryItem(label: 'Podcasts', icon: Icons.mic, color: Color(0xFF2563EB)),
//     _CategoryItem(
//       label: 'Diary',
//       icon: Icons.menu_book,
//       color: Color(0xFF16A34A),
//     ),
//     _CategoryItem(
//       label: 'Quiz',
//       icon: Icons.help_outline,
//       color: Color(0xFFEA580C),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0EFE9),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Header ──
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.maybePop(context),
//                     child: const Icon(Icons.close, color: Colors.black87),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Search',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // ── Search Field ──
//               TextField(
//                 controller: _controller,
//                 autofocus: true,
//                 decoration: InputDecoration(
//                   hintText: 'Search music, podcasts, diary, qu...',
//                   hintStyle: TextStyle(
//                     color: Colors.grey.shade400,
//                     fontSize: 14,
//                   ),
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   suffixIcon: _hasText
//                       ? GestureDetector(
//                           onTap: () => _controller.clear(),
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.grey,
//                             size: 18,
//                           ),
//                         )
//                       : null,
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade200),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey.shade200),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(
//                       color: Color(0xFF3D5A35),
//                       width: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // ── Empty State ──
//               if (!_hasText) ...[
//                 Center(
//                   child: Column(
//                     children: [
//                       Icon(Icons.search, size: 64, color: Colors.grey.shade300),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Search Across SupportHive',
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         'Find music, podcasts, diary entries, quizzes, and\nmore',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                       const SizedBox(height: 32),

//                       // ── Category Grid ──
//                       GridView.count(
//                         crossAxisCount: 2,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         crossAxisSpacing: 12,
//                         mainAxisSpacing: 12,
//                         childAspectRatio: 1.4,
//                         children: _categories
//                             .map((cat) => _CategoryCard(item: cat))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               // ── Search Results Placeholder ──
//               if (_hasText) ...[
//                 Text(
//                   'Results for "${_controller.text}"',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: Text(
//                     'No results found',
//                     style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Category Item Model ──────────────────────────────────────────────────────

// class _CategoryItem {
//   final String label;
//   final IconData icon;
//   final Color color;

//   const _CategoryItem({
//     required this.label,
//     required this.icon,
//     required this.color,
//   });
// }

// // ─── Category Card ────────────────────────────────────────────────────────────

// class _CategoryCard extends StatelessWidget {
//   final _CategoryItem item;

//   const _CategoryCard({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(item.icon, color: item.color, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               item.label,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF333333),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
/////////////////////////

import 'package:flutter/material.dart';
import 'package:supporthive1/controller/home_controller.dart';
import 'package:supporthive1/view/SearchScreen.dart';
import 'package:supporthive1/view/games_screen.dart';
import 'package:supporthive1/view/widgets/app_drawer.dart';
import 'package:supporthive1/view/widgets/bottom_navigation_bar.dart';
import 'widgets/motivational_quote_card.dart';
import 'widgets/quiz_journal_section.dart';
import 'widgets/music_section.dart';
import 'widgets/podcast_section.dart';
import 'widgets/activities_section.dart';
import 'widgets/wellness_resources_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(controller: _controller),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.spa_outlined, color: Colors.teal.shade600, size: 24),
          const SizedBox(width: 8),
          const Text(
            'SUPPORTHIVE',
            style: TextStyle(
              color: Color(0xFF4A6741),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black87,
              ),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF4A6741),
            radius: 18,
            child: Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Tab Router ──
  Widget _buildBody() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        switch (_controller.selectedTabIndex) {
          case 0:
            return _buildHomeTab();
          case 1:
            return SearchScreen();
          case 2:
            return const CounsellingScreen();
          case 3:
            return const MindfulGamesScreen();
          default:
            return _buildHomeTab();
        }
      },
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWelcomeCard(),
          MotivationalQuoteCard(quote: _controller.getDailyQuote()),
          QuizJournalSection(
            onOpenDiary: _controller.onOpenDiary,
            onTakeQuiz: _controller.onTakeQuiz,
            onCheckStatus: _controller.onCheckWellnessStatus,
          ),
          MusicSection(
            musicList: _controller.getRelaxingMusic(),
            onPlayMusic: _controller.onPlayMusic,
          ),
          PodcastSection(
            podcasts: _controller.getNewPodcasts(),
            onListenPodcast: _controller.onListenPodcast,
          ),
          // _buildMindfulGamesSection(),
          ActivitiesSection(
            activities: _controller.getTodaysActivities(),
            onStartActivity: _controller.onStartActivity,
          ),
          // WellnessResourcesSection(
          //   resources: _controller.getWellnessResources(),
          //   onOpenResource: _controller.onOpenResource,
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.green.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Google User!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Relax, Recharge, Reflect - Your wellness journey continues today',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6741),
                ),
              ),
            ],
          ),
          CircleAvatar(backgroundColor: color, radius: 20),
        ],
      ),
    );
  }
}

// ── Tab Screens ───────────────────────────────────────────────────────────────
// SearchScreen is now imported from search_screen.dart above.
// Replace these stubs with your real screens when ready.

class CounsellingScreen extends StatelessWidget {
  const CounsellingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Counselling Screen'));
  }
}

// class QuizScreen extends StatelessWidget {
//   const QuizScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Quiz Screen'));
//   }
// }
