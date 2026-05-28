import 'package:band_app/domain/models/chords/chords.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'chords_state.dart';

class ChordsCubit extends Cubit<ChordsState> {
  late final InAppWebViewController webViewController;

  ChordsCubit(List<Chords> chords) : super(ChordsInitial(chords));
  void nextChords() {
    final currentIndex = state.index;
    final chordsList = state.chords;
    if (currentIndex < chordsList.length - 1) {
      emit(ChordsLoaded(currentIndex + 1, chordsList));
    }
  }

  void previousChords() {
    final currentIndex = state.index;
    final chordsList = state.chords;
    if (currentIndex > 0) {
      emit(ChordsLoaded(currentIndex - 1, chordsList));
    }
  }
}
