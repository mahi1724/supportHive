import 'package:flutter/material.dart';
import 'package:supporthive1/view/notes_screen.dart';
// import 'package:supporthive1/view/home_screen.dart';
import 'package:supporthive1/view/quiz.dart';

class QuizJournalSection extends StatelessWidget {
  final VoidCallback onOpenDiary;
  final VoidCallback onTakeQuiz;
  final VoidCallback onCheckStatus;

  const QuizJournalSection({
    super.key,
    required this.onOpenDiary,
    required this.onTakeQuiz,
    required this.onCheckStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade100, Colors.cyan.shade200],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: Colors.teal.shade700),
              const SizedBox(width: 8),
              const Text(
                'Quiz & Journal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.book,
            title: 'Daily Diary',
            subtitle: 'Record your thoughts and feelings',
            buttonText: 'Open Diary',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotesScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.quiz,
            title: 'Wellness Quiz',
            subtitle: 'Assess your mental health today',
            buttonText: 'Take Quiz',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WellnessQuizScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6741),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Check Wellness Status',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF4A6741),
            radius: 24,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6741),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
