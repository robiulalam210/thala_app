import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../onboarding/repository/onboarding_repository.dart';
import '../cubit/health_calculator_cubit.dart';
import '../cubit/health_calculator_state.dart';
import '../models/health_calculator_input.dart';
import 'health_calculator_result_screen.dart';

class HealthCalculatorScreen extends StatefulWidget {
  const HealthCalculatorScreen({super.key});

  @override
  State<HealthCalculatorScreen> createState() => _HealthCalculatorScreenState();
}

class _HealthCalculatorScreenState extends State<HealthCalculatorScreen> {
  final _ageController = TextEditingController();
  final _heightFeetController = TextEditingController();
  final _heightInchController = TextEditingController();
  final _weightController = TextEditingController();
  Gender _selectedGender = Gender.male;

  bool _isPrefilling = true;

  @override
  void initState() {
    super.initState();
    _prefillFromOnboardingProfile();
  }

  /// Onboarding-e already dewa tottho thakle, sheta diye field gulo
  /// auto-fill kore dei — user chaile pore edit korte parbe.
  ///
  /// NOTE: `OnboardingRepository().loadProfile()` ekta assumption —
  /// tomar actual repository-r method name ta match na korle eikhane
  /// update kore dio.
  Future<void> _prefillFromOnboardingProfile() async {
    try {
      final profile = await OnboardingRepository().loadProfile();

      if (profile != null && mounted) {
        _ageController.text = profile.age.toString();
        _weightController.text = profile.weightKg % 1 == 0
            ? profile.weightKg.toInt().toString()
            : profile.weightKg.toString();

        final totalInches = profile.heightCm / 2.54;
        final feet = totalInches ~/ 12;
        final inches = (totalInches - feet * 12).round();
        _heightFeetController.text = feet.toString();
        _heightInchController.text = inches.toString();

        // Onboarding-er Gender enum ei screen-er Gender enum theke
        // alada type hote pare, tai `.name` diye safely map kora holo.
        _selectedGender =
        profile.gender.name == 'female' ? Gender.female : Gender.male;
      }
    } catch (_) {
      // Kono saved profile na thakle ba load fail korle,
      // user just khali field diye normally continue korbe.
    } finally {
      if (mounted) setState(() => _isPrefilling = false);
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightFeetController.dispose();
    _heightInchController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onCalculatePressed() {
    final age = int.tryParse(_ageController.text.trim());
    final feet = int.tryParse(_heightFeetController.text.trim());
    final inches = double.tryParse(_heightInchController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    if (age == null || feet == null || inches == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সব তথ্য সঠিকভাবে পূরণ করুন')),
      );
      return;
    }

    final input = HealthCalculatorInput(
      age: age,
      heightFeet: feet,
      heightInches: inches,
      weightKg: weight,
      gender: _selectedGender,
    );

    context.read<HealthCalculatorCubit>().calculate(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('স্বাস্থ্য ক্যালকুলেটর')),
      body: BlocConsumer<HealthCalculatorCubit, HealthCalculatorState>(
        listener: (context, state) {
          if (state is HealthCalculatorLoaded) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<HealthCalculatorCubit>(),
                  child: const HealthCalculatorResultScreen(),
                ),
              ),
            );
          } else if (state is HealthCalculatorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is HealthCalculatorLoading;

          if (_isPrefilling) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('বয়স'),
                _buildTextField(_ageController, 'বছর', TextInputType.number),
                const SizedBox(height: 16),
                _buildLabel('উচ্চতা'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_heightFeetController, 'ফুট', TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        _heightInchController,
                        'ইঞ্চি',
                        const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('ওজন (kg)'),
                _buildTextField(_weightController, 'কেজি', const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: 16),
                _buildLabel('লিঙ্গ'),
                Row(
                  children: [
                    Expanded(child: _buildGenderCard(Gender.male, 'পুরুষ', Icons.male)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildGenderCard(Gender.female, 'মহিলা', Icons.female)),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _onCalculatePressed,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                    )
                        : const Text('গণনা করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
  );

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      TextInputType keyboardType,
      ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black87, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenderCard(Gender gender, String label, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}