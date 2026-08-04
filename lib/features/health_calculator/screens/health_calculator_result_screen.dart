import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/health_calculator_cubit.dart';
import '../cubit/health_calculator_state.dart';
import '../models/health_calculator_input.dart';
import '../models/health_calculator_result.dart';
import '../widgets/bmi_scale_widget.dart';

class HealthCalculatorResultScreen extends StatelessWidget {
  const HealthCalculatorResultScreen({super.key});

  static const _dietTipsBn = [
    'সুস্থ ওজন কমাতে দৈনিক ক্যালরি চাহিদার চেয়ে কম ক্যালরি গ্রহণ করুন (ক্যালরি ডেফিসিট)।',
    'প্রক্রিয়াজাত খাবারের বদলে সবজি, ফল ও প্রোটিন সমৃদ্ধ খাবার বেছে নিন।',
    'অতিরিক্ত চিনি ও তেল-জাতীয় খাবার এড়িয়ে চলুন।',
    'পর্যাপ্ত পানি পান করুন এবং নিয়মিত হালকা ব্যায়াম করুন।',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ফলাফল')),
      body: SafeArea(
        child: BlocBuilder<HealthCalculatorCubit, HealthCalculatorState>(
          builder: (context, state) {
            if (state is! HealthCalculatorLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final result = state.result;
        
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard(
                    context,
                    title: 'আপনার বিএমআই',
                    child: _buildBmiSection(context, result),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'BMR + দৈনিক ক্যালরি চাহিদা',
                    child: _buildBmrTdeeSection(context, result),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'আদর্শ ওজন',
                    child: _buildIdealWeightSection(context, result),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'দৈনিক পানি পানের পরিমাণ',
                    child: _buildWaterIntakeSection(context, result),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'ম্যাক্রো ব্রেকডাউন',
                    child: _buildMacroBreakdownSection(context, result),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'ডায়েট পরিকল্পনা',
                    child: _buildDietTipsSection(),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'পার্সোনালাইজড হেলথ টিপস',
                    subtitle: 'আপনার BMI ক্যাটাগরি অনুযায়ী কাস্টমাইজড সুপারিশ পান',
                    child: _buildPersonalizedTipsSection(context, result),
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    context,
                    title: 'আপনার ব্যক্তিগত হেলথ স্কোর',
                    subtitle: 'বিস্তারিত মেট্রিক্স ও ঝুঁকি মূল্যায়ন সহ আপনার স্বাস্থ্য ট্র্যাক করুন',
                    child: _buildHealthScoreSection(context, result),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBmiSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          result.bmi.toStringAsFixed(2),
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        BmiScaleWidget(bmi: result.bmi, category: result.bmiCategory),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.error.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.bmiCategory.adviceBn,
                  style: TextStyle(fontSize: 12.5, color: colorScheme.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBmrTdeeSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'বেস BMR: ${result.bmr.toStringAsFixed(2)} ক্যালরি/দিন',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 10),
        ...ActivityLevel.values.map((level) {
          final tdee = result.tdeeByActivity[level] ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  level.labelBn,
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.75)),
                ),
                Text(
                  tdee.toStringAsFixed(2),
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildIdealWeightSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${result.idealWeightKg.toStringAsFixed(2)} কেজি',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 6),
        Text(
          'স্বাস্থ্যকর ওজন রেঞ্জ: ${result.idealWeightMinKg.toStringAsFixed(2)} - ${result.idealWeightMaxKg.toStringAsFixed(2)} কেজি',
          style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.85)),
        ),
        const SizedBox(height: 4),
        Text(
          'এই রেঞ্জ BMI ২০-২৫ এর ওপর ভিত্তি করে হিসাব করা হয়েছে।',
          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.55)),
        ),
      ],
    );
  }

  /// Ideal weight (kg) er upor base kore approximate daily water intake —
  /// standard rule of thumb: prottek kg body weight-er jonno ~33ml pani.
  Widget _buildWaterIntakeSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;
    final waterLiters = (result.idealWeightKg * 0.033);
    final glasses = (waterLiters * 1000 / 250).round(); // ~250ml/glass hisebe

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.water_drop_outlined, color: Colors.lightBlue, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${waterLiters.toStringAsFixed(1)} লিটার / দিন',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 2),
              Text(
                'প্রায় $glasses গ্লাস পানি (২৫০ মিলি প্রতি গ্লাস হিসেবে)',
                style: TextStyle(fontSize: 12.5, color: colorScheme.onSurface.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Moderate activity TDEE-ke base dhore standard 30/40/30 (protein/carb/fat)
  /// split e macro grams calculate kora hoyeche. Tumi chaile ei ratio
  /// nutrition guideline onujayi change korte paro.
  Widget _buildMacroBreakdownSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;

    final baseCalories = result.tdeeByActivity[ActivityLevel.moderate] ?? (result.bmr * 1.55);

    final proteinGrams = (baseCalories * 0.30) / 4;
    final carbGrams = (baseCalories * 0.40) / 4;
    final fatGrams = (baseCalories * 0.30) / 9;

    const proteinColor = Color(0xFF56CCF2);
    const carbColor = Color(0xFFF2C94C);
    const fatColor = Color(0xFFEB5757);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'দৈনিক ${baseCalories.toStringAsFixed(0)} ক্যালরি ভিত্তিতে (মাঝারি পরিশ্রম)',
          style: TextStyle(fontSize: 12.5, color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(flex: 30, child: Container(height: 10, color: proteinColor)),
              Expanded(flex: 40, child: Container(height: 10, color: carbColor)),
              Expanded(flex: 30, child: Container(height: 10, color: fatColor)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _macroRow(context, 'প্রোটিন', proteinGrams, proteinColor, '৩০%'),
        const SizedBox(height: 8),
        _macroRow(context, 'শর্করা (কার্বস)', carbGrams, carbColor, '৪০%'),
        const SizedBox(height: 8),
        _macroRow(context, 'ফ্যাট', fatGrams, fatColor, '৩০%'),
      ],
    );
  }

  Widget _macroRow(BuildContext context, String label, double grams, Color color, String percentLabel) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label ($percentLabel)',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.8)),
          ),
        ),
        Text(
          '${grams.toStringAsFixed(0)} গ্রাম',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
      ],
    );
  }

  /// Age-onujayi BMI-based advice ke ekta full "personalized tips" card hisebe
  /// dekhano hocche — shudhu BMI box-er text repeat na kore, extra calorie
  /// guidance o add kora holo jate eta duplicate na lage.
  Widget _buildPersonalizedTipsSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;
    final maintenanceCalories = result.tdeeByActivity[ActivityLevel.moderate] ?? (result.bmr * 1.55);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.auto_awesome, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                result.bmiCategory.adviceBn,
                style: TextStyle(fontSize: 13, height: 1.5, color: colorScheme.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ওজন বজায় রাখতে দৈনিক প্রয়োজন: ${maintenanceCalories.toStringAsFixed(0)} ক্যালরি',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'ওজন কমাতে চাইলে প্রায় ${(maintenanceCalories - 500).toStringAsFixed(0)} ক্যালরি, বাড়াতে চাইলে প্রায় ${(maintenanceCalories + 500).toStringAsFixed(0)} ক্যালরি গ্রহণ করুন।',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.65), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthScoreSection(BuildContext context, HealthCalculatorResult result) {
    final colorScheme = Theme.of(context).colorScheme;

    // BMI 22.5 (normal range er moddhobindu) theke koto dure — tar upor base kore ekta simple 0-100 score
    final distanceFromIdeal = (result.bmi - 22.5).abs();
    final score = (100 - distanceFromIdeal * 6).clamp(0, 100).round();
    final scoreColor = score >= 80
        ? const Color(0xFF6FCF97)
        : score >= 50
        ? const Color(0xFFF2C94C)
        : const Color(0xFFEB5757);
    final riskLabel = score >= 80
        ? 'কম ঝুঁকি'
        : score >= 50
        ? 'মাঝারি ঝুঁকি'
        : 'বেশি ঝুঁকি';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 6,
                    backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(scoreColor),
                  ),
                  Text('$score', style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      riskLabel,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: scoreColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'আপনার BMI বিবেচনা করে এই স্কোর তৈরি — এটা একটা প্রাথমিক ধারণা, চূড়ান্ত মেডিকেল মূল্যায়ন নয়।',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6), height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _metricRow(context, 'বর্তমান BMI', result.bmi.toStringAsFixed(2)),
              Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.08)),
              _metricRow(
                context,
                'আদর্শ BMI থেকে পার্থক্য',
                '${(result.bmi - 22.5).abs().toStringAsFixed(2)}',
              ),
              Divider(height: 1, color: colorScheme.onSurface.withOpacity(0.08)),
              _metricRow(
                context,
                'আদর্শ ওজন থেকে পার্থক্য',
                '${(result.idealWeightKg).toStringAsFixed(1)} কেজি (আদর্শ)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12.5, color: colorScheme.onSurface.withOpacity(0.7))),
          Text(value, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildDietTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _dietTipsBn
          .map(
            (tip) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(tip, style: const TextStyle(fontSize: 13, height: 1.4))),
            ],
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _sectionCard(BuildContext context, {required String title, String? subtitle, required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: colorScheme.shadow.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.55), height: 1.3),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}