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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Images'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // You can adjust the number of columns here
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return _buildImageItem(index);
        },
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        FutureBuilder(
          future: _getImage(widget.imageUrls[index]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(snapshot.data.toString()),
                fit: BoxFit.cover,
              ),
            );
          },
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

  Future<String> _getImage(String imageUrl) async {
    try {
      // Fetch image from Firebase Storage
      var ref = FirebaseStorage.instance.refFromURL(imageUrl);
      var url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error fetching image from Firebase Storage: $e");
      return ''; // Return empty string in case of error
    }
  }

  Future<void> _deleteImage(int index) async {
    try {
      var ref = FirebaseStorage.instance.refFromURL(widget.imageUrls[index]);
      await ref.delete();
      setState(() {
        widget.imageUrls.removeAt(index);
      });
    } catch (e) {
      print("Error deleting image from Firebase Storage: $e");
    }
  }
}
