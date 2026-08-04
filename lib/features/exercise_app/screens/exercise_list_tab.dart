import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/exercise_cubit.dart';
import '../cubit/exercise_state.dart';
import '../models/exercise_model.dart';
import '../widgets/exercise_card_widget.dart';
import 'exercise_detail_sheet.dart';

class ExerciseListTab extends StatelessWidget {
  const ExerciseListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ExerciseError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.white70)));
        }

        final loaded = state as ExerciseLoaded;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildFilterRow(context, loaded.selectedMuscleGroup),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: loaded.filteredExercises
                    .map(
                      (exercise) => ExerciseCardWidget(
                        exercise: exercise,
                        onTap: () => ExerciseDetailSheet.show(context, exercise),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterRow(BuildContext context, MuscleGroup? selected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(context, 'All', selected == null, () => context.read<ExerciseCubit>().filterByMuscleGroup(null)),
          const SizedBox(width: 8),
          ...MuscleGroup.values.map(
            (group) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _chip(
                context,
                group.label,
                selected == group,
                () => context.read<ExerciseCubit>().filterByMuscleGroup(group),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.white : Colors.grey.shade700),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
