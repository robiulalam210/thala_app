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
    final colorScheme = Theme.of(context).colorScheme;
    final track = colorScheme.onSurface.withOpacity(0.08);

    return SafeArea(
      child: Container(
        color: colorScheme.surface.withOpacity(0), // keeps parent background visible
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(totalSteps, (index) {
                        final isActive = index == stepIndex;
                        final isPast = index < stepIndex;
                        return Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            height: 5,
                            margin: EdgeInsets.only(
                              right: index == totalSteps - 1 ? 0 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: isActive || isPast ? colorScheme.primary : track,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (onSkip != null) ...[
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onSkip,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          skipLabel,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),
                      if (icon != null)
                        Center(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary.withOpacity(0.18),
                                  colorScheme.primary.withOpacity(0.06),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.18),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(icon, size: 34, color: colorScheme.primary),
                          ),
                        ),
                      if (title != null) ...[
                        SizedBox(height: icon != null ? 26 : 8),
                        Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                      if (subtitle != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.5),
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      body,
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 8),
                child: Row(
                  children: [
                    if (onBack != null) ...[
                      _BackButton(onTap: onBack!),
                      const SizedBox(width: 14),
                    ],
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: continueEnabled ? onContinue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            disabledBackgroundColor: colorScheme.primary.withOpacity(0.35),
                            foregroundColor: colorScheme.onPrimary,
                            elevation: continueEnabled ? 4 : 0,
                            shadowColor: colorScheme.primary.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            continueLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}