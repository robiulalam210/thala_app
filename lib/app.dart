import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/locale/locale_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/onboarding/repository/onboarding_repository.dart';
import 'features/onboarding/screens/onboarding_flow_screen.dart';

class ThalaApp extends StatelessWidget {
  const ThalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()..loadSaved()),
        BlocProvider(create: (_) => ThemeCubit()..loadSaved()),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeCubit>().state;

          return MaterialApp(
            title: 'থালা',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: const _StartupGate(),
          );
        },
      ),
    );
  }
}

/// App khola matroi ek-bar check kore — onboarding age complete hoyeche naki
class _StartupGate extends StatefulWidget {
  const _StartupGate();

  @override
  State<_StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<_StartupGate> {
  final _repository = OnboardingRepository();
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _repository.isComplete().then((value) {
      if (mounted) setState(() => _onboardingComplete = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingComplete == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _onboardingComplete! ? const DashboardScreen() : const OnboardingFlowScreen();
  }
}
