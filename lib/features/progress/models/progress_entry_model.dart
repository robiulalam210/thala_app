class ProgressEntry {
  final DateTime date;
  final double currentWeightKg;
  final double? targetWeightKg;
  final double? chestCm;
  final double? waistCm;
  final double? hipCm;
  final double? armCm;
  final double? thighCm;
  final String? note;

  const ProgressEntry({
    required this.date,
    required this.currentWeightKg,
    this.targetWeightKg,
    this.chestCm,
    this.waistCm,
    this.hipCm,
    this.armCm,
    this.thighCm,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'currentWeightKg': currentWeightKg,
        'targetWeightKg': targetWeightKg,
        'chestCm': chestCm,
        'waistCm': waistCm,
        'hipCm': hipCm,
        'armCm': armCm,
        'thighCm': thighCm,
        'note': note,
      };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      date: DateTime.parse(json['date'] as String),
      currentWeightKg: (json['currentWeightKg'] as num).toDouble(),
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble(),
      chestCm: (json['chestCm'] as num?)?.toDouble(),
      waistCm: (json['waistCm'] as num?)?.toDouble(),
      hipCm: (json['hipCm'] as num?)?.toDouble(),
      armCm: (json['armCm'] as num?)?.toDouble(),
      thighCm: (json['thighCm'] as num?)?.toDouble(),
      note: json['note'] as String?,
    );
  }
}
