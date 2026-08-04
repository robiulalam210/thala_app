import 'package:flutter/material.dart';

import '../models/workout_program_model.dart';
import 'difficulty_badge.dart';

class WorkoutProgramCardWidget extends StatelessWidget {
  final WorkoutProgram program;
  final VoidCallback? onTap;

  const WorkoutProgramCardWidget({super.key, required this.program, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    program.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                ),
                DifficultyBadge(difficulty: program.difficulty),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              program.description,
              style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.6), height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _metaItem(context, Icons.calendar_today_outlined, '${program.weeks} weeks'),
                const SizedBox(width: 16),
                _metaItem(context, Icons.fitness_center, '${program.daysPerWeek} days/week'),
                const SizedBox(width: 16),
                _metaItem(context, Icons.flag_outlined, program.goalTag),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaItem(BuildContext context, IconData icon, String text) {
    final color = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11.5, color: color)),
      ],
    );
  }
}
