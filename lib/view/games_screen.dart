// import 'package:flutter/material.dart';
// import '../controller/game_controller.dart';

// class MindfulGamesScreen extends StatefulWidget {
//   const MindfulGamesScreen({super.key});

//   @override
//   State<MindfulGamesScreen> createState() =>
//       _MindfulGamesScreenState();
// }

// class _MindfulGamesScreenState extends State<MindfulGamesScreen> {
//   late GameController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = GameController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F0),

//       body: AnimatedBuilder(
//         animation: controller,
//         builder: (_, __) {
//           return Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 20),
//                       _buildDifficultySection(),
//                       const SizedBox(height: 24),
//                       _buildGameCard(),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   /// HEADER
//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF4A6741), Color(0xFF5A7751)],
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon:
//                       const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const Padding(
//               padding: EdgeInsets.all(20),
//               child: Text(
//                 "Mindful Games",
//                 style: TextStyle(
//                   fontSize: 28,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   /// DIFFICULTY
//   Widget _buildDifficultySection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           _buildBtn("Easy"),
//           _buildBtn("Moderate"),
//           _buildBtn("High"),
//         ],
//       ),
//     );
//   }

//   Widget _buildBtn(String d) {
//     final selected = controller.selectedDifficulty == d;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => controller.setDifficulty(d),
//         child: Container(
//           margin: const EdgeInsets.all(6),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color:
//                 selected ? const Color(0xFF4A6741) : Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             d,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: selected ? Colors.white : Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// GAME CARD
//   Widget _buildGameCard() {
//     final game = controller.selectedGame;

//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(game.title,
//               style: const TextStyle(
//                   fontSize: 22, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Text(game.category),
//           const SizedBox(height: 10),
//           Text(game.description),
//           const SizedBox(height: 10),
//           Text("Duration: ${game.duration}"),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               _stat("😊", game.likes.toString()),
//               _stat("🔥", game.streakPoints.toString()),
//               _stat("⬆️", game.level.toString()),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               print("Play ${game.title}");
//             },
//             child: const Text("Play"),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _stat(String e, String v) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: Row(
//         children: [Text(e), Text(v)],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../controller/game_controller.dart';

class MindfulGamesScreen extends StatefulWidget {
  const MindfulGamesScreen({super.key});

  @override
  State<MindfulGamesScreen> createState() => _MindfulGamesScreenState();
}

class _MindfulGamesScreenState extends State<MindfulGamesScreen> {
  late GameController controller;

  @override
  void initState() {
    super.initState();
    controller = GameController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),

      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  children: [
                    _buildDifficultySection(),

                    const SizedBox(height: 20),

                    /// 🔥 MULTIPLE GAMES (SAFE)
                    ...controller
                        .getGamesByLevel(controller.selectedDifficulty)
                        .map(
                          (game) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: _buildGameCard(game),
                          ),
                        )
                        ,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔹 HEADER (ENHANCED)
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A6741), Color(0xFF6E8B5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Icon(Icons.spa, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// TITLE
            const Text(
              "Mindful Games",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Relax • Play • Heal",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 DIFFICULTY BUTTONS (PILLS)
  Widget _buildDifficultySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDifficultyBtn("Easy"),
        _buildDifficultyBtn("Moderate"),
        _buildDifficultyBtn("High"),
      ],
    );
  }

  // Widget _buildDifficultySection() {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       child: Row(
  //         children: [
  //           _buildDifficultyBtn("Easy"),
  //           _buildDifficultyBtn("Moderate"),
  //           _buildDifficultyBtn("High"),
  //         ],
  //       ),
  //     );
  //   }

  Widget _buildDifficultyBtn(String difficulty) {
    final selected = controller.selectedDifficulty == difficulty;

    return GestureDetector(
      onTap: () => controller.setDifficulty(difficulty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4A6741) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        child: Text(
          difficulty,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  /// 🔹 GAME CARD (PREMIUM STYLE)
  Widget _buildGameCard(game) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.purple.shade100],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON + DIFFICULTY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(Icons.air, size: 30, color: Colors.blue.shade400),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    game.difficulty,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              game.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// CATEGORY
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(game.category, style: const TextStyle(fontSize: 12)),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            Text(
              game.description,
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 12),

            /// DURATION
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 6),
                Text(game.duration),
              ],
            ),

            const SizedBox(height: 14),

            /// STATS
            Row(
              children: [
                _stat("😊", game.likes.toString()),
                _stat("🔥", game.streakPoints.toString()),
                _stat("⬆️", game.level.toString()),
              ],
            ),

            const SizedBox(height: 20),

            /// PLAY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.openGame(context, game);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6741),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Play Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String e, String v) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(children: [Text(e), const SizedBox(width: 4), Text(v)]),
    );
  }
}
