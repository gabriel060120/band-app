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

  void selectRepertoireDay(String id) {
    if (state is RepertoireDayListState) {
      final days = (state as RepertoireDayListState).repertoireDays;
      final selectedDay = days.firstWhere((day) => day.id == id);
      emit(RepertoireDaySelectTypeState(selectedDay));
    }
  }

  void selectRepertoireType(int index, String id) {
    if (index == 0) {
      emit(RepertoireDaySelectLyricsState(id));
    } else {
      emit(RepertoireDaySelectCipherState(id));
    }
  }
}
