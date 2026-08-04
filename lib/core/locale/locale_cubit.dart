import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/local_preferences.dart';
import 'app_language.dart';

class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit() : super(AppLanguage.bn);

  Future<void> loadSaved() async {
    final code = await LocalPreferences.getLanguage();
    if (code != null) {
      emit(AppLanguageX.fromCode(code));
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    emit(language);
    await LocalPreferences.setLanguage(language.code);
  }

  Future<void> toggle() async {
    final next = state == AppLanguage.bn ? AppLanguage.en : AppLanguage.bn;
    await setLanguage(next);
  }
}
