import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/peer_user_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PeerService  –  Firestore-backed peer registry
//
// Firestore structure:
//   peers/{uid}  →  { id, username, isAvailable, lastSeen }
//
// WHY THIS WAS BROKEN:
//   The old version used a static in-memory Map. That map was wiped every
//   app launch, so:
//     • User X visible on device A was completely unknown to device B
//     • Every session got a new timestamp UID → chat room IDs never matched
//     • Messages sent by Y never arrived at X because they were in
//       different Firestore rooms
//
// FIX:
//   • Firebase Auth anonymous sign-in gives a STABLE UID that survives
//     app restarts on the same device
//   • All peer presence is stored in Firestore so every device sees the
//     same data in real time
// ─────────────────────────────────────────────────────────────────────────────
class PeerService {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ── Stable anonymous UID (persists across launches on same device) ─────────
  Future<String> getOrCreateAnonymousUid() async {
    User? user = _auth.currentUser;
    if (user == null) {
      final cred = await _auth.signInAnonymously();
      user = cred.user!;
    }
    return user.uid;
  }

  // ── Write / refresh peer document in Firestore ────────────────────────────
  Future<void> registerUser(PeerUser peerUser) async {
    await _db.collection('peers').doc(peerUser.id).set({
      'id':          peerUser.id,
      'username':    peerUser.username,
      'isAvailable': peerUser.isAvailable,
      'lastSeen':    FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Toggle availability flag in Firestore ─────────────────────────────────
  Future<void> updateAvailability(String userId, bool isAvailable) async {
    await _db.collection('peers').doc(userId).update({
      'isAvailable': isAvailable,
      'lastSeen':    FieldValue.serverTimestamp(),
    });
  }

  // ── Fetch all available peers except self ─────────────────────────────────
  Future<List<PeerUser>> getAvailablePeers(String excludeId) async {
    final snap = await _db
        .collection('peers')
        .where('isAvailable', isEqualTo: true)
        .get();

    return snap.docs
        .where((doc) => doc.id != excludeId)
        .map((doc) {
          final d = doc.data();
          return PeerUser(
            id:          d['id']          as String,
            username:    d['username']    as String,
            isAvailable: d['isAvailable'] as bool? ?? false,
          );
        })
        .toList();
  }

  // ── Live stream of available peers except self ────────────────────────────
Stream<List<PeerUser>> availablePeersStream(String excludeId) {
  return _db
      .collection('peers')
      .where('isAvailable', isEqualTo: true)
      .snapshots()
      .map((snap) => snap.docs
          .where((doc) => doc.id != excludeId)
          .map((doc) {
            final d = doc.data();
            return PeerUser(
              id:          d['id']          as String,
              username:    d['username']    as String,
              isAvailable: d['isAvailable'] as bool? ?? false,
            );
          })
          .toList());
}
}