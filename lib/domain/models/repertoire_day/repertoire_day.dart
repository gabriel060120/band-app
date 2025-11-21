class RepertoireDay {
  final String id;
  final DateTime date;
  final String title;
  final String observations;

  RepertoireDay({
    required this.id,
    required this.date,
    required this.title,
    required this.observations,
  });

  RepertoireDay copyWith({
    String? id,
    DateTime? date,
    String? title,
    List<String>? ciphers,
    String? observations,
  }) {
    return RepertoireDay(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      observations: observations ?? this.observations,
    );
  }

  factory RepertoireDay.fromMap(Map<String, dynamic> map) {
    return RepertoireDay(
      id: map['id'] as String,
      date: DateTime.parse(map['date']),
      title: map['title'] ?? '',
      observations: map['observations'] ?? '',
    );
  }
}
