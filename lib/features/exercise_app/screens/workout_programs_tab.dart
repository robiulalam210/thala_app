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
        final hasLockedPrograms = programs.any((p) => p.isLocked);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...programs.take(1).map(
                  (program) => WorkoutProgramCardWidget(
                    program: program,
                    onUnlockTap: () {},
                  ),
                ),
            if (hasLockedPrograms) ...[
              _buildUnlockAllBanner(context),
              const SizedBox(height: 16),
            ],
            ...programs.skip(1).map(
                  (program) => WorkoutProgramCardWidget(
                    program: program,
                    onUnlockTap: () => _showUnlockPrompt(context, program.title),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _buildUnlockAllBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUnlockPrompt(context, 'সব ওয়ার্কআউট প্রোগ্রাম'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF2994A), Color(0xFFEB5757)]),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.fitness_center, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'সব ওয়ার্কআউট প্রোগ্রাম আনলক করুন',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'প্রতিটি অভিজ্ঞতার লেভেলের জন্য স্ট্যাকচার্ড প্রোগ্রাম',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showUnlockPrompt(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title আনলক করতে প্রিমিয়াম/পেমেন্ট ফ্লো এখানে বসবে')),
    );
  }
}
