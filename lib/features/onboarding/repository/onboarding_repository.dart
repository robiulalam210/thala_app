import 'dart:convert';

import '../../../core/storage/local_preferences.dart';
import '../models/onboarding_models.dart';

class OnboardingRepository {
  Future<bool> isComplete() => LocalPreferences.isOnboardingComplete();

  Future<void> saveProfile(OnboardingProfile profile) async {
    await LocalPreferences.setProfileJson(jsonEncode(profile.toJson()));
    await LocalPreferences.setOnboardingComplete(true);
  }

  Future<OnboardingProfile?> loadProfile() async {
    final raw = await LocalPreferences.getProfileJson();
    if (raw == null) return null;
    return OnboardingProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// লগআউট — প্রোফাইল ও অনবোর্ডিং-সম্পন্ন ফ্ল্যাগ মুছে ফেলে, ইউজারকে আবার অনবোর্ডিং-এ ফেরত পাঠাতে
  Future<void> logout() => LocalPreferences.clearOnboardingData();
}
