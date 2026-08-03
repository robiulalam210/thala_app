import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'health_calculator_cubit/health_calculator_cubit.dart';
import 'health_calculator_result_screen.dart';
import 'model/health_calculator_input.dart';

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
      decoration: InputDecoration(
        hintText: hint,
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