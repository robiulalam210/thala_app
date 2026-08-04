import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

class ThalaApp extends StatelessWidget {
  const ThalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'থালা',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const DashboardScreen(),
    );
  }
}
