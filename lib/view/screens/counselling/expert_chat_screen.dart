import 'package:flutter/material.dart';
import 'package:supporthive1/model/expert_model.dart';

class ExpertChatScreen extends StatelessWidget {
  final Expert expert;

  const ExpertChatScreen({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expert.name)),
      body: const Center(
        child: Text("Start your session"),
      ),
    );
  }
}