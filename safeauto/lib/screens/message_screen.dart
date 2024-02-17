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
  bool isImageFullScreen = false;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
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
            setState(() {
              isImageFullScreen = true;
            });

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
          child: isImageFullScreen
              ? FutureBuilder(
                  future: FirebaseStorage.instance
                      .ref()
                      .child("isTrusted/Screenshot (515).png")
                      .getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return Container(
                      width: 300,
                      height: 500,
                      child: Image.network(
                        snapshot.data.toString(),
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 200,
                        width: 200,
                        child: FutureBuilder(
                          future: FirebaseStorage.instance
                              .ref()
                              .child("isTrusted/Screenshot (515).png")
                              .getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Container(
                              width: 300,
                              height: 500,
                              child: Image.network(
                                snapshot.data.toString(),
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        )),
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
}
