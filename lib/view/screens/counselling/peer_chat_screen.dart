import 'dart:async';
import 'package:flutter/material.dart';
// ✅ Only ONE import for ChatService — from chat_service.dart
// ✅ DELETE peer_chat_service.dart from your project entirely — it is a
//    duplicate that defines ChatMessage and ChatService a second time,
//    causing "duplicate class" compile errors.
import 'package:supporthive1/service/AI_chat_service.dart' hide ChatService;
import 'package:supporthive1/service/peer_chat_service.dart';
import '../../../model/peer_user_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PeerChatScreen  –  REAL anonymous peer-to-peer chat via Firebase
// ─────────────────────────────────────────────────────────────────────────────
class PeerChatScreen extends StatefulWidget {
  final PeerUser peer;
  final String   myUserId;

  const PeerChatScreen({
    super.key,
    required this.peer,
    required this.myUserId,
  });

  @override
  State<PeerChatScreen> createState() => _PeerChatScreenState();
}

class _PeerChatScreenState extends State<PeerChatScreen> {
  static const _seaBlue  = Color(0xFF3A7BD5);
  static const _seaLight = Color(0xFFEBF2FF);
  static const _sage     = Color(0xFF4A6741);
  static const _mist     = Color(0xFFF4F6F8);

  final ChatService            _chat   = ChatService();
  final TextEditingController _input  = TextEditingController();
  final ScrollController      _scroll = ScrollController();

  String? _chatRoomId;
  bool    _isLoading = true;
  Timer?  _typingTimer;

  @override
  void initState() {
    super.initState();
    _initRoom();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    if (_chatRoomId != null) {
      _chat.setTyping(_chatRoomId!, widget.myUserId, false);
    }
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _initRoom() async {
    final roomId = await _chat.getOrCreateChatRoom(
        widget.myUserId, widget.peer.id);
    if (!mounted) return;
    setState(() { _chatRoomId = roomId; _isLoading = false; });
    _chat.markRead(roomId, widget.myUserId);
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _chatRoomId == null) return;
    _input.clear();
    _typingTimer?.cancel();
    await _chat.setTyping(_chatRoomId!, widget.myUserId, false);
    await _chat.sendMessage(
      chatRoomId: _chatRoomId!,
      senderId:   widget.myUserId,
      text:       text,
    );
    _scrollToBottom();
  }

  void _onTyping(String value) {
    if (_chatRoomId == null) return;
    _chat.setTyping(_chatRoomId!, widget.myUserId, value.isNotEmpty);
    _typingTimer?.cancel();
    if (value.isNotEmpty) {
      _typingTimer = Timer(const Duration(seconds: 2), () {
        _chat.setTyping(_chatRoomId!, widget.myUserId, false);
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
  }

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mist,
      appBar: _appBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              _anonymityBanner(),
              Expanded(child: _messageList()),
              _inputBar(),
            ]),
    );
  }

  PreferredSizeWidget _appBar(BuildContext ctx) => AppBar(
    backgroundColor: Colors.white,
    elevation: 1,
    titleSpacing: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
      onPressed: () => Navigator.pop(ctx),
    ),
    title: Row(children: [
      _Avatar(username: widget.peer.username, radius: 18),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.peer.username,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          if (_chatRoomId != null)
            StreamBuilder<bool>(
              stream: _chat.peerTypingStream(_chatRoomId!, widget.peer.id),
              builder: (_, snap) {
                final typing = snap.data ?? false;
                return Row(children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: _sage, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(typing ? 'typing…' : 'Online · Anonymous',
                      style: const TextStyle(fontSize: 11, color: _sage)),
                ]);
              },
            ),
        ],
      ),
    ]),
    actions: [
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.black87),
        onSelected: (v) { if (v == 'end') Navigator.pop(ctx); },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'end',    child: Text('End conversation')),
          const PopupMenuItem(value: 'report', child: Text('Report')),
        ],
      ),
    ],
  );

  Widget _anonymityBanner() => Container(
    width: double.infinity,
    color: _seaLight,
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
    child: const Text(
      '🔒  This chat is anonymous. No personal data is shared.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Color(0xFF185FA5)),
    ),
  );

  Widget _messageList() => StreamBuilder<List<ChatMessage>>(
    stream: _chat.messagesStream(_chatRoomId!),
    builder: (ctx, snap) {
      if (snap.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      final msgs = snap.data ?? [];
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      return ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        itemCount: msgs.length + 1,
        itemBuilder: (ctx, i) {
          if (i == 0) return const _DateDivider();
          final msg    = msgs[i - 1];
          final isLast = i == msgs.length;
          return Column(children: [
            _Bubble(
              text:         msg.text,
              isMe:         msg.senderId == widget.myUserId,
              time:         _fmt(msg.sentAt),
              peerUsername: widget.peer.username,
            ),
            if (isLast)
              StreamBuilder<bool>(
                stream: _chat.peerTypingStream(_chatRoomId!, widget.peer.id),
                builder: (_, snap) => (snap.data ?? false)
                    ? _TypingBubble(username: widget.peer.username)
                    : const SizedBox.shrink(),
              ),
          ]);
        },
      );
    },
  );

  Widget _inputBar() => Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
    child: SafeArea(
      top: false,
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _input,
            minLines: 1,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            onChanged: _onTyping,
            onSubmitted: (_) => _send(),
            decoration: InputDecoration(
              hintText: 'Type a message…',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: _mist,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _send,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
                color: _seaBlue, shape: BoxShape.circle),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ]),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String username;
  final double radius;
  const _Avatar({required this.username, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    final displayChar = username.startsWith('@') && username.length > 1
        ? username[1].toUpperCase()
        : username[0].toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFEBF2FF),
      child: Text(displayChar,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF185FA5))),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: const [
      Expanded(child: Divider(color: Colors.black12)),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Today',
              style: TextStyle(fontSize: 11, color: Colors.black38))),
      Expanded(child: Divider(color: Colors.black12)),
    ]),
  );
}

class _Bubble extends StatelessWidget {
  final String text, time, peerUsername;
  final bool   isMe;
  const _Bubble({
    required this.text,
    required this.isMe,
    required this.time,
    required this.peerUsername,
  });

  static const _blue = Color(0xFF3A7BD5);

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? _blue : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft:     const Radius.circular(18),
          topRight:    const Radius.circular(18),
          bottomLeft:  Radius.circular(isMe ? 18 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 18),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(text,
            style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isMe ? Colors.white : Colors.black87)),
        const SizedBox(height: 4),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text(time,
              style: TextStyle(
                  fontSize: 10,
                  color: isMe
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black38)),
          if (isMe) ...[
            const SizedBox(width: 3),
            Icon(Icons.done_all,
                size: 13, color: Colors.white.withOpacity(0.75)),
          ],
        ]),
      ]),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: isMe
          ? [bubble]
          : [
              _Avatar(username: peerUsername, radius: 14),
              const SizedBox(width: 6),
              bubble,
            ],
    );
  }
}

class _TypingBubble extends StatefulWidget {
  final String username;
  const _TypingBubble({required this.username});
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      _Avatar(username: widget.username, radius: 14),
      const SizedBox(width: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft:     Radius.circular(18),
            topRight:    Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft:  Radius.circular(4),
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))
          ],
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => _Dot(ctrl: _ctrl, index: i))),
      ),
    ]),
  );
}

class _Dot extends StatelessWidget {
  final AnimationController ctrl;
  final int index;
  const _Dot({required this.ctrl, required this.index});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) {
      final t = (ctrl.value - index * 0.15).clamp(0.0, 1.0);
      final b = Curves.easeInOut
          .transform((t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.0, 1.0));
      return Container(
        width: 7,
        height: 7,
        margin: EdgeInsets.only(right: index < 2 ? 4 : 0, bottom: b * 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade400, shape: BoxShape.circle),
      );
    },
  );
}