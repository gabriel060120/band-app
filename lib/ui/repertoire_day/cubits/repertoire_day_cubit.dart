import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_state.dart';
import 'package:band_app/utils/result.dart';
import 'package:bloc/bloc.dart';

class RepertoireDayCubit extends Cubit<RepertoireDayState> {
  RepertoireDayCubit(this._repertoireDayRepository) : super(RepertoireDayInitial());
    final RepertoireDayRepository _repertoireDayRepository;

    Future<void> fetchRepertoireDays() async {
      final result = await _repertoireDayRepository.fetchRepertoireDays();
      result.fold((r) {
        emit(RepertoireDayLoaded(r, 0));
      }, (l) {
        emit(RepertoireDayError('Talvez você não esteja conectado à internet'));
      });
  }

  void previousPage() {
    if (state is RepertoireDayLoaded) {
      final currentState = state as RepertoireDayLoaded;
      if (currentState.index > 0) {
        emit(currentState.copyWith(index: currentState.index - 1));
      }
    }
  }

  void nextPage() {
    if (state is RepertoireDayLoaded) {
      final currentState = state as RepertoireDayLoaded;
      if (currentState.index < currentState.chipers.length - 1) {
        emit(currentState.copyWith(index: currentState.index + 1));
      }
    }
  }

}