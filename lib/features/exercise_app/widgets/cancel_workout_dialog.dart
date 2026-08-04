import 'package:flutter/material.dart';

class CancelWorkoutDialog extends StatelessWidget {
  const CancelWorkoutDialog({super.key});

  /// Returns true jodi user workout cancel korte chay, false/null hole continue
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const CancelWorkoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cancel Workout?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to cancel this workout? Your progress will not be saved.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade300, height: 1.4),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Continue Workout', style: TextStyle(color: Color(0xFF56CCF2))),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Cancel Workout', style: TextStyle(color: Color(0xFFEB5757))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
