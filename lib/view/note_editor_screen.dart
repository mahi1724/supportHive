// ─────────────────────────────────────────────
//  screens/notes/note_editor_screen.dart  –  SupportHive
// ─────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import '../../controller/note_controller.dart';
import '../../model/note.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteController controller;
  final Note? existingNote;

  const NoteEditorScreen({
    super.key,
    required this.controller, // always passed from NotesScreen
    this.existingNote,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen>
    with SingleTickerProviderStateMixin {
  // ── Text controllers ───────────────────────
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  // ── State ─────────────────────────────────
  Timer? _debounce;
  bool _isSaving = false;
  bool _saved = false;
  int _wordCount = 0;
  int _charCount = 0;
  String? _selectedMood;

  late AnimationController _fadeIn;
  late Animation<double> _fadeAnim;

  // ── Mood options ───────────────────────────
  static const _moods = ['😌', '😔', '😤', '😢', '🥰', '😰', '😴', '✨'];

  // ── Colors ────────────────────────────────
  static const _bgColor = Color(0xFFFAF8FF);
  static const _accentColor = Color(0xFF6B52AE);
  static const _softText = Color(0xFF9B93C0);
  static const _darkText = Color(0xFF2D2640);

  @override
  void initState() {
    super.initState();

    // Pre-fill when editing
    if (widget.existingNote != null) {
      _titleCtrl.text = widget.existingNote!.title;
      _contentCtrl.text = widget.existingNote!.content;
      _selectedMood = widget.existingNote!.mood;
      _updateCounts(widget.existingNote!.content);
    }

    _titleCtrl.addListener(_onTextChanged);
    _contentCtrl.addListener(() {
      _onTextChanged();
      _updateCounts(_contentCtrl.text);
    });

    _fadeIn = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeIn, curve: Curves.easeOut);
    _fadeIn.forward();

    // Auto-focus title for new notes
    if (widget.existingNote == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_titleFocus);
      });
    }
  }

  // ── Helpers ───────────────────────────────
  void _updateCounts(String text) {
    setState(() {
      _charCount = text.length;
      _wordCount = text.trim().isEmpty
          ? 0
          : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _onTextChanged() {
    setState(() {
      _saved = false;
      _isSaving = true;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      // Pass mood so it's persisted to Firestore too
      await widget.controller.autoSave(
        _titleCtrl.text,
        _contentCtrl.text,
        mood: _selectedMood,
      );
      if (mounted) {
        setState(() {
          _isSaving = false;
          _saved = true;
        });
        Timer(const Duration(seconds: 2), () {
          if (mounted) setState(() => _saved = false);
        });
      }
    });
  }

  // Save immediately when mood changes
  void _onMoodChanged(String? mood) {
    setState(() => _selectedMood = mood);
    _onTextChanged(); // triggers debounced Firestore save
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _fadeIn.dispose();
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  // ── Save status ───────────────────────────
  Widget _saveStatus() {
    if (_isSaving) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 11,
            height: 11,
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: _softText),
          ),
          SizedBox(width: 5),
          Text('Saving…', style: TextStyle(fontSize: 11, color: _softText)),
        ],
      );
    }
    if (_saved) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_done_outlined,
              size: 13, color: Color(0xFF6BAE8A)),
          SizedBox(width: 4),
          Text('Saved',
              style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6BAE8A),
                  fontWeight: FontWeight.w600)),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  // ── Build ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final date = widget.existingNote?.date ?? DateTime.now();
    final dateStr =
        '${_weekday(date.weekday)}, ${date.day} ${_month(date.month)} ${date.year}';

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              _buildTopBar(dateStr),
              _buildMoodRow(),
              const Divider(height: 1, color: Color(0xFFE8E2F5)),
              Expanded(child: _buildEditor()),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────
  Widget _buildTopBar(String dateStr) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _accentColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _softText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                _saveStatus(),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_wordCount w · $_charCount c',
              style: const TextStyle(
                fontSize: 10.5,
                color: _accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mood selector ─────────────────────────
  Widget _buildMoodRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(
              fontSize: 11,
              color: _softText,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _moods.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final mood = _moods[i];
                final selected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () =>
                      _onMoodChanged(selected ? null : mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? _accentColor
                          : const Color(0xFFEDE9FF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: _accentColor.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(mood,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Editor area ───────────────────────────
  Widget _buildEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleCtrl,
            focusNode: _titleFocus,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              color: _darkText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Georgia',
              height: 1.3,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Give your entry a title…',
              hintStyle: TextStyle(
                color: Color(0xFFCCC7E0),
                fontSize: 22,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.w800,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_contentFocus),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: 48,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentCtrl,
            focusNode: _contentFocus,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              color: Color(0xFF4A4060),
              fontSize: 15,
              height: 1.75,
              letterSpacing: 0.1,
            ),
            decoration: const InputDecoration(
              hintText:
                  'Write freely… this is your safe space.\nNo judgement, just your thoughts.',
              hintStyle: TextStyle(
                color: Color(0xFFCCC7E0),
                fontSize: 15,
                height: 1.75,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  // ── Bottom bar – writing prompts ──────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE8E2F5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B52AE).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'WRITING PROMPTS',
            style: TextStyle(
              fontSize: 9.5,
              color: _softText,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _prompt('What am I grateful for today?'),
                _prompt('What drained my energy?'),
                _prompt('One thing I\'m proud of'),
                _prompt('What do I need right now?'),
                _prompt('A win from today'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _prompt(String text) {
    return GestureDetector(
      onTap: () {
        final current = _contentCtrl.text;
        final addition = current.isEmpty ? '$text\n' : '\n\n$text\n';
        _contentCtrl.text = current + addition;
        _contentCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: _contentCtrl.text.length),
        );
        FocusScope.of(context).requestFocus(_contentFocus);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD8D0F5), width: 1),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              color: _accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ── Date helpers ──────────────────────────
  String _weekday(int d) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];

  String _month(int m) => [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ][m - 1];
}