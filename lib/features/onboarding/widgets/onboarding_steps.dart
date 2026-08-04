import 'package:flutter/material.dart';

import '../../../core/locale/app_language.dart';
import '../models/onboarding_models.dart';
import 'number_stepper_control.dart';
import 'segmented_toggle.dart';
import 'selectable_option_card.dart';

class LanguageStepBody extends StatelessWidget {
  final AppLanguage selected;
  final ValueChanged<AppLanguage> onChanged;

  const LanguageStepBody({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedToggle(
        leftLabel: 'বাংলা',
        rightLabel: 'English',
        isLeftSelected: selected == AppLanguage.bn,
        onChanged: (isLeft) => onChanged(isLeft ? AppLanguage.bn : AppLanguage.en),
      ),
    );
  }
}

class GoalStepBody extends StatelessWidget {
  final Goal? selected;
  final ValueChanged<Goal> onChanged;
  final Map<Goal, (String, String)> labels; // goal -> (title, subtitle)

  const GoalStepBody({super.key, required this.selected, required this.onChanged, required this.labels});

  static const _iconMap = {
    Goal.fatLoss: (Icons.local_fire_department, Color(0xFFEB5757)),
    Goal.muscleGain: (Icons.fitness_center, Color(0xFF56CCF2)),
    Goal.stayFit: (Icons.favorite, Color(0xFF6FCF97)),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Goal.values.map((goal) {
        final (icon, color) = _iconMap[goal]!;
        final (title, subtitle) = labels[goal]!;
        return SelectableOptionCard(
          icon: icon,
          iconColor: color,
          title: title,
          subtitle: subtitle,
          isSelected: selected == goal,
          onTap: () => onChanged(goal),
        );
      }).toList(),
    );
  }
}

class GenderStepBody extends StatelessWidget {
  final Gender selected;
  final ValueChanged<Gender> onChanged;
  final String maleLabel;
  final String femaleLabel;

  const GenderStepBody({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.maleLabel,
    required this.femaleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableOptionCard(
          icon: Icons.male,
          iconColor: const Color(0xFF56CCF2),
          title: maleLabel,
          subtitle: '',
          isSelected: selected == Gender.male,
          onTap: () => onChanged(Gender.male),
        ),
        SelectableOptionCard(
          icon: Icons.female,
          iconColor: const Color(0xFFEB5757),
          title: femaleLabel,
          subtitle: '',
          isSelected: selected == Gender.female,
          onTap: () => onChanged(Gender.female),
        ),
      ],
    );
  }
}

class ActivityStepBody extends StatelessWidget {
  final ActivityLevel? selected;
  final ValueChanged<ActivityLevel> onChanged;
  final Map<ActivityLevel, (String, String)> labels;

  const ActivityStepBody({super.key, required this.selected, required this.onChanged, required this.labels});

  static const _iconMap = {
    ActivityLevel.sedentary: (Icons.weekend, Color(0xFF828282)),
    ActivityLevel.light: (Icons.directions_walk, Color(0xFF56CCF2)),
    ActivityLevel.moderate: (Icons.directions_run, Color(0xFF6FCF97)),
    ActivityLevel.veryActive: (Icons.fitness_center, Color(0xFFF2994A)),
    ActivityLevel.extreme: (Icons.local_fire_department, Color(0xFFEB5757)),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ActivityLevel.values.map((level) {
        final (icon, color) = _iconMap[level]!;
        final (title, subtitle) = labels[level]!;
        return SelectableOptionCard(
          icon: icon,
          iconColor: color,
          title: title,
          subtitle: subtitle,
          isSelected: selected == level,
          onTap: () => onChanged(level),
        );
      }).toList(),
    );
  }
}

/// Age, weight, target weight — tinটাই ekই generic stepper, alada widget lagbe na
class SimpleStepperStepBody extends StatelessWidget {
  final num value;
  final String unitLabel;
  final num step;
  final num min;
  final num max;
  final ValueChanged<num> onChanged;

  const SimpleStepperStepBody({
    super.key,
    required this.value,
    required this.unitLabel,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max = 300,
  });

  @override
  Widget build(BuildContext context) {
    return NumberStepperControl(
      valueLabel: value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1),
      unitLabel: unitLabel,
      onIncrement: () => onChanged((value + step).clamp(min, max)),
      onDecrement: () => onChanged((value - step).clamp(min, max)),
    );
  }
}

class HeightStepBody extends StatelessWidget {
  final bool isCm;
  final double heightCm;
  final String cmLabel;
  final String ftInLabel;
  final String feetLabel;
  final String inchesLabel;
  final ValueChanged<bool> onUnitChanged;
  final ValueChanged<double> onHeightCmChanged;

  const HeightStepBody({
    super.key,
    required this.isCm,
    required this.heightCm,
    required this.cmLabel,
    required this.ftInLabel,
    required this.feetLabel,
    required this.inchesLabel,
    required this.onUnitChanged,
    required this.onHeightCmChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalInches = heightCm / 2.54;
    final feet = (totalInches ~/ 12);
    final inches = (totalInches - feet * 12).round();

    return Column(
      children: [
        Center(
          child: SegmentedToggle(
            leftLabel: cmLabel,
            rightLabel: ftInLabel,
            isLeftSelected: isCm,
            onChanged: onUnitChanged,
          ),
        ),
        const SizedBox(height: 28),
        if (isCm)
          SimpleStepperStepBody(
            value: heightCm,
            unitLabel: cmLabel,
            min: 90,
            max: 250,
            onChanged: (v) => onHeightCmChanged(v.toDouble()),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: NumberStepperControl(
                  valueLabel: '$feet',
                  unitLabel: feetLabel,
                  onIncrement: () => onHeightCmChanged(((feet + 1) * 12 + inches) * 2.54),
                  onDecrement: () => onHeightCmChanged(((feet - 1).clamp(2, 8) * 12 + inches) * 2.54),
                ),
              ),
              Expanded(
                child: NumberStepperControl(
                  valueLabel: '$inches',
                  unitLabel: inchesLabel,
                  onIncrement: () => onHeightCmChanged((feet * 12 + (inches + 1).clamp(0, 11)) * 2.54),
                  onDecrement: () => onHeightCmChanged((feet * 12 + (inches - 1).clamp(0, 11)) * 2.54),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
