import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safeauto/home/widget/card_item.dart';
import '../auth/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bluetooth/main_page.dart';
import '../bluetooth/widgets/action_button.dart';
import 'car_firebase.dart';

class HomePage extends StatefulWidget {
  bool? isLocked;
  HomePage({Key? key, bool? isLocked});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLocked = false;
  final List<bool> switchStates = [false, false, false, false];
  CollectionReference _firestore =
      FirebaseFirestore.instance.collection('actions');
  int _selectedIndex = 0;

  BluetoothConnection? _connection;

  void _sendData(String data) {
    if (_connection?.isConnected ?? false) {
      _connection?.output.add(utf8.encode(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.h),
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
              height: 200.h,
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
              height: 150.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                      text: "Control With Bluetooth",
                      fontSize: 15.sp,
                      color: const Color(0xFF062A3A),
                      textColor: Color.fromARGB(255, 255, 255, 255),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(),
                          ),
                        );
                      }
                      // _sendData("1"),
                      ),
                  // Spacer(),
                   SizedBox(
              width: 15.w,
            ),
                  ActionButton(
                      color: const Color(0xFF00E5F9),
                      text: "Control With FireBase",
                      fontSize: 15.sp,
                      textColor: const Color(0xFF030F1B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarControl(),
                          ),
                        );
                      }),
                ],
              ),
            ),
            // Container(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Visibility(
            //       visible: isLocked,
            //       child: CardWidget(
            //         cardItems: [
            //           CardItem(
            //             title: 'Doors',
            //             subtitle: 'Control the doors',
            //             backgroundColor: const Color(0xFF00E5F9),
            //             textColor: Colors.black,
            //             switchColor: const Color(0xFF00E5F9),
            //             switchBallColor: const Color(0xFF030F1B),
            //             isSwitchOn: switchStates[0],
            //             onChange: (newValue) {
            //               setState(() {
            //                 switchStates[0] = newValue;
            //                 if (newValue == true) {
            //                   _sendData("2");
            //                   // _updateFirestoreData('Doors', 'On');
            //                 }
            //               });
            //             },
            //           ),
            //           CardItem(
            //             title: 'Engine',
            //             subtitle: 'Start or stop the engine',
            //             backgroundColor: const Color(0xFF062A3A),
            //             textColor: Colors.white,
            //             switchColor: const Color(0xFF062A3A),
            //             switchBallColor: const Color(0xFF346977),
            //             isSwitchOn: switchStates[2],
            //             onChange: (newValue) {
            //               setState(() {
            //                 switchStates[2] = newValue;
            //                 if (newValue == true) {
            //                   _sendData("1");
            //                   // _updateFirestoreData('Engine', 'Start');
            //                 }
            //               });
            //             },
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
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
