import 'package:band_app/domain/models/chords/chords.dart';
import 'package:bloc/bloc.dart';

import 'chords_state.dart';

class ChordsCubit extends Cubit<ChordsState> {
  ChordsCubit(List<Chords> chords) : super(ChordsInitial(chords));

  void nextChords() {
    final s = state;
    if (s.index < s.chords.length - 1) {
      emit(ChordsLoaded(s.index + 1, s.chords, transpose: 0));
    }
  }

  void previousChords() {
    final s = state;
    if (s.index > 0) {
      emit(ChordsLoaded(s.index - 1, s.chords, transpose: 0));
    }
  }

  void transposeUp() {
    final s = state;
    emit(ChordsLoaded(s.index, s.chords, transpose: s.transpose + 1));
  }

  void transposeDown() {
    final s = state;
    emit(ChordsLoaded(s.index, s.chords, transpose: s.transpose - 1));
  }

  void resetTranspose() {
    final s = state;
    emit(ChordsLoaded(s.index, s.chords, transpose: 0));
  }
}
