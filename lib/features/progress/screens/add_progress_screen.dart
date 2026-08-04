import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/progress_cubit.dart';
import '../models/progress_entry_model.dart';

class AddProgressScreen extends StatefulWidget {
  const AddProgressScreen({super.key});

  @override
  State<AddProgressScreen> createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  DateTime _date = DateTime.now();
  final _weightController = TextEditingController();
  final _targetController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();
  final _armController = TextEditingController();
  final _thighController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _weightController,
      _targetController,
      _chestController,
      _waistController,
      _hipController,
      _armController,
      _thighController,
      _noteController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _onSave() async {
    final weight = double.tryParse(_weightController.text.trim());
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('বর্তমান ওজন সঠিকভাবে দিন')));
      return;
    }

    final entry = ProgressEntry(
      date: _date,
      currentWeightKg: weight,
      targetWeightKg: double.tryParse(_targetController.text.trim()),
      chestCm: double.tryParse(_chestController.text.trim()),
      waistCm: double.tryParse(_waistController.text.trim()),
      hipCm: double.tryParse(_hipController.text.trim()),
      armCm: double.tryParse(_armController.text.trim()),
      thighCm: double.tryParse(_thighController.text.trim()),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    await context.read<ProgressCubit>().addEntry(entry);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('অগ্রগতি যোগ করুন')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('তারিখ', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      Text('${_date.day}/${_date.month}/${_date.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.edit, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionLabel('ওজন'),
          _field(_weightController, 'বর্তমান ওজন (কেজি)', Icons.monitor_weight_outlined, required: true),
          const SizedBox(height: 10),
          _field(_targetController, 'লক্ষ্য ওজন (কেজি) (ঐচ্ছিক)', Icons.flag_outlined),
          const SizedBox(height: 20),
          _sectionLabel('শরীরের মাপ (সব ঐচ্ছিক)'),
          _field(_chestController, 'বুক (সেমি)', Icons.accessibility_new),
          const SizedBox(height: 10),
          _field(_waistController, 'কোমর (সেমি)', Icons.accessibility_new),
          const SizedBox(height: 10),
          _field(_hipController, 'নিতম্ব (সেমি)', Icons.accessibility_new),
          const SizedBox(height: 10),
          _field(_armController, 'বাহু (সেমি)', Icons.fitness_center),
          const SizedBox(height: 10),
          _field(_thighController, 'উরু (সেমি)', Icons.fitness_center),
          const SizedBox(height: 20),
          _sectionLabel('নোট (ঐচ্ছিক)'),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(hintText: 'এখানে আপনার নোট লিখুন...'),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(onPressed: _onSave, child: const Text('অগ্রগতি সংরক্ষণ করুন', style: TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      );

  Widget _field(TextEditingController controller, String hint, IconData icon, {bool required = false}) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
      ),
    );
  }
}
