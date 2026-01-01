import 'package:band_app/data/repositories/repositories.dart';
import 'package:band_app/utils/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit(this.repository) : super(CreateEventInitial());
  final CreateEventRepository repository;

  void createEvent({
    required String title,
    required String observations,
    required DateTime date,
  }) async {
    emit(CreateEventLoading());
    final result = await repository.createEvent(title, observations, date);
    result.fold(
      (success) {
        emit(CreateEventSuccess());
      },
      (error) {
        emit(CreateEventError(error.toString()));
      },
    );
  }
}
