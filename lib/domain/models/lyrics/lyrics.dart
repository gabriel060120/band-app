class Lyrics {
  final String title;
  final String artist;
  final String content;

  Lyrics({required this.title, required this.artist, required this.content});

  Lyrics copyWith({String? title, String? artist, String? content}) {
    return Lyrics(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      content: content ?? this.content,
    );
  }

  factory Lyrics.fromMap(Map<String, dynamic> map) {
    return Lyrics(
      title: map['name'],
      artist: map['artist'] ?? '',
      content: map['body'],
    );
  }
}
