import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/workout_program_cubit.dart';
import '../widgets/workout_program_card_widget.dart';

class WorkoutProgramsTab extends StatelessWidget {
  const WorkoutProgramsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutProgramCubit, WorkoutProgramState>(
      builder: (context, state) {
        if (state is WorkoutProgramLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is WorkoutProgramError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.white70)));
        }

        final programs = (state as WorkoutProgramLoaded).programs;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: programs.map((program) => WorkoutProgramCardWidget(program: program)).toList(),
        );
      },
    );
  }
}
