import 'package:flutter/material.dart';

class DashboardFeature {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const DashboardFeature({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    this.onTap,
    this.isComingSoon = false,
  });
}

class DashboardStat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
