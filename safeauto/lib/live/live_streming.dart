import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'video_recording_screen.dart'; // Assuming this is your recording screen


class StreamApp extends StatefulWidget {
  final String serverIP =
      "http://192.168.1.10:5000"; // Replace with your actual server IP

  @override
  _StreamAppState createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  @override
  void initState() {
    super.initState();
    if (WebView.platform == null) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Surveillance Stream',
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      //   ),
      //   centerTitle: true,
      // ),
       appBar: AppBar(
        centerTitle: true,
        title: Text('Surveillance Stream'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoGridScreen()),
              );
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'http://192.168.1.10:5000/video_feed',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
