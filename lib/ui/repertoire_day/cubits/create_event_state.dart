abstract class CreateEventState {}

class CreateEventInitial extends CreateEventState {}

class CreateEventLoading extends CreateEventState {}

class CreateEventSuccess extends CreateEventState {}

class CreateEventError extends CreateEventState {
  final String message;
  CreateEventError(this.message);
}
