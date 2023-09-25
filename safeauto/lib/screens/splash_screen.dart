import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeauto/screens/onboarding_screen.dart';

import 'home_screen.dart';

// int? initScreen;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  @override
  void initState() {
    super.initState();
    _appearController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _appearController.forward();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(
      const Duration(seconds: 5),
      () {
        // context.read<NewsAppCubit>().getNewsApp();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) =>
                // initScreen != 0 ? onBoardingScreen() : HomePage()
                onBoardingScreen()),
          ),
        );
        //================================================
        // if (MyApp().showHome == false) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: ((context) => ONBoardingScreen()),
        //     ),
        //   );
        // } else {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: ((context) => HomePage()),
        //     ),
        //   );
        // }
        //=================================================
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  // 'assets/olavh.jpg',
                  // 'assets/ville-kaisla-HNCSCpWrVJA-unsplash.jpg',
                  // 'assets/photo_2023-09-17_12-04-31.jpg',
                  // 'assets/photo_2023-09-17_12-05-01.jpg',
                  // 'assets/photo_2023-09-17_12-05-09.jpg',
                  // 'assets/photo_2023-09-17_12-05-15.jpg',
                  'assets/photo_2023-09-17_12-05-22.jpg',
                  // 'assets/photo_2023-09-17_12-05-28.jpg',
                ),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Container(
              color: Color.fromARGB(45, 69, 71, 142),
            ),
            FadeTransition(
              opacity: _appearController,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                      'assets/depositphotos_471071128-stock-illustration-atletico-madrid-blue-gradient-vector-removebg-preview.png'),
                )),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 250,
                    width: 300,
                    decoration: BoxDecoration(
                        // color: Colors.black,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/SafeAuto-without-Background.png'))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
