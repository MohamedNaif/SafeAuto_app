import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../location/location.dart';
import '../../message/message_screen.dart';
import '../../trusted/user_profile.dart';
import '../home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
 

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return GNav(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      color: Colors.white,
      activeColor: const Color.fromARGB(255, 17, 97, 129),
      tabBackgroundColor: Colors.white,
      gap: 0,

      // onTabChange: (index) {
      //   if (index == 1) {
      //     LocationScreen();
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(
      //     //     builder: (context) => LocationScreen(),
      //     //   ),
      //     // );
      //   }
      //   if (index == 2) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ChatScreen(),
      //       ),
      //     );
      //   }
      //   if (index == 3) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => UserProfileScreen(),
      //       ),
      //     );
      //   }

      //   print(index);
      // },
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
    );
  }
}
