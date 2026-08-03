import 'package:flutter/material.dart';

import '../model/health_calculator_result.dart';


class BmiScaleWidget extends StatelessWidget {
  final double bmi;
  final BmiCategory category;

  const BmiScaleWidget({
    super.key,
    required this.bmi,
    required this.category,
  });

  // স্কেলের ভিজ্যুয়াল রেঞ্জ — এর বাইরে গেলে ক্ল্যাম্প হবে
  static const double _scaleMin = 15;
  static const double _scaleMax = 45;

  static const List<_BmiSegment> _segments = [
    _BmiSegment(category: BmiCategory.underweight, start: 15, end: 20, color: Color(0xFF5B9BD5)),
    _BmiSegment(category: BmiCategory.normal, start: 20, end: 25, color: Color(0xFF6FCF97)),
    _BmiSegment(category: BmiCategory.overweight, start: 25, end: 30, color: Color(0xFFF2C94C)),
    _BmiSegment(category: BmiCategory.obese, start: 30, end: 40, color: Color(0xFFEB8258)),
    _BmiSegment(category: BmiCategory.severelyObese, start: 40, end: 45, color: Color(0xFFEB5757)),
  ];

  @override
  Widget build(BuildContext context) {
    final clampedBmi = bmi.clamp(_scaleMin, _scaleMax);
    final markerFraction = (clampedBmi - _scaleMin) / (_scaleMax - _scaleMin);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              height: 44,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: _segments
                          .map(
                            (segment) => Expanded(
                          flex: ((segment.end - segment.start) * 10).round(),
                          child: Container(height: 14, color: segment.color),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  Positioned(
                    left: (markerFraction * width).clamp(0, width - 2) - 1,
                    top: 0,
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_drop_down, size: 22, color: Colors.black87),
                        Container(width: 2, height: 14, color: Colors.black87),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _segments.map((segment) {
            final isActive = segment.category == category;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: isActive ? Border.all(color: segment.color, width: 1.5) : null,
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  segment.category.labelBn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.black87 : Colors.black45,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BmiSegment {
  final BmiCategory category;
  final double start;
  final double end;
  final Color color;

  const _BmiSegment({
    required this.category,
    required this.start,
    required this.end,
    required this.color,
  });
}