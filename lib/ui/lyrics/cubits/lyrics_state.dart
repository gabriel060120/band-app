abstract class LyricsState {}

class LyricsInitial extends LyricsState {}

class LyricsLoading extends LyricsState {}

class LyricsLoaded extends LyricsState {}

class LyricsError extends LyricsState {
  final String message;
  LyricsError(this.message);
}
