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

class CarControl extends StatefulWidget {
  bool? isLocked;
  CarControl({Key? key, bool? isLocked});

  @override
  State<CarControl> createState() => _CarControlState();
}

class _CarControlState extends State<CarControl> {
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Car Control Screen',
          style: TextStyle(
            color:
                Colors.white, // Set text color to white for better visibility
          ),
        ),
        backgroundColor:
            Colors.grey[900], // Set a dark background color for the AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back arrow to white
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.h),
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
                            _updateFirestoreData('Doors', 'Doors', 'Open');
                          } else {
                            _updateFirestoreData('Doors', 'Doors', 'Close');
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
                            _updateFirestoreData('Engine', 'Engine', 'Start');
                          } else {
                            _updateFirestoreData('Engine', 'Engine', 'Stop');
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
    );
  }

  Future<void> _updateFirestoreData(
      String docName, String itemName, String action) async {
    _firestore
        .doc(docName) // Specify the document name
        .set({
          itemName: action, // Set the field with the provided action
          'timestamp': FieldValue.serverTimestamp(),
        })
        .then((_) => print("Document '$docName' updated successfully"))
        .catchError(
            (error) => print("Failed to update document '$docName': $error"));
  }

  @override
  void dispose() {
    _updateFirestoreData('Engine', 'Engine', 'Stop');
    _updateFirestoreData('Doors', 'Doors', 'Close');

    super.dispose();
  }
}
