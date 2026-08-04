import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  final int stepIndex;
  final int totalSteps;
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final Widget body;
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final String continueLabel;
  final String skipLabel;
  final bool continueEnabled;

  const OnboardingScaffold({
    super.key,
    required this.stepIndex,
    required this.totalSteps,
    this.icon,
    this.title,
    this.subtitle,
    required this.body,
    this.onBack,
    this.onContinue,
    this.onSkip,
    required this.continueLabel,
    required this.skipLabel,
    this.continueEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withOpacity(0.45);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(totalSteps, (index) {
                      final isActive = index == stepIndex;
                      final isPast = index < stepIndex;
                      return Expanded(
                        child: Container(
                          height: 6,
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: isActive || isPast ? theme.colorScheme.primary : muted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                if (onSkip != null) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onSkip,
                    child: Text(
                      skipLabel,
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    if (icon != null)
                      Center(
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 36, color: theme.colorScheme.primary),
                        ),
                      ),
                    if (title != null) ...[
                      const SizedBox(height: 28),
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                    if (subtitle != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: muted, height: 1.5),
                      ),
                    ],
                    const SizedBox(height: 28),
                    body,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 8),
              child: Row(
                children: [
                  if (onBack != null) ...[
                    GestureDetector(
                      onTap: onBack,
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: theme.colorScheme.surface,
                        child: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: continueEnabled ? onContinue : null,
                        child: Text(continueLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
