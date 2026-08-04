import 'package:flutter/material.dart';

import '../models/dashboard_feature_model.dart';

class DashboardStatChip extends StatelessWidget {
  final DashboardStat stat;

  const DashboardStatChip({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1F),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stat.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(stat.icon, size: 16, color: stat.color),
            ),
            const SizedBox(height: 8),
            Text(
              stat.value,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              stat.label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}
