import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'health/health_calculator_cubit/health_calculator_cubit.dart';
import 'health/health_calculator_screen.dart';
import 'health/repository/health_calculator_repository.dart';

void main() {
  runApp(const ThalaApp());
}

class ThalaApp extends StatelessWidget {
  const ThalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'থালা',
      home: BlocProvider(
        create: (_) => HealthCalculatorCubit(
          HealthCalculatorRepositoryImpl(),
        ),
        child: const HealthCalculatorScreen(),
      ),
    );
  }
}