import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChiperWebviewScreen extends StatefulWidget {
  const ChiperWebviewScreen({super.key, required this.url});
  final String url;

  @override
  State<ChiperWebviewScreen> createState() => _ChiperWebviewScreenState();
}

class _ChiperWebviewScreenState extends State<ChiperWebviewScreen> with AutomaticKeepAliveClientMixin {

  
  @override
  bool get wantKeepAlive => true;
  
  Offset? startPosition;

  late InAppWebViewController webView;
  double progress = 0;
  String url = "";
  bool _loading = true;
  final _stackKey = GlobalKey();
  bool isExitPage = false;
  bool isHandler = false;
  bool toPop = false;

  var helper = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RawGestureDetector(
      gestures: {
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          (instance) {},
        ),
      },
      behavior: HitTestBehavior.opaque,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (canPop, result) async {
          try {
            if (await webView.canGoBack() && !isExitPage) {
              webView.goBack();
            } else if (!isHandler && !toPop) {
              isHandler = false;
              toPop = true;
            }
          } catch (_) {}
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              key: _stackKey,
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InAppWebView(
                    initialSettings: InAppWebViewSettings(
                      supportZoom: true,
                      preferredContentMode: UserPreferredContentMode.MOBILE,
                      transparentBackground: true,
                      javaScriptEnabled: true,
                      allowsBackForwardNavigationGestures: true,
                    ),
                    gestureRecognizers:  {
                      // Permite gestos verticais dentro da WebView
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ),
                    },
                    // initialOptions: InAppWebViewGroupOptions(
                    //   android: AndroidInAppWebViewOptions(
                    //     defaultFontSize: widget.defaultFontSize,
                    //   ),
                    //   crossPlatform: InAppWebViewOptions(
                    //     minimumFontSize: 12,
                    //     supportZoom: true,
                    //     preferredContentMode: UserPreferredContentMode.MOBILE,
                    //   ),
                    // ),
                    initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(widget.url)),
                        // headers: widget.shortToken != null
                            // ? {"Authorization": widget.shortToken!}
                            // : {},
                            ),
                    onWebViewCreated: (controller){
                      webView = controller;
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        _loading = false;
                      });
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                    if (!navigationAction.request.url.toString().contains('tv-free.vercel.app')) {
                      return NavigationActionPolicy.CANCEL;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                    onReceivedError: (controller, request, error) {
                      if (error.description == 'net::ERR_UNKNOWN_URL_SCHEME') {
                      } else {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
                  ),
                ),
                if (_loading)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: SizedBox(
                            child: CircularProgressIndicator(
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}