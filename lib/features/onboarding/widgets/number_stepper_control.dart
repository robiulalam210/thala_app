import 'package:flutter/material.dart';

class NumberStepperControl extends StatelessWidget {
  final String valueLabel;
  final String unitLabel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const NumberStepperControl({
    super.key,
    required this.valueLabel,
    required this.unitLabel,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _roundButton(context, Icons.remove, onDecrement),
        SizedBox(
          width: 140,
          child: Column(
            children: [
              Text(
                valueLabel,
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
              Text(unitLabel, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.5))),
            ],
          ),
        ),
        _roundButton(context, Icons.add, onIncrement),
      ],
    );
  }

  Widget _roundButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: theme.colorScheme.surface,
        child: Icon(icon, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
