import 'package:flutter/material.dart';

import '../models/workout_program_model.dart';
import 'difficulty_badge.dart';

class WorkoutProgramCardWidget extends StatelessWidget {
  final WorkoutProgram program;
  final VoidCallback onUnlockTap;

  const WorkoutProgramCardWidget({
    super.key,
    required this.program,
    required this.onUnlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: program.isLocked ? 0.45 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        program.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    DifficultyBadge(difficulty: program.difficulty),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  program.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400, height: 1.4),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _metaItem(Icons.calendar_today_outlined, '${program.weeks} weeks'),
                    const SizedBox(width: 16),
                    _metaItem(Icons.fitness_center, '${program.daysPerWeek} days/week'),
                    const SizedBox(width: 16),
                    _metaItem(Icons.flag_outlined, program.goalTag),
                  ],
                ),
              ],
            ),
          ),
          if (program.isLocked)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onUnlockTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF2994A), Color(0xFFEB5757)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text('প্রিমিয়াম দিয়ে আনলক করুন', style: TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500)),
      ],
    );
  }
}
