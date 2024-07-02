import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'video_recording_screen.dart'; // Assuming this is your recording screen

class StreamApp extends StatefulWidget {
  @override
  _StreamAppState createState() => _StreamAppState();
}

class _StreamAppState extends State<StreamApp> {
  final FijkPlayer _fijkPlayerController = FijkPlayer();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _fijkPlayerController.setDataSource(
        "http://192.168.1.7:5000/video_feed",
        autoPlay: true,
    //     analyzeduration: 10000, // Adjust value (in microseconds)
    // probesize: 102400,       // Adjust value (in bytes)

         // Replace with your actual URL
      );
      // await _fijkPlayerController.prepareAsync();

      setState(() {});
    } catch (e) {
      setState(() {
        errorMessage = 'Error initializing video player: $e';
      });
    }
  }

  @override
  void dispose() {
    _fijkPlayerController.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Live Stream'),
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
      body: Center(
        child: errorMessage.isNotEmpty
            ? Text(errorMessage)
            : FijkView(
                player: _fijkPlayerController,
              ),
      ),
    );
  }
}
