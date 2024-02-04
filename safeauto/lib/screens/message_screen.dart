import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:safeauto/screens/home_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/ville-kaisla-HNCSCpWrVJA-unsplash.jpg'),
                    fit: BoxFit.cover)),
            child: Container(
              color: const Color.fromARGB(224, 36, 37, 57),
              child: Column(children: [
                const SizedBox(
                  height: 30,
                ),
                chatUi()
              ]),
            ),
          ),
        ),
      ),
    );

    //   Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: ChatBubble(),
    //   ),
    // );
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

// class ChatList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('chats').snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         List<ChatModel> messages = snapshot.data!.docs
//             .map((doc) => ChatModel.fromMap(doc.data() as Map<String, dynamic>))
//             .toList();

//         return ListView.builder(
//           itemCount: messages.length,
//           itemBuilder: (context, index) {
//             return ChatBubble(message: messages[index]);
//           },
//         );
//       },
//     );
//   }
// }

class ChatBubble2 extends StatefulWidget {
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
                          // Close the dialog
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
                          // Close the dialog
                          // _showTopScreenMessage(context);
                          // Handle trusted action
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
              ? Container(
                  width: 300,
                  height: 500,
                  child: const Image(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/3.jpg',
                      // 'assets/download.jpeg',
                    ),
                  ),
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/3.jpg',
                          // 'assets/download.jpeg',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Is this person trusted?',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 255, 255, 255)),
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
