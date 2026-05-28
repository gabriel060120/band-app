class Chords {
  final String title;
  final String artist;
  final String content;
  final String tone;
  final int capo;

  Chords({
    required this.title,
    required this.artist,
    required this.content,
    required this.tone,
    required this.capo,
  });

  factory Chords.fromMap(Map<String, dynamic> map, {String artist = ''}) {
    return Chords(
      title: map['title'],
      artist: map['artist'] ?? artist,
      content: map['content'],
      tone: map['tone'] ?? 'C',
      capo: map['capo'] ?? 0,
    );
  }
}
