import 'package:band_app/domain/models/lyrics/lyrics.dart';

class RepertoireDay {
  final String id;
  final DateTime date;
  final String title;
  final List<String> ciphers;
  final List<Lyrics> lyrics;

  RepertoireDay({
    required this.id,
    required this.date,
    required this.title,
    required this.ciphers,
    required this.lyrics,
  });

  RepertoireDay copyWith({
    String? id,
    DateTime? date,
    String? title,
    List<String>? ciphers,
    List<Lyrics>? lyrics,
  }) {
    return RepertoireDay(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      ciphers: ciphers ?? this.ciphers,
      lyrics: lyrics ?? this.lyrics,
    );
  }

  factory RepertoireDay.fromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> lyricsMap = List<Map<String, dynamic>>.from(
      map['repertoire_music'],
    ).map<Map<String, dynamic>>((e) => e['music']['lyrics'][0]).toList();

    return RepertoireDay(
      id: map['id'] as String,
      date: DateTime.parse(map['date']),
      title: map['title'] ?? '',
      ciphers: [],
      lyrics: List<Lyrics>.from(
        lyricsMap.map<Lyrics>((x) => Lyrics.fromMap(x)),
      ),
    );
  }
}
