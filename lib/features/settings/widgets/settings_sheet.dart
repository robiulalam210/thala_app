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
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('settings'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(t('language'), style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.5))),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _optionTile(
                    context,
                    label: 'বাংলা',
                    isSelected: language == AppLanguage.bn,
                    onTap: () => context.read<LocaleCubit>().setLanguage(AppLanguage.bn),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _optionTile(
                    context,
                    label: 'English',
                    isSelected: language == AppLanguage.en,
                    onTap: () => context.read<LocaleCubit>().setLanguage(AppLanguage.en),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(t('theme'), style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.5))),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _optionTile(
                    context,
                    label: t('dark_mode'),
                    icon: Icons.dark_mode_outlined,
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () => context.read<ThemeCubit>().setThemeMode(ThemeMode.dark),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _optionTile(
                    context,
                    label: t('light_mode'),
                    icon: Icons.light_mode_outlined,
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () => context.read<ThemeCubit>().setThemeMode(ThemeMode.light),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.storage_outlined, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'আপনার সব তথ্য শুধু এই ডিভাইসে local ভাবে সংরক্ষিত থাকে — কোনো রিমোট সার্ভারে যায় না।',
                      style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurface.withOpacity(0.6), height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEB5757),
                  side: const BorderSide(color: Color(0xFFEB5757)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('লগআউট / ডেটা রিসেট করুন'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('লগআউট করবেন?'),
        content: const Text('আপনার প্রোফাইল তথ্য (বয়স, ওজন, লক্ষ্য ইত্যাদি) মুছে যাবে এবং আবার অনবোর্ডিং শুরু হবে। এই ডিভাইসের অন্য ডেটা (প্রোগ্রেস লগ, ওয়ার্কআউট ইতিহাস) থেকে যাবে।'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('বাতিল')),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('লগআউট করুন', style: TextStyle(color: Color(0xFFEB5757))),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await OnboardingRepository().logout();
      if (context.mounted) {
        Navigator.of(context).pop(); // close the settings sheet
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OnboardingFlowScreen()),
          (route) => false,
        );
      }
    }
  }

  Widget _optionTile(
    BuildContext context, {
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.12) : theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.transparent, width: 1.4),
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
