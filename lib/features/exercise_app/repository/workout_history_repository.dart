import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/workout_history_entry_model.dart';

class WorkoutHistoryRepository {
  static const _key = 'thala_workout_history';

  Future<List<WorkoutHistoryEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    final entries = list.map((e) => WorkoutHistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
    entries.sort((a, b) => b.completedAt.compareTo(a.completedAt)); // newest first
    return entries;
  }

  Future<void> addEntry(WorkoutHistoryEntry entry) async {
    final entries = await getEntries();
    entries.insert(0, entry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(entries.map((e) => e.toJson()).toList()));
  }
}
