import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/locale/app_strings.dart';
import '../../../core/locale/locale_cubit.dart';
import '../../../features/settings/widgets/settings_sheet.dart';
import '../../health_calculator/cubit/health_calculator_cubit.dart';
import '../../health_calculator/repository/health_calculator_repository.dart';
import '../../health_calculator/screens/health_calculator_screen.dart';
import '../../meal_planner/cubit/meal_plan_cubit.dart';
import '../../meal_planner/repository/meal_plan_repository.dart';
import '../../meal_planner/screens/meal_plan_list_screen.dart';
import '../../exercise_app/screens/exercise_home_screen.dart';
import '../models/dashboard_feature_model.dart';
import '../widgets/dashboard_feature_card.dart';
import '../widgets/dashboard_stat_chip.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ভবিষ্যতে নতুন মডিউল যোগ করতে শুধু এখানে একটা DashboardFeature entry বাড়ালেই হবে
  List<DashboardFeature> _buildFeatures(BuildContext context, String Function(String) t) {
    return [
      DashboardFeature(
        id: 'health_calculator',
        title: t('feature_health_calculator'),
        subtitle: t('feature_health_calculator_sub'),
        icon: Icons.monitor_weight_outlined,
        gradientColors: const [Color(0xFF6E9EEB), Color(0xFF4A5FD1)],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => HealthCalculatorCubit(HealthCalculatorRepositoryImpl()),
              child: const HealthCalculatorScreen(),
            ),
          ),
        ),
      ),
      DashboardFeature(
        id: 'meal_planner',
        title: t('feature_meal_planner'),
        subtitle: t('feature_meal_planner_sub'),
        icon: Icons.restaurant_menu,
        gradientColors: const [Color(0xFF3FBF8F), Color(0xFF1E9E76)],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => MealPlanCubit(MealPlanRepositoryImpl())..loadRecipes(),
              child: const MealPlanListScreen(),
            ),
          ),
        ),
      ),
      DashboardFeature(
        id: 'exercise',
        title: t('feature_exercise'),
        subtitle: t('feature_exercise_sub'),
        icon: Icons.fitness_center,
        gradientColors: const [Color(0xFFF2994A), Color(0xFFEB5757)],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ExerciseHomeScreen()),
        ),
      ),
      DashboardFeature(
        id: 'coming_soon',
        title: t('feature_more'),
        subtitle: t('feature_more_sub'),
        icon: Icons.auto_awesome_outlined,
        gradientColors: const [Colors.transparent, Colors.transparent],
        isComingSoon: true,
      ),
    ];
  }

  List<DashboardStat> _stats(String Function(String) t) => [
        DashboardStat(label: t('stat_calories'), value: '১৮৪০', icon: Icons.local_fire_department, color: const Color(0xFFF2994A)),
        DashboardStat(label: t('stat_water'), value: '১.৮', icon: Icons.water_drop_outlined, color: const Color(0xFF56CCF2)),
        DashboardStat(label: t('stat_workout'), value: '৩', icon: Icons.fitness_center, color: const Color(0xFF6FCF97)),
      ];

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LocaleCubit>().state;
    String t(String key) => AppStrings.get(key, language);
    final features = _buildFeatures(context, t);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(context, t),
            const SizedBox(height: 24),
            Row(
              children: [
                for (int i = 0; i < _stats(t).length; i++) ...[
                  DashboardStatChip(stat: _stats(t)[i]),
                  if (i != _stats(t).length - 1) const SizedBox(width: 12),
                ],
              ],
            ),
            const SizedBox(height: 28),
            Text(
              t('features'),
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) => DashboardFeatureCard(feature: features[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String Function(String) t) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6E9EEB), Color(0xFF4A5FD1)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('welcome_back'), style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 13)),
              const SizedBox(height: 2),
              Text(
                t('your_dashboard'),
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => SettingsSheet.show(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface.withOpacity(0.8), size: 22),
          ),
        ),
      ],
    );
  }
}
