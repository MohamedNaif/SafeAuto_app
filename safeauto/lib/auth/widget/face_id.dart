// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';

// class FaceIdLoginScreen extends StatefulWidget {
//   @override
//   _FaceIdLoginScreenState createState() => _FaceIdLoginScreenState();
// }

// class _FaceIdLoginScreenState extends State<FaceIdLoginScreen> {
//   final _imagePicker = ImagePicker();
//   XFile? _imageFile;

//   Future<void> pickAndProcessImage() async {
//     final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = pickedFile;
//       });

//       // Use the path property directly from XFile
//       final inputImage = InputImage.fromFilePath(pickedFile.path);
//       final faces = await detectFaces(inputImage);

//       // Process the detected faces (e.g., display bounding boxes)
//       for (final face in faces) {
//         final rect = face.boundingBox;
//         print('Face detected at: $rect');
//       }
//     }
//   }

//   Future<List<Face>> detectFaces(InputImage image) async {
//     final faceDetector = GoogleMlKitFaceDetection.instance.faceDetector(
//       options: FaceDetectorOptions(
//         mode: FaceDetectorMode.accurate, // Choose between fast/accurate
//       ),
//     );
//     final faces = await faceDetector.processImage(image);
//     return faces;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Face Detection'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               if (_imageFile != null)
//                 Image.file(File(_imageFile!.path)),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: pickAndProcessImage,
//                 child: Text('Pick Image'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
