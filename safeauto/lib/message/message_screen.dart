import 'package:flutter/material.dart';


import 'widget/chat_ui.dart';

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
