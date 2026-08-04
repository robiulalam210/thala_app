import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  List<DashboardFeature> _buildFeatures(BuildContext context) {
    return [
      DashboardFeature(
        id: 'health_calculator',
        title: 'স্বাস্থ্য ক্যালকুলেটর',
        subtitle: 'BMI, BMR ও আদর্শ ওজন হিসাব করুন',
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
        title: 'খাবার পরিকল্পনাকারী',
        subtitle: 'রেসিপি খুঁজুন ও ডায়েট প্ল্যান দেখুন',
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
        title: 'ব্যায়াম',
        subtitle: 'ওয়ার্কআউট প্রোগ্রাম ও লাইভ সেশন',
        icon: Icons.fitness_center,
        gradientColors: const [Color(0xFFF2994A), Color(0xFFEB5757)],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ExerciseHomeScreen()),
        ),
      ),
      const DashboardFeature(
        id: 'coming_soon',
        title: 'আরও ফিচার',
        subtitle: 'শীঘ্রই আসছে',
        icon: Icons.auto_awesome_outlined,
        gradientColors: [Colors.transparent, Colors.transparent],
        isComingSoon: true,
      ),
    ];
  }

  List<DashboardStat> get _stats => const [
        DashboardStat(label: 'আজকের ক্যালরি', value: '১৮৪০', icon: Icons.local_fire_department, color: Color(0xFFF2994A)),
        DashboardStat(label: 'পানি (লিটার)', value: '১.৮', icon: Icons.water_drop_outlined, color: Color(0xFF56CCF2)),
        DashboardStat(label: 'ওয়ার্কআউট', value: '৩ দিন', icon: Icons.fitness_center, color: Color(0xFF6FCF97)),
      ];

  @override
  Widget build(BuildContext context) {
    final features = _buildFeatures(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E11),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Row(
              children: [
                for (int i = 0; i < _stats.length; i++) ...[
                  DashboardStatChip(stat: _stats[i]),
                  if (i != _stats.length - 1) const SizedBox(width: 12),
                ],
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'ফিচারসমূহ',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildHeader() {
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('স্বাগতম 👋', style: TextStyle(color: Colors.grey, fontSize: 13)),
              SizedBox(height: 2),
              Text('আপনার হেলথ ড্যাশবোর্ড', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_none, color: Colors.white70, size: 22),
        ),
      ],
    );
  }
}
