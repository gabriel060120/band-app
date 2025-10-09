import 'package:bloc/bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'chiper_webview_state.dart';

class ChiperWebviewCubit extends Cubit<ChiperWebviewState> {
  late final InAppWebViewController webViewController;

  ChiperWebviewCubit() : super(ChiperWebviewInitial());
  
  void setWebViewController(InAppWebViewController controller) {
    webViewController = controller;
  }
}
