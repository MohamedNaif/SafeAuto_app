import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safeauto/home/home_page.dart';
import 'package:safeauto/home/widget/bottom_nav_bar.dart';
import 'package:safeauto/location/location.dart';
import 'package:safeauto/message/message_screen.dart';
import 'package:safeauto/trusted/user_profile.dart';
import 'package:safeauto/auth/login_screen.dart';
import 'package:safeauto/auth/widget/new_button.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final bool? isLocked;

  HomeScreen({Key? key, this.isLocked}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<bool> switchStates = [false, false, false, false];
  CollectionReference _firestore =
      FirebaseFirestore.instance.collection('actions');
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LocationScreen(),
    ChatScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 4, 22, 29),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            color: Colors.white,
            activeColor: const Color.fromARGB(255, 17, 97, 129),
            tabBackgroundColor: Colors.white,
            gap: 8,
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
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
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
