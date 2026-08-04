import 'package:flutter/material.dart';

import '../models/exercise_model.dart';

/// A redesigned card for displaying a single [Exercise] in a list.
///
/// Shows the muscle group as a colored icon chip, the exercise name,
/// a difficulty + category badge row, and quick stats (time, calories,
/// sets, rest) so users can scan a workout list at a glance.
class ExerciseCardWidget extends StatelessWidget {
  const ExerciseCardWidget({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final Exercise exercise;
  final VoidCallback onTap;

  static const _cardColor = Color(0xFF1B1B1F);
  static const _accent = Color(0xFF56CCF2);

  // Self-contained styling so this widget doesn't depend on the model
  // exposing color/icon metadata.
  static const Map<String, Color> _groupColors = {
    'chest': Color(0xFFEF6C6C),
    'back': Color(0xFF56CCF2),
    'shoulders': Color(0xFFF2C94C),
    'biceps': Color(0xFF9B51E0),
    'triceps': Color(0xFFBB6BD9),
    'legs': Color(0xFF6FCF97),
    'core': Color(0xFFF2994A),
  };

  static const Map<String, IconData> _groupIcons = {
    'chest': Icons.fitness_center,
    'back': Icons.accessibility_new,
    'shoulders': Icons.sports_gymnastics,
    'biceps': Icons.sports_martial_arts,
    'triceps': Icons.sports_martial_arts,
    'legs': Icons.directions_run,
    'core': Icons.self_improvement,
  };

  Color _colorFor(String key) => _groupColors[key] ?? _accent;
  IconData _iconFor(String key) => _groupIcons[key] ?? Icons.fitness_center;

  String _difficultyLabel(ExerciseDifficulty d) {
    switch (d) {
      case ExerciseDifficulty.beginner:
        return 'শিক্ষানবিস';
      case ExerciseDifficulty.intermediate:
        return 'মধ্যম';
      case ExerciseDifficulty.advanced:
        return 'উন্নত';
    }
  }

  Color _difficultyColor(ExerciseDifficulty d) {
    switch (d) {
      case ExerciseDifficulty.beginner:
        return const Color(0xFF6FCF97);
      case ExerciseDifficulty.intermediate:
        return const Color(0xFFF2C94C);
      case ExerciseDifficulty.advanced:
        return const Color(0xFFEB5757);
    }
  }

  String _categoryLabel(ExerciseCategory c) {
    switch (c) {
      case ExerciseCategory.compound:
        return 'কম্পাউন্ড';
      case ExerciseCategory.isolation:
        return 'আইসোলেশন';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupKey = exercise.muscleGroup.name;
    final groupColor = _colorFor(groupKey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: groupColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_iconFor(groupKey), color: groupColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _badge(exercise.muscleGroup.label, groupColor),
                          _badge(
                            _difficultyLabel(exercise.difficulty),
                            _difficultyColor(exercise.difficulty),
                          ),
                          _badge(
                            _categoryLabel(exercise.category),
                            Colors.grey.shade500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _stat(Icons.timer_outlined, '${exercise.estimatedMinutes} মিনিট'),
                          const SizedBox(width: 14),
                          _stat(Icons.local_fire_department_outlined, '${exercise.estimatedKcal} kcal'),
                          const SizedBox(width: 14),
                          _stat(Icons.repeat, '${exercise.defaultSets} সেট'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}