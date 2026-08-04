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
      body: BlocBuilder<HealthCalculatorCubit, HealthCalculatorState>(
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
                  title: 'BMI রেজাল্ট',
                  child: _buildBmiSection(result),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'BMR + দৈনিক ক্যালরি চাহিদা',
                  child: _buildBmrTdeeSection(result),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'আদর্শ ওজন',
                  child: _buildIdealWeightSection(result),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'ডায়েট পরিকল্পনা',
                  child: _buildDietTipsSection(),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'আপনার জন্য কাস্টমাইজড টিপস',
                  child: Text(
                    result.bmiCategory.adviceBn,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'হেলথ স্কোর',
                  child: _buildHealthScoreSection(result),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBmiSection(HealthCalculatorResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          result.bmi.toStringAsFixed(2),
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BmiScaleWidget(bmi: result.bmi, category: result.bmiCategory),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.bmiCategory.adviceBn,
                  style: TextStyle(fontSize: 12.5, color: Colors.red.shade700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBmrTdeeSection(HealthCalculatorResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'বেস BMR: ${result.bmr.toStringAsFixed(2)} ক্যালরি/দিন',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 10),
        ...ActivityLevel.values.map((level) {
          final tdee = result.tdeeByActivity[level] ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(level.labelBn, style: const TextStyle(fontSize: 13)),
                Text(
                  tdee.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildIdealWeightSection(HealthCalculatorResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${result.idealWeightKg.toStringAsFixed(2)} কেজি',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'স্বাস্থ্যকর ওজন রেঞ্জ: ${result.idealWeightMinKg.toStringAsFixed(2)} - ${result.idealWeightMaxKg.toStringAsFixed(2)} কেজি',
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 4),
        const Text(
          'এই রেঞ্জ BMI ২০-২৫ এর ওপর ভিত্তি করে হিসাব করা হয়েছে।',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildHealthScoreSection(HealthCalculatorResult result) {
    // BMI 22.5 (normal range er moddhobindu) theke koto dure — tar upor base kore ekta simple 0-100 score
    final distanceFromIdeal = (result.bmi - 22.5).abs();
    final score = (100 - distanceFromIdeal * 6).clamp(0, 100).round();
    final scoreColor = score >= 80
        ? const Color(0xFF6FCF97)
        : score >= 50
            ? const Color(0xFFF2C94C)
            : const Color(0xFFEB5757);

    return Row(
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
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(scoreColor),
              ),
              Text('$score', style: TextStyle(fontWeight: FontWeight.bold, color: scoreColor)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'আপনার BMI ও বয়স বিবেচনা করে এই স্কোর তৈরি — এটা একটা প্রাথমিক ধারণা, চূড়ান্ত মেডিকেল মূল্যায়ন নয়।',
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4),
          ),
        ),
      ],
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

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
