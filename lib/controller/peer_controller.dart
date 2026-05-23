import '../model/peer_user_model.dart';
import '../service/peer_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PeerController
//
// KEY CHANGES:
//   ✗ REMOVED  DateTime.now().millisecondsSinceEpoch as ID  — generated a new
//              ID every launch so chat rooms never matched between sessions
//   ✓ ADDED    PeerService.getOrCreateAnonymousUid()  — Firebase Auth gives a
//              stable UID that is the same every time the app opens on this
//              device, so both chat participants always compute the same room ID
//   ✓ CHANGED  initUser() is now async — must be awaited before using
//              currentUser.id anywhere
// ─────────────────────────────────────────────────────────────────────────────
class PeerController {
  final PeerService _service = PeerService();

  late PeerUser currentUser;
  List<PeerUser> availablePeers = [];

  // ── Initialise with a stable Firebase Auth UID ────────────────────────────
  Future<void> initUser() async {
    final uid = await _service.getOrCreateAnonymousUid();

    // Derive a short readable suffix from the UID (last 4 chars)
    final suffix = uid.length >= 4 ? uid.substring(uid.length - 4) : uid;

    currentUser = PeerUser(
      id:          uid,
      username:    '@user_$suffix',
      isAvailable: false,
    );

    // Always register/refresh presence in Firestore on launch
    await _service.registerUser(currentUser);
  }

  // ── Toggle peer availability in Firestore ─────────────────────────────────
  Future<void> toggleAvailability(bool value) async {
    currentUser.isAvailable = value;
    await _service.updateAvailability(currentUser.id, value);
  }

  // ── Fetch live peers from Firestore ───────────────────────────────────────
  Future<void> findPeers() async {
    availablePeers = await _service.getAvailablePeers(currentUser.id);
  }
}