import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/local_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  Future<void> loadSaved() async {
    final saved = await LocalPreferences.getThemeMode();
    if (saved == 'light') {
      emit(ThemeMode.light);
    } else if (saved == 'dark') {
      emit(ThemeMode.dark);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    await LocalPreferences.setThemeMode(mode == ThemeMode.light ? 'light' : 'dark');
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }
}
