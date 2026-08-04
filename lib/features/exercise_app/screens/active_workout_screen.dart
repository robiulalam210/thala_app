import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/workout_session_cubit.dart';
import '../cubit/workout_session_state.dart';
import '../models/exercise_model.dart';
import '../widgets/cancel_workout_dialog.dart';
import '../widgets/difficulty_badge.dart';

class ActiveWorkoutScreen extends StatelessWidget {
  final Exercise exercise;

  const ActiveWorkoutScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutSessionCubit(
        totalSets: exercise.defaultSets,
        restDurationSeconds: exercise.defaultRestSeconds,
      ),
      child: _ActiveWorkoutView(exercise: exercise),
    );
  }
}

class _ActiveWorkoutView extends StatelessWidget {
  final Exercise exercise;

  const _ActiveWorkoutView({required this.exercise});

  Future<void> _handleClose(BuildContext context) async {
    final cubit = context.read<WorkoutSessionCubit>();
    final shouldCancel = await CancelWorkoutDialog.show(context);
    if (shouldCancel == true) {
      cubit.cancelWorkout();
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutSessionCubit, WorkoutSessionState>(
      listener: (context, state) {
        if (state.isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ওয়ার্কআউট সম্পন্ন হয়েছে! 💪')),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0E0E11),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E11),
            elevation: 0,
            title: Text(exercise.name, style: const TextStyle(fontSize: 17)),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _handleClose(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildElapsedTimerChip(state.elapsedSeconds),
              const SizedBox(height: 16),
              _buildHeaderCard(context),
              const SizedBox(height: 20),
              _buildSetProgressBar(state),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Set ${state.currentSetNumber.clamp(1, state.totalSets)} / ${state.totalSets}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              if (state.phase == SessionPhase.addingSet)
                _AddSetCard(setNumber: state.currentSetNumber)
              else
                _RestTimerCard(
                  remainingSeconds: state.restRemainingSeconds,
                  totalSeconds: state.restDurationSeconds,
                ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.read<WorkoutSessionCubit>().completeWorkoutNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Complete Workout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildElapsedTimerChip(int elapsedSeconds) {
    final minutes = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF27AE60),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('$minutes:$seconds', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.fitness_center, size: 40, color: Colors.black38)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    DifficultyBadge(difficulty: exercise.difficulty),
                  ],
                ),
                const SizedBox(height: 8),
                Text(exercise.description, style: TextStyle(fontSize: 13.5, color: Colors.grey.shade300, height: 1.4)),
                const SizedBox(height: 8),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    title: const Text('How to perform', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    iconColor: Colors.white70,
                    collapsedIconColor: Colors.white70,
                    children: List.generate(exercise.instructions.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: const Color(0xFF2D5C8C),
                              child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                exercise.instructions[index],
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade300, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetProgressBar(WorkoutSessionState state) {
    return Row(
      children: List.generate(state.totalSets, (index) {
        final setNum = index + 1;
        Color color;
        if (setNum < state.currentSetNumber) {
          color = const Color(0xFF6FCF97); // completed
        } else if (setNum == state.currentSetNumber) {
          color = const Color(0xFF56CCF2); // current
        } else {
          color = Colors.grey.shade700; // upcoming
        }
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: setNum == state.totalSets ? 0 : 6),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
        );
      }),
    );
  }
}

class _AddSetCard extends StatefulWidget {
  final int setNumber;

  const _AddSetCard({required this.setNumber});

  @override
  State<_AddSetCard> createState() => _AddSetCardState();
}

class _AddSetCardState extends State<_AddSetCard> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onAddSet() {
    final reps = int.tryParse(_repsController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    if (reps == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reps ও Weight সঠিকভাবে দিন')),
      );
      return;
    }

    context.read<WorkoutSessionCubit>().addSet(reps: reps, weight: weight);
    _repsController.clear();
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add New Set', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildField(_repsController, 'Reps')),
              const SizedBox(width: 12),
              Expanded(child: _buildField(_weightController, 'Weight (kg)')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _onAddSet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D9CDB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: Text('Add Set ${widget.setNumber}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: const Color(0xFF0E0E11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

class _RestTimerCard extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const _RestTimerCard({required this.remainingSeconds, required this.totalSeconds});

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    final progress = totalSeconds == 0 ? 0.0 : remainingSeconds / totalSeconds;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Rest Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0, 1),
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade800,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFF2C94C)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$minutes:$seconds', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF2C94C))),
                    Text('remaining', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.read<WorkoutSessionCubit>().skipRest(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              side: BorderSide(color: Colors.grey.shade600),
            ),
            icon: const Icon(Icons.skip_next, size: 18, color: Color(0xFF56CCF2)),
            label: const Text('Skip Rest', style: TextStyle(color: Color(0xFF56CCF2))),
          ),
        ],
      ),
    );
  }
}
