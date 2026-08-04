import 'package:flutter/material.dart';

import '../models/exercise_model.dart';

class DifficultyBadge extends StatelessWidget {
  final ExerciseDifficulty difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: difficulty.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: difficulty.color, width: 1),
      ),
      child: Text(
        difficulty.label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: difficulty.color),
      ),
    );
  }
}
