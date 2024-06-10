import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../auth/finger_print_screen.dart';
import '../../../../../core/utils/asstes.dart';
// import '../../../../../screens/onboarding_screen.dart';
import '../../../../onboarding/presentation/views/onboarding_view.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  @override
  void initState() {
    super.initState();
    _appearController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _appearController.forward();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => FirebaseAuth.instance.currentUser ==
                            null &&
                        (FirebaseAuth.instance.currentUser?.emailVerified ==
                                false ||
                            FirebaseAuth.instance.currentUser?.emailVerified ==
                                null)
                    ? OnboardingView()
                    : FingerPrint()));
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  AssetsManager.splashImage,
                ),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Container(
              color: Color.fromARGB(45, 69, 71, 142),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Container(
                    height: 250.h,
                    width: ScreenUtil().setWidth(300),
                    decoration: BoxDecoration(
                        // color: Colors.black,
                        image: DecorationImage(
                            image: AssetImage(AssetsManager.logoImage))),
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
