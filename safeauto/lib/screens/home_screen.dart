import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:safeauto/screens/message_screen.dart';
import 'package:safeauto/screens/test.dart';

import '../auth/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CardItem> cardItems = [
    CardItem(
      title: 'Doors',
      subtitle: 'Control the doors',
      backgroundColor: const Color(0xFF00E5F9),
      textColor: Colors.black,
      switchColor: const Color(0xFF00E5F9),
      switchBallColor: const Color(0xFF030F1B),
    ),
    CardItem(
      title: 'Trunk',
      subtitle: 'Open or close the trunk',
      backgroundColor: const Color(0xFF062A3A),
      textColor: Colors.white,
      switchColor: const Color(0xFF062A3A),
      switchBallColor: const Color(0xFF346977),
    ),
    CardItem(
      title: 'Engine',
      subtitle: 'Start or stop the engine',
      backgroundColor: const Color(0xFF062A3A),
      textColor: Colors.white,
      switchColor: const Color(0xFF062A3A),
      switchBallColor: const Color(0xFF346977),
    ),
    CardItem(
      title: 'Climate',
      subtitle: 'Adjust the climate settings',
      backgroundColor: const Color(0xFF00E5F9),
      textColor: Colors.black,
      switchColor: const Color(0xFF00E5F9),
      switchBallColor: const Color(0xFF030F1B),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      //  Color.fromARGB(255, 17, 98, 129),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () async {
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
                )),
          ),
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  // 'assets/photo_2023-09-23_19-49-27.jpg',
                  // 'assets/photo_2023-09-23_19-49-23.jpg',
                  // 'assets/photo_2023-09-23_19-49-00.jpg',
                  // 'assets/photo_2023-09-25_04-33-24.jpg',
                  'assets/istockphoto-1406257864-612x612.jpg',
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.blue,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: CardWidget(cardItems: cardItems)),
          ),
        ],
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
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
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
          icon: Icons.car_crash_sharp,
          text: 'My Car',
        )
      ],
    );
  }
}
