import 'package:flutter/material.dart';
import '../../model/podcast.dart';
import '../../service/podcast_service.dart';

/// Bottom sheet shown when a user taps a locked premium podcast.
/// Simulates a payment flow. Wire up Razorpay/Stripe SDK in _pay().
/// Returns true if unlock was successful.
class PodcastUnlockSheet extends StatefulWidget {
  final Podcast podcast;
  const PodcastUnlockSheet({super.key, required this.podcast});

  @override
  State<PodcastUnlockSheet> createState() => _PodcastUnlockSheetState();
}

class _PodcastUnlockSheetState extends State<PodcastUnlockSheet> {
  static const Color _brandGreen = Color(0xFF4A6741);
  static const Color _gold = Color(0xFFFFB300);

  bool _isPaying = false;
  String? _error;

  Future<void> _pay() async {
    setState(() { _isPaying = true; _error = null; });

    try {
      // ── TODO: Replace this block with actual Razorpay / Stripe SDK call ──
      // Example Razorpay integration:
      //
      // var options = {
      //   'key': 'YOUR_RAZORPAY_KEY',
      //   'amount': (widget.podcast.price * 100).toInt(), // paise
      //   'name': 'SupportHive',
      //   'description': widget.podcast.title,
      //   'prefill': {'contact': '', 'email': ''},
      // };
      // _razorpay.open(options);
      //
      // For now, simulate a 1.5s payment delay:
      await Future.delayed(const Duration(milliseconds: 1500));
      const simulatedPaymentId = 'pay_simulated_001';
      // ─────────────────────────────────────────────────────────────────────

      await PodcastService.instance.unlockPodcast(
          widget.podcast.id, simulatedPaymentId);

      if (mounted) Navigator.pop(context, true); // true = unlocked
    } catch (e) {
      setState(() {
        _isPaying = false;
        _error = 'Payment failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.podcast;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────────────────────────────────────────────
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // ── Lock icon ─────────────────────────────────────────────────────
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold.withOpacity(0.4), width: 2),
            ),
            child:
                const Icon(Icons.lock_rounded, color: _gold, size: 34),
          ),
          const SizedBox(height: 16),

          // ── Podcast info ──────────────────────────────────────────────────
          Text(p.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('by ${p.author}',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 20),

          // ── What you get ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What you\'ll get:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 10),
                _benefit(Icons.play_circle_rounded,
                    'Full episode — ${p.duration}'),
                _benefit(Icons.download_rounded, 'Offline listening'),
                _benefit(Icons.replay_rounded, 'Unlimited replays'),
                _benefit(Icons.headset_rounded, 'Expert wellness content'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Error ─────────────────────────────────────────────────────────
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_error!,
                  style: TextStyle(
                      color: Colors.red.shade600, fontSize: 13)),
            ),

          // ── Pay button ────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isPaying ? null : _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandGreen,
                disabledBackgroundColor: _brandGreen.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
              child: _isPaying
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : Text(
                      p.price > 0
                          ? 'Unlock for ₹${p.price.toStringAsFixed(0)}'
                          : 'Unlock Free',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),

          // ── Cancel ────────────────────────────────────────────────────────
          TextButton(
            onPressed:
                _isPaying ? null : () => Navigator.pop(context, false),
            child: const Text('Maybe later',
                style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _benefit(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: _brandGreen, size: 18),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}