import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:safeauto/screens/home_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/ville-kaisla-HNCSCpWrVJA-unsplash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color.fromARGB(224, 36, 37, 57),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  chatUi(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class chatUi extends StatelessWidget {
  const chatUi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            // Adjust margin as needed
            height: 40,
            width: 40,
            child: const CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage:
                  AssetImage('assets/SafeAuto-without-Background.png'),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: ChatBubble2(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble2 extends StatefulWidget {
  final String? userId;

  const ChatBubble2({this.userId});
  @override
  _ChatBubble2State createState() => _ChatBubble2State();
}

class _ChatBubble2State extends State<ChatBubble2> {
  late Timer _timer;
  late StreamController<String> _imageStreamController;

  @override
  void initState() {
    super.initState();
    _imageStreamController = StreamController<String>();
    _updateImageStream();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _imageStreamController.close(); // Close the stream controller
    super.dispose();
  }

  void showResultDialog(bool isTrusted) {
    AwesomeDialog(
      context: context,
      dialogType: isTrusted ? DialogType.success : DialogType.error,
      animType: AnimType.rightSlide,
      title: isTrusted ? 'Success' : 'Failed',
      desc: isTrusted
          ? 'The passenger was allowed to use the car'
          : 'The passenger was not allowed to use the car',
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(200, 7, 7, 7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            // Wait for 5 seconds
            _timer = Timer(const Duration(seconds: 5), () {
              // After 5 seconds, show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  _timer.cancel(); // Cancel the timer when the dialog is shown
                  return AlertDialog(
                    title: const Text("Is this person trusted?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                          showResultDialog(false);

                          // Add data to Firestore
                          FirebaseFirestore.instance
                              .collection('isTrusted')
                              .add({
                                'isTrusted': false,
                                // Add any other data you want to store
                              })
                              .then((value) => print("============Added"))
                              .catchError((error) => print(
                                  "=========================Failed : $error"));
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                          showResultDialog(true);
                          FirebaseFirestore.instance
                              .collection('isTrusted')
                              .add({
                                'isTrusted': true,
                                // Add any other data you want to store
                              })
                              .then((value) => print("============Added"))
                              .catchError((error) => print(
                                  "=========================Failed : $error"));
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<String>(
                stream: _imageStreamController.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    width: 300,
                    height: 500,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Is this person trusted?',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              SizedBox(height: 4.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateImageStream() async {
    try {
      // Query Firebase Storage to get the list of files
      ListResult result =
          await FirebaseStorage.instance.ref().child("isTrusted").list();

      if (result.items.isNotEmpty) {
        // Get the latest image file
        var latestImage = result.items.first;

        // Get the download URL for the latest image
        String imageUrl = await latestImage.getDownloadURL();

        // Add the image URL to the stream
        _imageStreamController.add(imageUrl);
      } else {
        print("No files found in Firebase Storage under 'isTrusted' folder.");
      }
    } catch (error) {
      print("Error updating image stream: $error");
    }
  }
}
