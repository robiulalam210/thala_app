import 'package:flutter/material.dart';

import '../models/exercise_model.dart';
import '../models/workout_history_entry_model.dart';
import '../widgets/difficulty_badge.dart';
import 'active_workout_screen.dart';

class ExerciseDetailSheet extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailSheet({super.key, required this.exercise});

  /// Workout complete hole WorkoutHistoryEntry return kore, na hole null
  static Future<WorkoutHistoryEntry?> show(BuildContext context, Exercise exercise) {
    return showModalBottomSheet<WorkoutHistoryEntry?>(
      context: context,
      backgroundColor: const Color(0xFF0E0E11),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ExerciseDetailSheet(exercise: exercise),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              exercise.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade600),
                  ),
                  child: Text(
                    exercise.muscleGroup.label.toUpperCase(),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade300, letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                DifficultyBadge(difficulty: exercise.difficulty),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(exercise.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade300, height: 1.5)),
            const SizedBox(height: 24),
            const Text('Instructions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            ...List.generate(exercise.instructions.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: const Color(0xFF2D5C8C),
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          exercise.instructions[index],
                          style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  // Sheet age pop na kore age workout push kori, result await kore tarpor
                  // sheet-ke shei result soho pop kori — caller (list tab) eta history te save korbe.
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ActiveWorkoutScreen(exercise: exercise)),
                  );
                  if (context.mounted) Navigator.of(context).pop(result);
                },
                icon: const Icon(Icons.play_arrow, color: Color(0xFF56CCF2)),
                label: const Text('ওয়ার্কআউট শুরু করুন', style: TextStyle(color: Color(0xFF56CCF2), fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        );
      },
    );
  }
}
