import 'package:flutter/material.dart';

import '../models/exercise_model.dart';
import 'difficulty_badge.dart';

class ExerciseCardWidget extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCardWidget({super.key, required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        exercise.muscleGroup.label,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                DifficultyBadge(difficulty: exercise.difficulty),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              exercise.description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade300, height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _outlinedTag(exercise.category.label, Colors.grey.shade400, Colors.grey.shade700),
                const SizedBox(width: 8),
                _iconTag(Icons.timer_outlined, '~${exercise.estimatedMinutes}m', const Color(0xFF56CCF2)),
                const SizedBox(width: 8),
                _iconTag(Icons.local_fire_department, '${exercise.estimatedKcal} kcal', const Color(0xFFF2994A)),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.play_arrow, size: 16, color: Colors.blue.shade300),
                    const SizedBox(width: 2),
                    Text('Start', style: TextStyle(fontSize: 13, color: Colors.blue.shade300, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedTag(String text, Color textColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(text, style: TextStyle(fontSize: 11.5, color: textColor)),
    );
  }

  Widget _iconTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
