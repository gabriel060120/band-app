import 'package:band_app/data/repositories/repertoire_day/event_selected_repository.dart';
import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:band_app/ui/repertoire_day/cubits/event_selected_state.dart';
import 'package:band_app/utils/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventSelectedCubit extends Cubit<EventSelectedState> {
  final EventSelectedRepository _repository;
  EventSelectedCubit(super.initialState, this._repository) {
    fetchEventData();
  }

  bool get hasLyrics {
    if (state is EventSelectedLoadedState) {
      final currentState = state as EventSelectedLoadedState;
      return currentState.eventData.musics.any(
        (music) => music.lyrics.isNotEmpty,
      );
    }
    return false;
  }

  bool get hasCiphers {
    if (state is EventSelectedLoadedState) {
      final currentState = state as EventSelectedLoadedState;
      return currentState.eventData.musics.any(
        (music) => music.ciphers.isNotEmpty,
      );
    }
    return false;
  }

  List<Lyrics> selectLyrics() {
    final currentState = state as EventSelectedLoadedState;
    return currentState.eventData.musics
        .where((music) => music.lyrics.isNotEmpty)
        .map((music) => music.lyrics.first)
        .toList();
  }

  Future<void> fetchEventData() async {
    emit(EventSelectedLoadingState(state.repertoireId));
    final result = await _repository.fetchEventData(state.repertoireId);
    result.fold(
      (data) {
        emit(EventSelectedLoadedState(state.repertoireId, data));
      },
      (error) {
        emit(EventSelectedErrorState(state.repertoireId, error.toString()));
      },
    );
  }
}
