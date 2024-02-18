
import 'package:flutter/material.dart';


import 'chat_bubble.dart';

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
