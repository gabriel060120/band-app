class RepertoireDayState {}

class RepertoireDayInitial extends RepertoireDayState {}

class RepertoireDayLoading extends RepertoireDayState {}

class RepertoireDayLoaded extends RepertoireDayState {
  final List<String> chipers;
  final int index;
  RepertoireDayLoaded(this.chipers, this.index);

  RepertoireDayLoaded copyWith({
    List<String>? chipers,
    int? index,
  }) {
    return RepertoireDayLoaded(
      chipers ?? this.chipers,
      index ?? this.index,
    );
  }
}

class RepertoireDayError extends RepertoireDayState {
  final String message;
  RepertoireDayError(this.message);
}
