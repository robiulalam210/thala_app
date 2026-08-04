import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/exercise_cubit.dart';
import '../cubit/workout_history_cubit.dart';
import '../repository/workout_history_repository.dart';
import '../cubit/workout_program_cubit.dart';
import '../repository/exercise_repository.dart';
import '../repository/workout_program_repository.dart';
import 'exercise_list_tab.dart';
import 'workout_history_tab.dart';
import 'workout_programs_tab.dart';

class ExerciseHomeScreen extends StatelessWidget {
  const ExerciseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExerciseCubit(ExerciseRepositoryImpl())..loadExercises()),
        BlocProvider(create: (_) => WorkoutProgramCubit(WorkoutProgramRepositoryImpl())..loadPrograms()),
        BlocProvider(create: (_) => WorkoutHistoryCubit(WorkoutHistoryRepository())..loadHistory()),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color(0xFF0E0E11),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E11),
            elevation: 0,
            title: const Text('ব্যায়াম'),
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Color(0xFF56CCF2),
              labelColor: Color(0xFF56CCF2),
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(icon: Icon(Icons.fitness_center), text: 'ব্যায়ামসমূহ'),
                Tab(icon: Icon(Icons.calendar_today_outlined), text: 'ওয়ার্কআউট প্রোগ্রাম'),
                Tab(icon: Icon(Icons.history), text: 'ওয়ার্কআউট ইতিহাস'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ExerciseListTab(),
              WorkoutProgramsTab(),
              WorkoutHistoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}
