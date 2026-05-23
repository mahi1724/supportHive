import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ChatMessage model
// ─────────────────────────────────────────────────────────────────────────────
class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessage.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id:       doc.id,
      senderId: d['senderId'] as String,
      text:     d['text']     as String,
      sentAt:   (d['sentAt'] as Timestamp).toDate(),
      isRead:   d['isRead']   as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text':     text,
    'sentAt':   Timestamp.fromDate(sentAt),
    'isRead':   isRead,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// ChatService  –  Firestore-backed real-time chat
//
// Firestore structure:
//   chats/{chatRoomId}/messages/{msgId}
//   chats/{chatRoomId}  →  { participants: [uid1, uid2], typing: {uid: bool} }
// ─────────────────────────────────────────────────────────────────────────────
class ChatService {
  final _db = FirebaseFirestore.instance;

  // ── Create or retrieve a chat room between two users ──────────────────────
  Future<String> getOrCreateChatRoom(String myId, String peerId) async {
    final ids = [myId, peerId]..sort();
    final roomId = '${ids[0]}_${ids[1]}';

    final ref = _db.collection('chats').doc(roomId);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'participants': ids,
        'createdAt':    FieldValue.serverTimestamp(),
        'typing':       {myId: false, peerId: false},
      });
    }
    return roomId;
  }

  // ── Send a message ────────────────────────────────────────────────────────
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    await _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(ChatMessage(
          id:       '',
          senderId: senderId,
          text:     text.trim(),
          sentAt:   DateTime.now(),
        ).toMap());
  }

  // ── Listen to messages in real time ──────────────────────────────────────
  Stream<List<ChatMessage>> messagesStream(String chatRoomId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(ChatMessage.fromDoc).toList());
  }

  // ── Typing indicator ──────────────────────────────────────────────────────
  Future<void> setTyping(String chatRoomId, String userId, bool isTyping) async {
    await _db.collection('chats').doc(chatRoomId).update({
      'typing.$userId': isTyping,
    });
  }

  Stream<bool> peerTypingStream(String chatRoomId, String peerId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .snapshots()
        .map((snap) {
          final data = snap.data();
          if (data == null) return false;
          final typing = data['typing'] as Map<String, dynamic>? ?? {};
          return typing[peerId] as bool? ?? false;
        });
  }

  // ── Mark messages as read ─────────────────────────────────────────────────
  Future<void> markRead(String chatRoomId, String myId) async {
    final unread = await _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderId', isNotEqualTo: myId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}