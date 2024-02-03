import 'package:flutter/material.dart';
import 'package:safeauto/screens/home_screen.dart'; // Import your home screen file

class FingerPrint extends StatelessWidget {
  const FingerPrint({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Put Your Finger Here ',
              style: TextStyle(
                color: Color.fromARGB(255, 64, 248, 255),
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to the home screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Replace with your home screen widget
                );
              },
              child: Icon(
                Icons.fingerprint_rounded,
                color: Color.fromARGB(255, 64, 248, 255),
                size: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
