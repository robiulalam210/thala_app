import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/locale/app_strings.dart';
import '../../../core/locale/locale_cubit.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../cubit/onboarding_cubit.dart';
import '../models/onboarding_models.dart';
import '../repository/onboarding_repository.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/onboarding_steps.dart';

const int _kTotalSteps = 9;

class OnboardingFlowScreen extends StatelessWidget {
  const OnboardingFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(OnboardingRepository(), totalSteps: _kTotalSteps),
      child: const _OnboardingFlowView(),
    );
  }
}

class _OnboardingFlowView extends StatelessWidget {
  const _OnboardingFlowView();

  void _goToDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LocaleCubit>().state;
    String t(String key) => AppStrings.get(key, language);

    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.isComplete) _goToDashboard(context);
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final profile = state.profile;
        final isLastStep = state.stepIndex == state.totalSteps - 1;

        late final IconData? icon;
        late final String? title;
        late final String? subtitle;
        late final Widget body;
        bool canContinue = true;
        VoidCallback? onSkip = () => cubit.skipAll();

        switch (state.stepIndex) {
          case 0:
            icon = Icons.language;
            title = t('select_language');
            subtitle = t('select_language_sub');
            onSkip = null;
            body = LanguageStepBody(
              selected: language,
              onChanged: (lang) => context.read<LocaleCubit>().setLanguage(lang),
            );
            break;
          case 1:
            icon = Icons.waving_hand;
            title = t('welcome_title');
            subtitle = t('welcome_sub');
            body = const SizedBox.shrink();
            break;
          case 2:
            icon = Icons.flag;
            title = t('goal_title');
            subtitle = null;
            canContinue = profile.goal != null;
            body = GoalStepBody(
              selected: profile.goal,
              onChanged: (goal) => cubit.updateProfile((p) => p.copyWith(goal: goal)),
              labels: {
                Goal.fatLoss: (t('goal_fat_loss'), t('goal_fat_loss_sub')),
                Goal.muscleGain: (t('goal_muscle_gain'), t('goal_muscle_gain_sub')),
                Goal.stayFit: (t('goal_stay_fit'), t('goal_stay_fit_sub')),
              },
            );
            break;
          case 3:
            icon = Icons.person;
            title = t('gender_title');
            subtitle = t('gender_sub');
            body = GenderStepBody(
              selected: profile.gender,
              onChanged: (g) => cubit.updateProfile((p) => p.copyWith(gender: g)),
              maleLabel: t('male'),
              femaleLabel: t('female'),
            );
            break;
          case 4:
            icon = Icons.cake;
            title = t('age_title');
            subtitle = null;
            body = SimpleStepperStepBody(
              value: profile.age,
              unitLabel: t('years'),
              min: 10,
              max: 100,
              onChanged: (v) => cubit.updateProfile((p) => p.copyWith(age: v.toInt())),
            );
            break;
          case 5:
            icon = Icons.height;
            title = t('height_title');
            subtitle = null;
            body = _HeightStepWrapper(
              heightCm: profile.heightCm,
              cmLabel: t('cm'),
              ftInLabel: t('ft_in'),
              feetLabel: t('feet'),
              inchesLabel: t('inches'),
              onHeightCmChanged: (v) => cubit.updateProfile((p) => p.copyWith(heightCm: v)),
            );
            break;
          case 6:
            icon = Icons.monitor_weight_outlined;
            title = t('weight_title');
            subtitle = null;
            body = SimpleStepperStepBody(
              value: profile.weightKg,
              unitLabel: t('kg'),
              min: 20,
              max: 300,
              onChanged: (v) => cubit.updateProfile((p) => p.copyWith(weightKg: v.toDouble())),
            );
            break;
          case 7:
            icon = Icons.adjust;
            title = t('target_weight_title');
            subtitle = t('target_weight_sub');
            body = SimpleStepperStepBody(
              value: profile.targetWeightKg,
              unitLabel: t('kg'),
              min: 20,
              max: 300,
              onChanged: (v) => cubit.updateProfile((p) => p.copyWith(targetWeightKg: v.toDouble())),
            );
            break;
          case 8:
          default:
            icon = null;
            title = t('activity_title');
            subtitle = null;
            canContinue = profile.activityLevel != null;
            body = ActivityStepBody(
              selected: profile.activityLevel,
              onChanged: (level) => cubit.updateProfile((p) => p.copyWith(activityLevel: level)),
              labels: {
                ActivityLevel.sedentary: (t('activity_sedentary'), t('activity_sedentary_sub')),
                ActivityLevel.light: (t('activity_light'), t('activity_light_sub')),
                ActivityLevel.moderate: (t('activity_moderate'), t('activity_moderate_sub')),
                ActivityLevel.veryActive: (t('activity_very'), t('activity_very_sub')),
                ActivityLevel.extreme: (t('activity_extreme'), t('activity_extreme_sub')),
              },
            );
        }

        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: OnboardingScaffold(
              key: ValueKey(state.stepIndex),
              stepIndex: state.stepIndex,
              totalSteps: state.totalSteps,
              icon: icon,
              title: title,
              subtitle: subtitle,
              body: body,
              onSkip: onSkip,
              skipLabel: t('skip'),
              onBack: state.stepIndex > 0 ? cubit.previousStep : null,
              continueEnabled: canContinue,
              continueLabel: isLastStep
                  ? t('finish')
                  : (state.stepIndex == 1 ? t('get_started') : t('continue')),
              onContinue: isLastStep ? cubit.finish : cubit.nextStep,
            ),
          ),
        );
      },
    );
  }
}

/// Height step-ke cm/ft-in toggle state-ta local rakhar jonno choto wrapper
class _HeightStepWrapper extends StatefulWidget {
  final double heightCm;
  final String cmLabel;
  final String ftInLabel;
  final String feetLabel;
  final String inchesLabel;
  final ValueChanged<double> onHeightCmChanged;

  const _HeightStepWrapper({
    required this.heightCm,
    required this.cmLabel,
    required this.ftInLabel,
    required this.feetLabel,
    required this.inchesLabel,
    required this.onHeightCmChanged,
  });

  @override
  State<_HeightStepWrapper> createState() => _HeightStepWrapperState();
}

class _HeightStepWrapperState extends State<_HeightStepWrapper> {
  bool isCm = true;

  @override
  Widget build(BuildContext context) {
    return HeightStepBody(
      isCm: isCm,
      heightCm: widget.heightCm,
      cmLabel: widget.cmLabel,
      ftInLabel: widget.ftInLabel,
      feetLabel: widget.feetLabel,
      inchesLabel: widget.inchesLabel,
      onUnitChanged: (v) => setState(() => isCm = v),
      onHeightCmChanged: widget.onHeightCmChanged,
    );
  }
}
