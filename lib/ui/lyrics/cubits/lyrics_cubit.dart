import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'lyrics_state.dart';

class LyricsCubit extends Cubit<LyricsState> {
  late final InAppWebViewController webViewController;

  LyricsCubit(List<Lyrics> lyrics) : super(LyricsInitial(lyrics));
  void nextLyrics() {
    final currentIndex = state.index;
    final lyricsList = state.lyrics;
    if (currentIndex < lyricsList.length - 1) {
      emit(LyricsLoaded(currentIndex + 1, lyricsList));
    }
  }

  void previousLyrics() {
    final currentIndex = state.index;
    final lyricsList = state.lyrics;
    if (currentIndex > 0) {
      emit(LyricsLoaded(currentIndex - 1, lyricsList));
    }
  }
}
