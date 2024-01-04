import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
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
                //Permission request for microphone and video
                onPermissionRequest: (controller, permissionRequest) async {
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
                  });
                },
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            //bottom navigation
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
          ElevatedButton(
            onPressed: () async {
              // Create a unique ID for the call
              String currentUuid = UniqueKey().toString();
              // Configure CallKit parameters
              CallKitParams callKitParams = CallKitParams(
                id: currentUuid,
                nameCaller: 'John Doe',
                handle: '+1234567890',
                type: 0,
                textAccept: 'Accept',
                textDecline: 'Decline',
                missedCallNotification: const NotificationParams(
                  showNotification: true,
                  isShowCallback: true,
                  subtitle: 'Missed Call',
                  callbackText: 'Callback',
                ),
                //Setting time call
                duration: 30000,
                extra: <String, dynamic>{'userId': '1a2b3c4d'},
                headers: <String, dynamic>{
                  'apiKey': 'Abc@123!',
                  'platform': 'flutter'
                },
                android: const AndroidParams(
                    isCustomNotification: true,
                    isShowLogo: false,
                    ringtonePath: 'system_ringtone_default',
                    backgroundColor: '#0955fa',
                    backgroundUrl: 'https://i.pravatar.cc/500',
                    actionColor: '#4CAF50',
                    incomingCallNotificationChannelName: "Incoming Call",
                    missedCallNotificationChannelName: "Missed Call"),
                avatar: currentUuid,
                ios: const IOSParams(
                  iconName: 'CallKitLogo',
                  handleType: 'generic',
                  supportsVideo: true,
                  maximumCallGroups: 2,
                  maximumCallsPerCallGroup: 1,
                  audioSessionMode: 'default',
                  audioSessionActive: true,
                  audioSessionPreferredSampleRate: 44100.0,
                  audioSessionPreferredIOBufferDuration: 0.005,
                  supportsDTMF: true,
                  supportsHolding: true,
                  supportsGrouping: false,
                  supportsUngrouping: false,
                  ringtonePath: 'system_ringtone_default',
                ),
              );

              // Show CallKit incoming call
              await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);

              FlutterCallkitIncoming.startCall(callKitParams);
              //handle event call
              FlutterCallkitIncoming.onEvent.listen((event) {
                switch (event!.event) {
                  case Event.actionCallCallback:
                    // FlutterCallkitIncoming.startCall(callKitParams);

                    break;
                  default:
                }
              });
            },
            child: const Text('Make Call'),
          ),
        ],
      ),
    );
  }

// Permission for callkit
  // Future<void> _requestNotificationPermission() async {
  //   await FlutterCallkitIncoming.requestNotificationPermission({
  //     "rationaleMessagePermission":
  //         "Notification permission is required, to show notification.",
  //     "postNotificationMessageRequired":
  //         "Notification permission is required, Please allow notification permission from setting."
  //   });
  // }
}
