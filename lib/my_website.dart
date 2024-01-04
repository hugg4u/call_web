import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebsite extends StatefulWidget {
  const MyWebsite({super.key});

  @override
  State<MyWebsite> createState() => _MyWebsitetate();
}

class _MyWebsitetate extends State<MyWebsite> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Website'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri("https://flutter.dev")),
            onWebViewCreated: (controller) {
              inAppWebViewController = controller;
            },
            onProgressChanged: (controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
        ],
      ),
    );
  }
}
