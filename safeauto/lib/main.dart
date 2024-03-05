import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:safeauto/message/firebase_real_data.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'data/cubit/cubit/onboarding_cubit.dart';
import 'home/home_screen.dart';
import 'screens/splash_screen.dart';
import 'location/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // initScreen = (prefs.getInt('onBoard'));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '====================================User is currently signed out!');
      } else {
        print('=====================================User is signed in!');
      }
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingControllerCubit>(
          create: (BuildContext context) => OnBoardingControllerCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
        // HomeScreen()
        
         SplashScreen(),
        //     AddUser(
        //   fullName: '',
        //   company: '',
        //   age: 19,
        // ),
      ),
    );
  }
}
