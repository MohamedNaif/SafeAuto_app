import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dio/dio.dart';

class StreamApp extends StatefulWidget {
  @override
  _StreamAppState createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  InAppWebViewController? webViewController;
  final String serverIP = "http://192.168.1.6:5000"; // Replace with your actual server IP
  bool isLoading = true;
  String errorMessage = '';
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchStream();
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }

  Future<void> _fetchStream() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await dio.get('$serverIP/video_feed');
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
      } else {
        _showError('Error: Unable to load stream');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      isLoading = false;
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surveillance Stream',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri('$serverIP/video_feed')),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) => setState(() {
              isLoading = true;
              errorMessage = '';
            }),
            onLoadStop: (controller, url) => setState(() => isLoading = false),
            onReceivedError: (controller, request, error) => _showError('Error: ${error.description}'),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
          if (errorMessage.isNotEmpty)
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
