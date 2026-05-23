import 'package:flutter/material.dart';
import 'package:supporthive1/model/expert_model.dart';
import 'expert_chat_screen.dart';
import 'booking_screen.dart';

class ExpertsScreen extends StatelessWidget {
  ExpertsScreen({super.key});

  final List<Expert> experts = [
    Expert(
      name: "Dr. Rajesh Kumar",
      specialization: "MD Psychiatry",
      rating: 4.8,
      isAvailable: true,
      price: 1200,
    ),
    Expert(
      name: "Dr. Priya Sharma",
      specialization: "Child Psychiatry",
      rating: 4.9,
      isAvailable: true,
      price: 1500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Experts")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: experts.map((e) => _card(context, e)).toList(),
      ),
    );
  }

  Widget _card(BuildContext context, Expert e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(e.specialization),
          Text("⭐ ${e.rating}"),

          const SizedBox(height: 10),

          Row(
            children: [

              // CHAT
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExpertChatScreen(expert: e),
                    ),
                  );
                },
                child: const Text("Chat"),
              ),

              const SizedBox(width: 8),

              // CALL
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(expert: e),
                    ),
                  );
                },
                child: const Text("Call"),
              ),

              const SizedBox(width: 8),

              // VIDEO
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(expert: e),
                    ),
                  );
                },
                child: const Text("Video"),
              ),

              const SizedBox(width: 8),

              // BOOK
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(expert: e),
                    ),
                  );
                },
                child: const Text("Book"),
              ),
            ],
          )
        ],
      ),
    );
  }
}