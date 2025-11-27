import 'package:band_app/domain/models/lyrics/lyrics.dart';

abstract class LyricsState {
  final int index;
  final List<Lyrics> lyrics;
  LyricsState(this.index, this.lyrics);
}

class LyricsInitial extends LyricsState {
  LyricsInitial(List<Lyrics> lyrics) : super(0, lyrics);
}

class LyricsLoaded extends LyricsState {
  LyricsLoaded(super.index, super.lyrics);
}

class LyricsError extends LyricsState {
  final String message;
  LyricsError(this.message) : super(0, []);
}
