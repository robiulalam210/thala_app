import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/locale/app_language.dart';
import '../../../core/locale/app_strings.dart';
import '../../../core/locale/locale_cubit.dart';
import '../../../core/theme/theme_cubit.dart';

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
          ],
        ),
      ),
    );
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
