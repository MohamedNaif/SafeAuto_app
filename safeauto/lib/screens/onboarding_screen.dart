import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safeauto/auth/login_screen.dart';
import 'package:safeauto/auth/widget/text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/cubit/cubit/onboarding_cubit.dart';
import '../auth/finger_print_screen.dart';
// import 'home_screen.dart';
import 'package:lottie/lottie.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  final int pageNum = 3;
  List<String> onBoardingTitle = [
    'Welcome to our SafeAuto App!',
    'Welcome to our SafeAuto App!',
    'Secure Access with Fingerprint Verification',
    "Effortless Access for Trusted Individuals",
    "Effortless Access for Trusted Individuals",
  ];
  List<String> onBoardingLOttie = [
    'assets/animation_lmhtant5.json',
    'assets/animation_lmhtant5.json',
    'assets/animation_lmht68ka.json',
    'assets/animation_lmhtax6o.json',
    'assets/animation_lmhtax6o.json',
  ];
  List<String> onBoardingSubtitle = [
    '                     ',
    "Experience advanced car management with CarGuard. Control access, track location, and receive real-time alerts for ultimate security and convenience.",
    "Unlock your car with a simple fingerprint scan. Enjoy secure and hassle-free authentication with CarGuard.",
    "Grant seamless access to trusted individuals. CarGuard recognizes trusted persons, ensuring convenient and secure car access.",
    '        '
  ];

  PageController _pageController = PageController(initialPage: 1);

  Timer? _timer;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < pageNum + 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        // If last page is reached, go to the first page
        _currentPage = 1;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 900),
          curve: Curves.ease,
        );
      }
    });
  }

  _storeOnBoardingInfo() async {
    int initScreen = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', initScreen);
  }

  @override
  Widget build(BuildContext context) {
    var screenH = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ville-kaisla-HNCSCpWrVJA-unsplash.jpg'),
              fit: BoxFit.cover)),
      child: Container(
        color: Color.fromARGB(213, 36, 37, 57),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenH * 2 / 3,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: 5,
                    onPageChanged: (i) {
                      if (i == pageNum + 1) {
                        _pageController.jumpToPage(1);
                        i = 1;
                      } else if (i == 0) {
                        _pageController.animateToPage(3,
                            duration: Duration(milliseconds: 70),
                            curve: Curves.easeIn);
                      }
                      _currentPage = i;
                      context.read<OnBoardingControllerCubit>().getIndex(i);
                    },
                    itemBuilder: (context, index) => Container(
                            // color: const Color.fromRGBO(24, 25, 40, 1),
                            child: Center(
                                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 200.h,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Lottie.asset(onBoardingLOttie[index])),
                            ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: Text(
                                  onBoardingTitle[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: Text(
                                  onBoardingSubtitle[index],
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 226, 220, 220),
                                    fontSize: 16.sp,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )))),
              ),
              Container(
                height: screenH / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<OnBoardingControllerCubit,
                        OnBoardingControllerState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                                3,
                                (indx) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      margin: const EdgeInsets.all(2.5),
                                      height: 6,
                                      width: context
                                                  .read<
                                                      OnBoardingControllerCubit>()
                                                  .currentIndex ==
                                              indx + 1
                                          ? 20
                                          : 6,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ))
                          ],
                        );
                      },
                    ),
                    MyInkWellButton(
                      onTap: () async {
                        await _storeOnBoardingInfo();
                        // final prefs = await SharedPreferences.getInstance();
                        // prefs.setBool('showHome', true);

                        // setOnboardingShown();
                        _timer?.cancel();
                        // context.read<CountriesCubit>().getCountriesDate();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FirebaseAuth.instance.currentUser == null &&
                                            (FirebaseAuth.instance.currentUser
                                                        ?.emailVerified ==
                                                    false ||
                                                FirebaseAuth
                                                        .instance
                                                        .currentUser
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
                    //
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    )));
  }
}
