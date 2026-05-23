import 'package:flutter/material.dart';
import '../../../controller/peer_controller.dart';
import 'peer_list_screen.dart';

class PeerSupportScreen extends StatefulWidget {
  const PeerSupportScreen({super.key});

  @override
  State<PeerSupportScreen> createState() => _PeerSupportScreenState();
}

class _PeerSupportScreenState extends State<PeerSupportScreen> {
  final TextEditingController _textController = TextEditingController();
  final PeerController        _peerController = PeerController();

  bool _isAvailable = false;
  bool _isFinding   = false;
  // ── NEW: wait for Firebase Auth UID before allowing any action ────────────
  bool _isInitialising = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  // ── Await stable UID from Firebase Auth ───────────────────────────────────
  Future<void> _initController() async {
    await _peerController.initUser();   // async now — gets Firebase Auth UID
    if (!mounted) return;
    setState(() => _isInitialising = false);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // ── Find peer support ──────────────────────────────────────────────────────
  Future<void> _findPeerSupport() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe how you are feeling first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isFinding = true);

    // ── Fetch peers from Firestore (not in-memory) ─────────────────────────
    await _peerController.findPeers();

    if (!mounted) return;
    setState(() => _isFinding = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PeerListScreen(
          peers:    _peerController.availablePeers,
          myUserId: _peerController.currentUser.id,
        ),
      ),
    );
  }

  // ── Toggle availability — now awaited so Firestore write completes ─────────
  Future<void> _toggleAvailability(bool val) async {
    setState(() => _isAvailable = val);
    await _peerController.toggleAvailability(val);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(val
            ? 'You are now available to help others'
            : 'You are now unavailable'),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            val ? const Color(0xFF4A6741) : Colors.grey.shade700,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Show spinner while Firebase Auth UID is being resolved
    if (_isInitialising) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Peer Support',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildToggleCard(),
            const SizedBox(height: 16),
            _buildAnonymousCard(),
            const SizedBox(height: 16),
            _buildRequestCard(),
            const SizedBox(height: 16),
            _buildGuidelines(),
            const SizedBox(height: 16),
            _buildHowItWorks(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Peer Support',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Connect with understanding peers',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAvailable
                      ? 'Available for Peer Support'
                      : 'Currently Unavailable',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isAvailable
                        ? const Color(0xFF4A6741)
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Toggle to help others in need',
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            // ── Calls the now-async toggle ─────────────────────────────────
            onChanged: _toggleAvailability,
            activeColor: const Color(0xFF4A6741),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymousCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4A6741).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined,
                color: Color(0xFF4A6741), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('100% Anonymous Support',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                    'Only usernames are visible. No personal data is shared.',
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Request Peer Support',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            controller: _textController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "I'm feeling anxious about…",
              hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF5F5F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF4A6741), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isFinding ? null : _findPeerSupport,
              icon: _isFinding
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.search, color: Colors.white),
              label: Text(
                _isFinding ? 'Finding peers…' : 'Find Peer Support',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A7BD5),
                disabledBackgroundColor:
                    const Color(0xFF3A7BD5).withOpacity(0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelines() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(borderColor: Colors.orange.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.gavel_outlined,
                color: Colors.orange.shade700, size: 18),
            const SizedBox(width: 8),
            const Text('Community Guidelines',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          _guidelineTile('Be kind and respectful'),
          _guidelineTile('Keep conversations confidential'),
          _guidelineTile('No personal info sharing'),
        ],
      ),
    );
  }

  Widget _guidelineTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        const Icon(Icons.check_circle_outline,
            size: 16, color: Color(0xFF4A6741)),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ]),
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      'Share your feelings in the text box above',
      'Available peers will be shown to you',
      'Start an anonymous chat with a peer',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How It Works',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: const BoxDecoration(
                          color: Color(0xFF3A7BD5), shape: BoxShape.circle),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  BoxDecoration _cardStyle({Color borderColor = Colors.transparent}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor),
      boxShadow: const [
        BoxShadow(
            color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
      ],
    );
  }
}