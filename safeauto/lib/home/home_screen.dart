import 'package:flutter/material.dart';
import 'package:safeauto/home/widget/card_item.dart';
import '../auth/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/widget/new_button.dart';
import '../bluetooth/MainPage.dart';
import 'widget/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLocked = false;
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
            SizedBox(
              height: 50,
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: isLocked,
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
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !isLocked,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(15, 15)),
                    child: Card(
                      color: Color.fromARGB(115, 57, 42, 42),
                      child: Container(
                        height: 180,
                        width: 180,
                        child: Icon(
                          Icons.lock,
                          color: const Color(0xFF00E5F9),
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "Connect With Bluetooth To unlock And Control You Car",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00E5F9),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(),
                        ),
                      );
                    },
                    child: Text('Bluetooth'),
                  ),
                ],
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
