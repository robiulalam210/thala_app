import 'package:flutter/material.dart';

import '../models/diet_tip_model.dart';

class DietTipDetailScreen extends StatelessWidget {
  final DietTip tip;

  const DietTipDetailScreen({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('বিস্তারিত')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(tip.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
          const SizedBox(height: 16),
          Text(
            tip.content,
            style: TextStyle(fontSize: 14.5, height: 1.7, color: theme.colorScheme.onSurface.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }
}
