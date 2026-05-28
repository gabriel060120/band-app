import 'package:band_app/domain/models/chords/chords.dart';
import 'package:band_app/domain/models/lyrics/lyrics.dart';

class Music {
  String id;
  String name;
  String artist;
  List<Lyrics> lyrics;
  List<Chords> chords;
  int order;
  Music({
    required this.id,
    required this.name,
    required this.artist,
    required this.lyrics,
    required this.chords,
    required this.order,
  });

  Music copyWith({
    String? id,
    String? name,
    String? artist,
    List<Lyrics>? lyrics,
    List<Chords>? chords,
    int? order,
  }) {
    return Music(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      lyrics: lyrics ?? this.lyrics,
      chords: chords ?? this.chords,
      order: order ?? this.order,
    );
  }

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['music']['id'],
      name: map['music']?['name'] ?? '',
      artist: map['music']?['artist'] ?? '',
      lyrics: List<Lyrics>.from(
        (map['music']['lyrics'] ?? []).map<Lyrics>(
          (lyricsMap) =>
              Lyrics.fromMap(lyricsMap, artist: map['music']?['artist'] ?? ''),
        ),
      ),
      chords: List<Chords>.from(
        (map['music']['chords'] ?? []).map<Chords>(
          (chordsMap) =>
              Chords.fromMap(chordsMap, artist: map['music']?['artist'] ?? ''),
        ),
      ),
      order: map['order'] ?? 0,
      // List<Cipher>.from(
      // (map['ciphers'] ?? []).map<Cipher>(
      // (x) => Cipher.fromMap(x as Map<String, dynamic>),
      // ),
      // ),
    );
  }
}
