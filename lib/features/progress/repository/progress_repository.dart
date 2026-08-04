import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/progress_entry_model.dart';

class ProgressRepository {
  static const _key = 'thala_progress_entries';

  Future<List<ProgressEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    final entries = list.map((e) => ProgressEntry.fromJson(e as Map<String, dynamic>)).toList();
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  Future<void> addEntry(ProgressEntry entry) async {
    final entries = await getEntries();
    entries.add(entry);
    await _save(entries);
  }

  Future<void> _save(List<ProgressEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
