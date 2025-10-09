abstract class ChiperWebviewState {}

class ChiperWebviewInitial extends ChiperWebviewState {}

class ChiperWebviewLoading extends ChiperWebviewState {}

class ChiperWebviewLoaded extends ChiperWebviewState {}

class ChiperWebviewError extends ChiperWebviewState {
  final String message;
  ChiperWebviewError(this.message);
}