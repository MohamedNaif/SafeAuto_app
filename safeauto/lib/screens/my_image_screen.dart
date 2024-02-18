import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SelectedImageScreen extends StatefulWidget {
  final List<String> imageUrls;

  const SelectedImageScreen({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  _SelectedImageScreenState createState() => _SelectedImageScreenState();
}

class _SelectedImageScreenState extends State<SelectedImageScreen> {
  late StreamController<List<String>> _imageUrlsController;

  @override
  void initState() {
    super.initState();
    _imageUrlsController = StreamController<List<String>>.broadcast();

    // Download images before adding to stream
    Future.wait(widget.imageUrls.map((url) => _downloadImage(url)))
        .then((downloadedUrls) {
      _imageUrlsController.add(downloadedUrls);
      print("Initial image URLs added to stream: $downloadedUrls");
    }).catchError((error) {
      // Handle download error
      print("Error downloading images: $error");
    });
  }

  @override
  void dispose() {
    _imageUrlsController.close();
    super.dispose();
  }

  Future<String> _downloadImage(String url) async {
    // Implement your image download logic here
    // Replace with actual downloaded image URL
    // This is just an example, replace with your actual download logic
    await Future.delayed(Duration(seconds: 1)); // Simulate download
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Images'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _imageUrlsController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<String>? imageUrls = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // You can adjust the number of columns here
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imageUrls!.length,
              itemBuilder: (context, index) {
                return _buildImageItem(index, imageUrls);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageItem(int index, List<String> imageUrls) {
    return Stack(
      children: [
        Image.network(
          imageUrls[index],
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteImage(index),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Future<void> _deleteImage(int index) async {
    try {
      var ref = FirebaseStorage.instance.refFromURL(widget.imageUrls[index]);
      await ref.delete();
      print("Image deleted at index $index");
      setState(() {
        widget.imageUrls.removeAt(index);
        _imageUrlsController.add(widget.imageUrls);
        print("Updated image URLs: ${widget.imageUrls}");
      });
    } catch (e) {
      print("Error deleting image from Firebase Storage: $e");
    }
  }
}
