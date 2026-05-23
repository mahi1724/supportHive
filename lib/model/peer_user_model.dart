// ─────────────────────────────────────────────────────────────────────────────
// PeerUser model
// ─────────────────────────────────────────────────────────────────────────────
class PeerUser {
  final String id;
  final String username;
  bool isAvailable;

  PeerUser({
    required this.id,
    required this.username,
    this.isAvailable = false,
  });
}