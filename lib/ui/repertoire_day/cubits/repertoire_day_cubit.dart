import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_state.dart';
import 'package:band_app/utils/result.dart';
import 'package:bloc/bloc.dart';

class RepertoireDayCubit extends Cubit<RepertoireDayState> {
  RepertoireDayCubit(this._repertoireDayRepository)
    : super(RepertoireDayInitial());
  final RepertoireDayRepository _repertoireDayRepository;

  Future<void> fetchRepertoireDays() async {
    emit(RepertoireDayLoading());
    final result = await _repertoireDayRepository.fetchRepertoireDays();
    result.fold(
      (days) {
        emit(RepertoireDayListState(days));
      },
      (error) {
        emit(RepertoireDayError('Talvez você não esteja conectado à internet'));
      },
    );
  }

  // void previousPage() {
  //   if (state is RepertoireDaySelectCipherState) {
  //     final currentState = state as RepertoireDaySelectCipherState;
  //     if (currentState.index > 0) {
  //       emit(currentState.copyWith(index: currentState.index - 1));
  //     }
  //   } else {
  //     final currentState = state as RepertoireDaySelectLyricsState;
  //     if (currentState.index > 0) {
  //       emit(currentState.copyWith(index: currentState.index - 1));
  //     }
  //   }
  // }

  // void nextPage() {
  //   if (state is RepertoireDaySelectCipherState) {
  //     final currentState = state as RepertoireDaySelectCipherState;
  //     if (currentState.index < currentState.cipher.length - 1) {
  //       emit(currentState.copyWith(index: currentState.index + 1));
  //     }
  //   } else {
  //     final currentState = state as RepertoireDaySelectLyricsState;
  //     if (currentState.index < currentState.lyrics.length - 1) {
  //       emit(currentState.copyWith(index: currentState.index + 1));
  //     }
  //   }
  // }
}
