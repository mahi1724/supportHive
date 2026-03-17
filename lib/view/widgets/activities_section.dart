import 'package:flutter/material.dart';
import 'package:supporthive1/model/activity.dart';

class ActivitiesSection extends StatelessWidget {
  final List<Activity> activities;
  final Function(String) onStartActivity;

  const ActivitiesSection({
    super.key,
    required this.activities,
    required this.onStartActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            return Column(
              children: [
                if (index > 0) const Divider(height: 24),
                _buildActivityItem(activity),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF4A6741),
          radius: 24,
          child: Icon(activity.icon, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activity.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => onStartActivity(activity.title),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A6741),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(activity.buttonText),
        ),
      ],
    );
  }
}