// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:lottie/lottie.dart';
import 'package:safeauto/screens/card_item.dart';
import 'package:safeauto/screens/message_screen.dart';
// import 'package:safeauto/screens/test.dart';

import '../auth/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> switchStates = [false, false, false, false];
  CollectionReference _firestore =
      FirebaseFirestore.instance.collection('actions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
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
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    'assets/istockphoto-1406257864-612x612.jpg',
                  ),
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CardWidget(
                  cardItems: [
                    CardItem(
                      title: 'Doors',
                      subtitle: 'Control the doors',
                      backgroundColor: const Color(0xFF00E5F9),
                      textColor: Colors.black,
                      switchColor: const Color(0xFF00E5F9),
                      switchBallColor: const Color(0xFF030F1B),
                      isSwitchOn: switchStates[0],
                      onChange: (newValue) {
                        setState(() {
                          switchStates[0] = newValue;
                          if (newValue == true) {
                            _updateFirestoreData('Doors', 'On');
                          }
                        });
                      },
                    ),
                    CardItem(
                      title: 'Trunk',
                      subtitle: 'Open or close the trunk',
                      backgroundColor: const Color(0xFF062A3A),
                      textColor: Colors.white,
                      switchColor: const Color(0xFF062A3A),
                      switchBallColor: const Color(0xFF346977),
                      isSwitchOn: switchStates[1],
                      onChange: (newValue) {
                        setState(() {
                          switchStates[1] = newValue;
                          if (newValue == true) {
                            _updateFirestoreData('Trunk', 'Open');
                          }
                        });
                      },
                    ),
                    CardItem(
                      title: 'Engine',
                      subtitle: 'Start or stop the engine',
                      backgroundColor: const Color(0xFF062A3A),
                      textColor: Colors.white,
                      switchColor: const Color(0xFF062A3A),
                      switchBallColor: const Color(0xFF346977),
                      isSwitchOn: switchStates[2],
                      onChange: (newValue) {
                        setState(() {
                          switchStates[2] = newValue;
                          if (newValue == true) {
                            _updateFirestoreData('Engine', 'Start');
                          }
                        });
                      },
                    ),
                    CardItem(
                      title: 'Climate',
                      subtitle: 'Adjust the climate settings',
                      backgroundColor: const Color(0xFF00E5F9),
                      textColor: Colors.black,
                      switchColor: const Color(0xFF00E5F9),
                      switchBallColor: const Color(0xFF030F1B),
                      isSwitchOn: switchStates[3],
                      onChange: (newValue) {
                        setState(() {
                          switchStates[3] = newValue;
                          if (newValue == true) {
                            _updateFirestoreData('Climate', 'Adjust');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 4, 22, 29),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: BottomNavBar(),
        ),
      ),
    );
  }

  Future<void> _updateFirestoreData(String itemName, String action) async {
    _firestore
        .add({
          'item': itemName,
          'action': action,
          'timestamp': FieldValue.serverTimestamp(),
        })
        .then((value) => print("============Added"))
        .catchError(
            (error) => print("=========================Failed : $error"));
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return GNav(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        color: Colors.white,
        activeColor: const Color.fromARGB(255, 17, 97, 129),
        tabBackgroundColor: Colors.white,
        gap: 0,
        onTabChange: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(),
              ),
            );
          }

          print(index);
        },
        padding: const EdgeInsets.all(16),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.location_on,
            text: 'Location',
          ),
          GButton(
            icon: Icons.message,
            text: 'Message',
          ),
          GButton(
            icon: Icons.car_crash_rounded,
            text: 'My Car',
          ),
        ]);
  }
}
