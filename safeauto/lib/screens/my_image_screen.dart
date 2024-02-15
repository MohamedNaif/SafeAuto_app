import 'dart:io';
import 'package:flutter/material.dart';

class SelectedImageScreen extends StatelessWidget {
  final List<File> imageFiles;

  const SelectedImageScreen({Key? key, required this.imageFiles,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Images'),
      ),
      body: ListView.builder(
        itemCount: imageFiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(imageFiles[index]),
          );
        },
      ),
    );
  }
}
