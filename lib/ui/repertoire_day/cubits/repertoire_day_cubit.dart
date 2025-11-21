import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_state.dart';
import 'package:band_app/utils/result.dart';
import 'package:bloc/bloc.dart';

class RepertoireDayCubit extends Cubit<RepertoireDayState> {
  RepertoireDayCubit(this._repertoireDayRepository)
    : super(RepertoireDayInitial());
  final RepertoireDayRepository _repertoireDayRepository;

  Future<void> fetchRepertoireDays() async {
    final result = await _repertoireDayRepository.fetchRepertoireDays();
    result.fold(
      (r) {
        emit(RepertoireDaySelectTypeState(r));
      },
      (l) {
        emit(RepertoireDayError('Talvez você não esteja conectado à internet'));
      },
    );
  }

  Future<void> selectRepertoireType(int index) async {
    if (index == 0) {
      emit(
        RepertoireDayLyricsState(
          (state as RepertoireDaySelectTypeState).repertoireDay.lyrics,
          0,
        ),
      );
    } else {
      emit(
        RepertoireDayCipherState(
          (state as RepertoireDaySelectTypeState).repertoireDay.ciphers,
          0,
        ),
      );
    }
  }

  void previousPage() {
    if (state is RepertoireDayCipherState) {
      final currentState = state as RepertoireDayCipherState;
      if (currentState.index > 0) {
        emit(currentState.copyWith(index: currentState.index - 1));
      }
    } else {
      final currentState = state as RepertoireDayLyricsState;
      if (currentState.index > 0) {
        emit(currentState.copyWith(index: currentState.index - 1));
      }
    }
  }

  void nextPage() {
    if (state is RepertoireDayCipherState) {
      final currentState = state as RepertoireDayCipherState;
      if (currentState.index < currentState.cipher.length - 1) {
        emit(currentState.copyWith(index: currentState.index + 1));
      }
    } else {
      final currentState = state as RepertoireDayLyricsState;
      if (currentState.index < currentState.lyrics.length - 1) {
        emit(currentState.copyWith(index: currentState.index + 1));
      }
    }
  }

  void updateFontSize(int newSize) {
    if (state is RepertoireDayLyricsState) {
      final currentState = state as RepertoireDayLyricsState;
      emit(currentState.copyWith(fontSize: newSize));
    }
  }
}
