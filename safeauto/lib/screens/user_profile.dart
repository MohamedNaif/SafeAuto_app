import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 52,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images/user_avatar.png'), // Provide path to user's avatar
                ),
              ),
              SizedBox(height: 20),
              Text(
                userName.text, // User's name
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                emailController.text, // User's email
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Add a picture of the people allowed to use the car', // User's email
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for editing user profile
                },
                child: Text('Add a picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
