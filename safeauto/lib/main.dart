import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:safeauto/message/firebase_real_data.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'data/cubit/cubit/onboarding_cubit.dart';
import 'home/home_screen.dart';
import 'notification/notification.dart';
import 'notification/notification_service.dart';
import 'screens/splash_screen.dart';
import 'location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initializeNotification();
  await NotificationService.setupFirestoreListener();

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

    // NotificationScrren();

    super.initState();
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnBoardingControllerCubit>(
          create: (BuildContext context) => OnBoardingControllerCubit(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          // Use builder only if you need to use library outside ScreenUtilInit context
          builder: (_, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              home:
                  // HomeScreen()

                  SplashScreen(),
              // NotificationScrren(),

              //     AddUser(
              //   fullName: '',
              //   company: '',
              //   age: 19,
              // ),
            );
          }),
    );
  }
}
