import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/progress_cubit.dart';
import '../models/progress_entry_model.dart';
import '../repository/progress_repository.dart';
import 'add_progress_screen.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit(ProgressRepository())..loadEntries(),
      child: const _MyProgressView(),
    );
  }
}

class _MyProgressView extends StatelessWidget {
  const _MyProgressView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার অগ্রগতি'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProgressCubit>().loadEntries(),
          ),
        ],
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = (state as ProgressLoaded).entries;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatsCard(context, entries),
              const SizedBox(height: 16),
              if (entries.isNotEmpty) _buildTrendCard(context, entries),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('লগ তালিকা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  TextButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProgressCubit>(),
                            child: const AddProgressScreen(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('অগ্রগতি যোগ করুন'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'এখনো কোনো অগ্রগতি লগ করা হয়নি',
                      style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                    ),
                  ),
                )
              else
                ...entries.reversed.map((entry) => _EntryTile(entry: entry)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, List<ProgressEntry> entries) {
    final theme = Theme.of(context);
    final hasData = entries.isNotEmpty;
    final currentWeight = hasData ? entries.last.currentWeightKg : 0.0;
    final totalChange = hasData ? (entries.last.currentWeightKg - entries.first.currentWeightKg) : 0.0;
    final targetWeight = hasData ? entries.last.targetWeightKg : null;

    double? avgWeeklyChange;
    if (entries.length >= 2) {
      final daySpan = entries.last.date.difference(entries.first.date).inDays;
      if (daySpan > 0) avgWeeklyChange = totalChange / (daySpan / 7);
    }

    double goalProgress = 0;
    if (hasData && targetWeight != null && entries.first.currentWeightKg != targetWeight) {
      goalProgress = ((entries.first.currentWeightKg - currentWeight) / (entries.first.currentWeightKg - targetWeight))
          .clamp(0, 1)
          .toDouble();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('অগ্রগতি পরিসংখ্যান', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statItem(context, 'দিন ট্র্যাকিং', '${entries.length}', Icons.calendar_today_outlined)),
              Expanded(
                child: _statItem(
                  context,
                  'মোট ওজন পরিবর্তন',
                  '${totalChange >= 0 ? '+' : ''}${totalChange.toStringAsFixed(1)} কেজি',
                  Icons.show_chart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _statItem(
                  context,
                  'গড় সাপ্তাহিক পরিবর্তন',
                  avgWeeklyChange == null ? '-' : '${avgWeeklyChange.toStringAsFixed(2)} কেজি',
                  Icons.trending_flat,
                ),
              ),
              Expanded(child: _statItem(context, 'বর্তমান ওজন', hasData ? '${currentWeight.toStringAsFixed(1)} কেজি' : '-', Icons.monitor_weight_outlined)),
            ],
          ),
          if (targetWeight != null) ...[
            const SizedBox(height: 18),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('লক্ষ্য ওজন: ${targetWeight.toStringAsFixed(1)} কেজি', style: const TextStyle(fontSize: 13)),
                Text('${(goalProgress * 100).round()}%', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: goalProgress,
                minHeight: 8,
                backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 15, color: theme.colorScheme.onSurface.withOpacity(0.4)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10.5, color: theme.colorScheme.onSurface.withOpacity(0.5))),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  /// আগে এখানে "premium unlock" card ছিল — এখন সব ফ্রি, তাই সত্যিকারের ট্রেন্ড হিসাব করে সরাসরি দেখাচ্ছে
  Widget _buildTrendCard(BuildContext context, List<ProgressEntry> entries) {
    final theme = Theme.of(context);
    final recent = entries.length >= 2 ? entries.sublist(entries.length >= 4 ? entries.length - 4 : 0) : entries;
    final change = recent.length >= 2 ? recent.last.currentWeightKg - recent.first.currentWeightKg : 0.0;
    final trendLabel = change < -0.05
        ? 'ওজন কমার প্রবণতা'
        : change > 0.05
            ? 'ওজন বাড়ার প্রবণতা'
            : 'ওজন স্থিতিশীল';
    final trendColor = change < -0.05
        ? const Color(0xFF6FCF97)
        : change > 0.05
            ? const Color(0xFFEB5757)
            : const Color(0xFFF2C94C);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: trendColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.insights, color: trendColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trendLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  'সাম্প্রতিক লগ অনুযায়ী পরিবর্তন: ${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} কেজি',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.55)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  final ProgressEntry entry;

  const _EntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
            child: Icon(Icons.show_chart, size: 16, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.currentWeightKg.toStringAsFixed(1)} কেজি', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                  style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          if (entry.note != null && entry.note!.isNotEmpty)
            Icon(Icons.notes, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.35)),
        ],
      ),
    );
  }
}
