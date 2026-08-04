import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/workout_history_cubit.dart';

class WorkoutHistoryTab extends StatelessWidget {
  const WorkoutHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutHistoryCubit, WorkoutHistoryState>(
      builder: (context, state) {
        if (state is WorkoutHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = (state as WorkoutHistoryLoaded).entries;

        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 56, color: Colors.grey.shade600),
                const SizedBox(height: 20),
                Text(
                  'কোনো ওয়ার্কআউট ইতিহাস নেই',
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'ব্যায়াম শুরু করলে এখানে আপনার প্রোগ্রেস দেখা যাবে',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final minutes = (entry.durationSeconds / 60).ceil();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF56CCF2).withOpacity(0.15),
                    child: const Icon(Icons.check, size: 16, color: Color(0xFF56CCF2)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.exerciseName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                          '${entry.completedAt.day}/${entry.completedAt.month}/${entry.completedAt.year} · $minutes মিনিট',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  Text('${entry.totalSets} সেট', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
