import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.phone.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InAppWebViewExample(),
    );
  }
}

class InAppWebViewExample extends StatefulWidget {
  @override
  _InAppWebViewExampleState createState() => _InAppWebViewExampleState();
}

class _InAppWebViewExampleState extends State<InAppWebViewExample> {
  late InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppWebView Example'),
      ),
      body: Column(
        children: <Widget>[
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri(
                        "https://55e6f3a4-0a54-4afb-89f6-656184512597-00-mynbartpi4tq.worf.replit.dev/")),
                initialSettings: InAppWebViewSettings(
                    mediaPlaybackRequiresUserGesture: false),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onPermissionRequest: (controller, permissionRequest) async {
                  print("PermissionRequest:" + permissionRequest.toString());
                  return PermissionResponse(
                      resources: permissionRequest.resources,
                      action: PermissionResponseAction.GRANT);
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    this.progress = progress / 100;
                    _webViewController.evaluateJavascript(
                        source: "document.title");
                  });
                },
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  _webViewController.goBack();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  _webViewController.goForward();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.refresh),
                onPressed: () {
                  _webViewController.reload();
                  _webViewController.createWebMessageChannel();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
