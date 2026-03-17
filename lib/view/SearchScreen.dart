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



import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  final List<_CategoryItem> _categories = const [
    _CategoryItem(label: 'Music', icon: Icons.music_note, color: Color(0xFF7C3AED)),
    _CategoryItem(label: 'Podcasts', icon: Icons.mic, color: Color(0xFF2563EB)),
    _CategoryItem(label: 'Diary', icon: Icons.menu_book, color: Color(0xFF16A34A)),
    _CategoryItem(label: 'Quiz', icon: Icons.help_outline, color: Color(0xFFEA580C)),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFE9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(Icons.close, color: Colors.black87),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Search Field ──
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search music, podcasts, diary, qu...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _hasText
                      ? GestureDetector(
                          onTap: () => _controller.clear(),
                          child: const Icon(Icons.close, color: Colors.grey, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3D5A35), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ── Empty State ──
              if (!_hasText) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'Search Across SupportHive',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Find music, podcasts, diary entries, quizzes, and more',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 32),

                          // ── Category Grid ──
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.4,
                            children: _categories
                                .map((cat) => _CategoryCard(item: cat))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // ── Search Results Placeholder ──
              if (_hasText) ...[
                Text(
                  'Results for "${_controller.text}"',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Category Item Model ──────────────────────────────────────────────────────

class _CategoryItem {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryItem({
    required this.label,
    required this.icon,
    required this.color,
  });
}

// ─── Category Card ────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;

  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.color, size: 32),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}