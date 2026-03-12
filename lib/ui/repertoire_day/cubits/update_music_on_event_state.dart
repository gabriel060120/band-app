abstract class UpdateMusicOnEventState {}

class UpdateMusicOnEventInitial extends UpdateMusicOnEventState {}

class UpdateMusicOnEventLoading extends UpdateMusicOnEventState {}

class UpdateMusicOnEventError extends UpdateMusicOnEventState {
  final String message;
  UpdateMusicOnEventError(this.message);
}

class UpdateMusicOnEventLoaded extends UpdateMusicOnEventState {}

class UpdateMusicOnEventUpdating extends UpdateMusicOnEventState {}

class UpdateMusicOnEventUpdateError extends UpdateMusicOnEventState {
  final String message;
  UpdateMusicOnEventUpdateError(this.message);
}

class UpdateMusicOnEventUpdated extends UpdateMusicOnEventState {}
