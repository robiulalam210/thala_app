import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/locale/app_language.dart';
import '../../../core/locale/app_strings.dart';
import '../../../core/locale/locale_cubit.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../onboarding/repository/onboarding_repository.dart';
import '../../onboarding/screens/onboarding_flow_screen.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LocaleCubit>().state;
    final themeMode = context.watch<ThemeCubit>().state;
    final theme = Theme.of(context);

    String t(String key) => AppStrings.get(key, language);

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.90,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                t('settings'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                t('language'),
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(.6),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _optionTile(
                      context,
                      label: "বাংলা",
                      isSelected: language == AppLanguage.bn,
                      onTap: () {
                        context.read<LocaleCubit>().setLanguage(AppLanguage.bn);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _optionTile(
                      context,
                      label: "English",
                      isSelected: language == AppLanguage.en,
                      onTap: () {
                        context.read<LocaleCubit>().setLanguage(AppLanguage.en);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                t('theme'),
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(.6),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _optionTile(
                      context,
                      label: t('dark_mode'),
                      icon: Icons.dark_mode_outlined,
                      isSelected: themeMode == ThemeMode.dark,
                      onTap: () {
                        context
                            .read<ThemeCubit>()
                            .setThemeMode(ThemeMode.dark);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _optionTile(
                      context,
                      label: t('light_mode'),
                      icon: Icons.light_mode_outlined,
                      isSelected: themeMode == ThemeMode.light,
                      onTap: () {
                        context
                            .read<ThemeCubit>()
                            .setThemeMode(ThemeMode.light);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Divider(
                color: theme.colorScheme.onSurface.withOpacity(.1),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.storage_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "আপনার সব তথ্য শুধুমাত্র এই ডিভাইসে সংরক্ষিত থাকে। কোনো রিমোট সার্ভারে পাঠানো হয় না।",
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("লগআউট / ডেটা রিসেট করুন"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("লগআউট করবেন?"),
        content: const Text(
          "আপনার প্রোফাইল তথ্য (বয়স, ওজন, লক্ষ্য ইত্যাদি) মুছে যাবে এবং আবার অনবোর্ডিং শুরু হবে। অন্য ডেটা (প্রোগ্রেস লগ, ইতিহাস) থেকে যাবে।",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text("বাতিল"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text(
              "লগআউট করুন",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await OnboardingRepository().logout();

      if (context.mounted) {
        Navigator.pop(context);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingFlowScreen(),
          ),
              (_) => false,
        );
      }
    }
  }

  static Widget _optionTile(
      BuildContext context, {
        required String label,
        IconData? icon,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(.12)
              : theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}