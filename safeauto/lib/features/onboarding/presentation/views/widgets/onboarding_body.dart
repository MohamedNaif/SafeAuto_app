import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:safeauto/core/utils/asstes.dart';
import 'package:safeauto/features/onboarding/presentation/views/widgets/onboarding_style.dart';


import '../../../../../auth/finger_print_screen.dart';
import '../../../../../auth/login_screen.dart';
import '../../../../../auth/widget/text_button.dart';
import 'custom_smoothpage_indicator.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  final PageController _controller = PageController();

  final List<String> onBoardingTitle = [
    'Welcome to our SafeAuto App!',
    'Secure Access with Fingerprint Verification',
    'Effortless Access for Trusted Individuals',
  ];

  final List<String> onBoardingLottie = [
    AssetsManager.onboarding1Image,
    AssetsManager.onboarding2Image,
    AssetsManager.onboarding3Image,
  ];

  final List<String> onBoardingSubtitle = [
    'Experience advanced car management with CarGuard. Control access, track location, and receive real-time alerts for ultimate security and convenience.',
    'Unlock your car with a simple fingerprint scan. Enjoy secure and hassle-free authentication with CarGuard.',
    'Grant seamless access to trusted individuals. CarGuard recognizes trusted persons, ensuring convenient and secure car access.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsManager.onboardingBackground),
                fit: BoxFit.cover)),
        child: Container(
          color: Color.fromARGB(213, 36, 37, 57),
          child: Column(
            children: [
              Onboardingstyle(
                  controller: _controller,
                  onBoardingTitle: onBoardingTitle,
                  onBoardingLottie: onBoardingLottie,
                  onBoardingSubtitle: onBoardingSubtitle),
              CustomSmoothPageIndicator(
                  controller: _controller, onBoardingTitle: onBoardingTitle),
              MyInkWellButton(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FirebaseAuth.instance.currentUser == null &&
                                      (FirebaseAuth.instance.currentUser
                                                  ?.emailVerified ==
                                              false ||
                                          FirebaseAuth.instance.currentUser
                                                  ?.emailVerified ==
                                              null)
                                  ? LoginScreen()
                                  : FingerPrint()));
                },
                buttonColor: Color.fromARGB(255, 64, 248, 255),
                buttonText: "Get Started",
                fontFamily: "Lato",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

