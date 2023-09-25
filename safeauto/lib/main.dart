import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safeauto/screens/onboarding_screen.dart';
import 'package:safeauto/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/cubit/cubit/onboarding_cubit.dart';

void main() {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // initScreen = (prefs.getInt('onBoard'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingControllerCubit>(
            create: (BuildContext context) => OnBoardingControllerCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
