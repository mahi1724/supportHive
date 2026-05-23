import 'package:flutter/material.dart';
import 'package:supporthive1/view/screens/counselling/ai_chat_screen.dart';

// ─── Data model for a search result item ────────────────────────────────────
class _SearchItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String category;

  const _SearchItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.category,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const Color _brandGreen = Color(0xFF4A6741);
  static const Color _bgColor = Color(0xFFF5F5F0);

  // ── All searchable items ────────────────────────────────────────────────
  static const List<_SearchItem> _allItems = [
    _SearchItem(
        title: 'Nature Sounds',
        subtitle: 'Calming music for relaxation',
        icon: Icons.music_note,
        color: Color(0xFF7B1FA2),
        category: 'Music'),
    _SearchItem(
        title: 'Sleep Sounds',
        subtitle: 'Deep sleep audio tracks',
        icon: Icons.bedtime_outlined,
        color: Color(0xFF5E35B1),
        category: 'Music'),
    _SearchItem(
        title: 'Meditation Music',
        subtitle: 'Focus and calm your mind',
        icon: Icons.self_improvement,
        color: Color(0xFF7B1FA2),
        category: 'Music'),
    _SearchItem(
        title: 'Anxiety Relief',
        subtitle: 'Expert podcast on managing anxiety',
        icon: Icons.mic,
        color: Color(0xFF1565C0),
        category: 'Podcast'),
    _SearchItem(
        title: 'Stress Management',
        subtitle: 'Weekly wellness podcast',
        icon: Icons.headphones,
        color: Color(0xFF0277BD),
        category: 'Podcast'),
    _SearchItem(
        title: 'Mindfulness Podcast',
        subtitle: 'Daily mindfulness practices',
        icon: Icons.podcasts,
        color: Color(0xFF1565C0),
        category: 'Podcast'),
    _SearchItem(
        title: 'Daily Journal',
        subtitle: 'Write and reflect on your day',
        icon: Icons.book_outlined,
        color: Color(0xFF2E7D32),
        category: 'Diary'),
    _SearchItem(
        title: 'Mood Tracker',
        subtitle: 'Track your emotional patterns',
        icon: Icons.mood,
        color: Color(0xFF388E3C),
        category: 'Diary'),
    _SearchItem(
        title: 'Gratitude Log',
        subtitle: 'Daily gratitude practice',
        icon: Icons.favorite_outline,
        color: Color(0xFF2E7D32),
        category: 'Diary'),
    _SearchItem(
        title: 'Anxiety Quiz',
        subtitle: 'Assess your anxiety levels',
        icon: Icons.quiz_outlined,
        color: Color(0xFFE65100),
        category: 'Quiz'),
    _SearchItem(
        title: 'Wellness Check',
        subtitle: 'Full mental wellness assessment',
        icon: Icons.health_and_safety_outlined,
        color: Color(0xFFF57C00),
        category: 'Quiz'),
    _SearchItem(
        title: 'Stress Test',
        subtitle: 'Measure your stress levels',
        icon: Icons.psychology_outlined,
        color: Color(0xFFE65100),
        category: 'Quiz'),
    _SearchItem(
        title: 'Chat with Hive AI',
        subtitle: 'Your personal wellness assistant',
        icon: Icons.smart_toy_outlined,
        color: Color(0xFF4A6741),
        category: 'AI'),
    _SearchItem(
        title: 'Breathing Exercise',
        subtitle: '4-7-8 breathing technique',
        icon: Icons.air,
        color: Color(0xFF00695C),
        category: 'Activity'),
    _SearchItem(
        title: 'Body Scan',
        subtitle: 'Progressive muscle relaxation',
        icon: Icons.accessibility_new,
        color: Color(0xFF00838F),
        category: 'Activity'),
  ];

  List<_SearchItem> _filteredItems = [];
  List<String> _recentSearches = [];
  String _activeCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps, 'color': Color(0xFF4A6741)},
    {'label': 'Music', 'icon': Icons.music_note, 'color': Color(0xFF7B1FA2)},
    {'label': 'Podcast', 'icon': Icons.mic, 'color': Color(0xFF1565C0)},
    {'label': 'Diary', 'icon': Icons.book_outlined, 'color': Color(0xFF2E7D32)},
    {'label': 'Quiz', 'icon': Icons.quiz_outlined, 'color': Color(0xFFE65100)},
    {'label': 'Activity', 'icon': Icons.directions_run, 'color': Color(0xFF00695C)},
  ];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterItems();
  }

  void _filterItems() {
    final query = _controller.text.toLowerCase().trim();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesQuery = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            item.subtitle.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query);
        final matchesCategory =
            _activeCategory == 'All' || item.category == _activeCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() => _activeCategory = category);
    _filterItems();
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
    });
    _filterItems();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _activeCategory = 'All');
    _filterItems();
  }

  void _tapRecentSearch(String query) {
    _controller.text = query;
    _controller.selection =
        TextSelection.collapsed(offset: query.length);
    _filterItems();
  }

  void _removeRecent(String query) {
    setState(() => _recentSearches.remove(query));
  }

  void _onItemTap(_SearchItem item) {
    _submitSearch(item.title);
    if (item.category == 'AI') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AIChatScreen()),
      );
      return;
    }
    // Show a snackbar for now — wire to real screens as needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${item.title}…'),
        backgroundColor: _brandGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bool isSearching = _controller.text.isNotEmpty;

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryChips(),
            const SizedBox(height: 4),
            Expanded(
              child: isSearching ? _buildResults() : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Search',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          if (_controller.text.isNotEmpty)
            TextButton(
              onPressed: _clearSearch,
              child: const Text('Clear',
                  style: TextStyle(color: _brandGreen)),
            ),
        ],
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: _submitSearch,
        decoration: InputDecoration(
          hintText: 'Search music, podcasts, diary…',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _brandGreen),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _brandGreen, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Category Chips ──────────────────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isSelected = _activeCategory == cat['label'];
          return GestureDetector(
            onTap: () => _selectCategory(cat['label'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (cat['color'] as Color)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (cat['color'] as Color)
                      : Colors.grey.shade200,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              (cat['color'] as Color).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 14,
                    color: isSelected
                        ? Colors.white
                        : (cat['color'] as Color),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Empty State (before any search) ────────────────────────────────────────
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            _sectionTitle('Recent Searches'),
            const SizedBox(height: 8),
            ..._recentSearches
                .map((q) => _recentSearchTile(q))
                .toList(),
            const SizedBox(height: 20),
          ],

          // Category grid
          _sectionTitle('Browse Categories'),
          const SizedBox(height: 12),
          _buildCategoryGrid(),

          const SizedBox(height: 20),

          // Suggested
          _sectionTitle('Suggested for You'),
          const SizedBox(height: 8),
          ..._allItems
              .take(4)
              .map((item) => _buildResultTile(item))
              .toList(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _recentSearchTile(String query) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            const Icon(Icons.history, size: 18, color: Colors.black54),
      ),
      title: Text(query,
          style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: IconButton(
        icon: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
        onPressed: () => _removeRecent(query),
      ),
      onTap: () => _tapRecentSearch(query),
    );
  }

  Widget _buildCategoryGrid() {
    final displayCats = _categories.skip(1).toList(); // skip 'All'
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (_, i) {
        final cat = displayCats[i];
        return GestureDetector(
          onTap: () {
            _selectCategory(cat['label'] as String);
            _focusNode.requestFocus();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        (cat['color'] as Color).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: cat['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Results ─────────────────────────────────────────────────────────────────
  Widget _buildResults() {
    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No results for "${_controller.text}"',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different keyword',
              style: TextStyle(
                  color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: _filteredItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (_, i) => _buildResultTile(_filteredItems[i]),
    );
  }

  Widget _buildResultTile(_SearchItem item) {
    return GestureDetector(
      onTap: () => _onItemTap(item),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.category,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: item.color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios,
                size: 12, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}