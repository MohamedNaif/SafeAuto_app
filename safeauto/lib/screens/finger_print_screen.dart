import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:safeauto/screens/home_screen.dart';

import '../auth/login_screen.dart'; // Import your home screen file

class FingerPrint extends StatefulWidget {
  const FingerPrint({Key? key});

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  bool isBiometric = false;

  Future<bool> authntificateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final bool isBiometricSupported =
        await localAuthentication.isDeviceSupported();
    final bool canCheckBiometric = await localAuthentication.canCheckBiometrics;

    bool isAuthentficated = false;

    if (isBiometricSupported && canCheckBiometric) {
      isAuthentficated = await localAuthentication.authenticate(
          localizedReason: 'Please complete the biometrics to proceed');
    }
    return isAuthentficated;
  }

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
              onTap: () async {
                isBiometric = await authntificateWithBiometrics();

                if(isBiometric){
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      // FirebaseAuth.instance.currentUser == null
                      //                   ? LoginScreen()
                      //                   : HomePage()
                          HomePage()), // Replace with your home screen widget
                );
                }
                // Navigate to the home screen
                
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
