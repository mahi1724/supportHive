import 'package:flutter/material.dart';
import '../../../model/peer_user_model.dart';
import '../../../service/peer_service.dart';
import 'peer_chat_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PeerListScreen  –  live Firestore stream of available peers
//
// KEY CHANGE: Uses StreamBuilder on PeerService.availablePeersStream() instead
// of a static List passed from the parent. This means if a peer toggles their
// availability while this screen is open, the list updates instantly.
// ─────────────────────────────────────────────────────────────────────────────
class PeerListScreen extends StatelessWidget {
  // peers is kept for backwards compat but the screen now uses the live stream
  final List<PeerUser> peers;
  final String myUserId;

  const PeerListScreen({
    super.key,
    required this.peers,
    required this.myUserId,
  });

  static const _seaBlue   = Color(0xFF3A7BD5);
  static const _seaLight  = Color(0xFFEBF2FF);
  static const _sage      = Color(0xFF4A6741);
  static const _sageLight = Color(0xFFEEF5EA);
  static const _mist      = Color(0xFFF4F6F8);

  @override
  Widget build(BuildContext context) {
    final peerService = PeerService();

    return Scaffold(
      backgroundColor: _mist,
      appBar: AppBar(
        title: const Text('Available peers',
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        // ── Live peer count in the chip ─────────────────────────────────────
        actions: [
          StreamBuilder<List<PeerUser>>(
            stream: peerService.availablePeersStream(myUserId),
            builder: (_, snap) {
              final count = snap.data?.length ?? peers.length;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  label: Text('$count online',
                      style: const TextStyle(
                          fontSize: 11,
                          color: _sage,
                          fontWeight: FontWeight.w600)),
                  backgroundColor: _sageLight,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAnonymityBanner(),
          Expanded(
            // ── LIVE stream replaces the static list ────────────────────────
            child: StreamBuilder<List<PeerUser>>(
              stream: peerService.availablePeersStream(myUserId),
              initialData: peers,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting &&
                    !snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final livePeers = snap.data ?? peers;
                return livePeers.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        itemCount: livePeers.length + 1,
                        itemBuilder: (ctx, i) {
                          if (i == livePeers.length) {
                            return _buildGuidelinesCard();
                          }
                          return _PeerCard(
                            peer: livePeers[i],
                            onChat: () => Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => PeerChatScreen(
                                  peer:     livePeers[i],
                                  myUserId: myUserId,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymityBanner() => Container(
    width: double.infinity,
    color: _seaLight,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.lock_outline, size: 13, color: Color(0xFF185FA5)),
        SizedBox(width: 6),
        Text('All conversations are 100% anonymous',
            style: TextStyle(fontSize: 12, color: Color(0xFF185FA5))),
      ],
    ),
  );

  Widget _buildEmpty() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No peers available right now',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Please check back in a few minutes, or consider being a peer supporter yourself.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    ),
  );

  Widget _buildGuidelinesCard() => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.orange.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.gavel_outlined,
              size: 15, color: Colors.orange.shade700),
          const SizedBox(width: 6),
          const Text('Community reminder',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
        const SizedBox(height: 8),
        _GuidelineTile('Be kind and respectful at all times'),
        _GuidelineTile('Keep all conversations confidential'),
        _GuidelineTile('Do not share any personal information'),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
class _PeerCard extends StatelessWidget {
  final PeerUser     peer;
  final VoidCallback onChat;
  const _PeerCard({required this.peer, required this.onChat});

  static const _seaBlue = Color(0xFF3A7BD5);
  static const _sage    = Color(0xFF4A6741);

  static final List<Color> _bgColors = [
    const Color(0xFFEBF2FF), const Color(0xFFEEF5EA),
    const Color(0xFFEEEDFE), const Color(0xFFFAEEDA),
  ];
  static final List<Color> _fgColors = [
    const Color(0xFF185FA5), const Color(0xFF3B6D11),
    const Color(0xFF534AB7), const Color(0xFF854F0B),
  ];

  @override
  Widget build(BuildContext context) {
    final idx     = peer.username.hashCode.abs() % _bgColors.length;
    final initial = peer.username.startsWith('@') && peer.username.length > 1
        ? peer.username[1].toUpperCase()
        : peer.username[0].toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(14, 8, 12, 8),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: _bgColors[idx],
              child: Text(initial,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _fgColors[idx],
                      fontSize: 14)),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 11, height: 11,
                decoration: BoxDecoration(
                  color: _sage,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(peer.username,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87)),
        subtitle: const Text('Here to listen · Active now',
            style: TextStyle(fontSize: 12, color: Colors.black45)),
        trailing: ElevatedButton(
          onPressed: onChat,
          style: ElevatedButton.styleFrom(
            backgroundColor: _seaBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            textStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600),
          ),
          child: const Text('Chat'),
        ),
      ),
    );
  }
}

class _GuidelineTile extends StatelessWidget {
  final String text;
  const _GuidelineTile(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(children: [
      const Icon(Icons.check_circle_outline,
          size: 15, color: Color(0xFF4A6741)),
      const SizedBox(width: 7),
      Text(text,
          style: const TextStyle(fontSize: 12, color: Colors.black87)),
    ]),
  );
}