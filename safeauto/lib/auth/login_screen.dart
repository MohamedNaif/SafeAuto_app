import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safeauto/auth/finger_print_screen.dart';
import 'package:safeauto/auth/register_screen.dart';
import 'package:safeauto/auth/widget/google_container.dart';
import 'package:safeauto/auth/widget/text_button.dart';
import 'package:safeauto/auth/widget/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showEmailError = false;
  bool showPasswordError = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FingerPrint(),
        ),
      );
    } catch (e) {
      print('======================Google authentication failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 3, 10, 16),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/ville-kaisla-HNCSCpWrVJA-unsplash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: const Color.fromARGB(213, 36, 37, 57),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Align(
                      alignment: Alignment.center,
                      child: Text(
                        'SAFEAUTO APP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Lato",
                        ),
                      ),
                    ),
                     SizedBox(height: 64.h),
                     Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Lato",
                        ),
                      ),
                    ),
                     SizedBox(height: 18.h),
                    MyTextFormField(
                      icons: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 64, 248, 255),
                          )),
                      controller: _emailController,
                      labelText: 'Email',
                      validator: (value) {
                        if (showEmailError &&
                            (value == null || value.isEmpty)) {
                          return 'Please enter your email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    MyTextFormField(
                      icons: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.key,
                            color: Color.fromARGB(255, 64, 248, 255),
                          )),
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (showPasswordError &&
                            (value == null || value.isEmpty)) {
                          return 'Please enter your password.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    const SizedBox(height: 6),
                    MyInkWellButton(
                      onTap: () async {
                        setState(() {
                          showEmailError = true;
                          showPasswordError = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            if (credential.user!.emailVerified) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FingerPrint(),
                                ),
                              );
                            } else {
                              showAwesomeDialog(
                                  'Verify Your Email And Return Login');
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMessage = 'An error occurred';
                            if (e.code == 'user-not-found') {
                              errorMessage = 'No user found for that email.';
                            } else if (e.code == 'wrong-password') {
                              errorMessage =
                                  'Wrong password provided for that user.';
                            } else {
                              errorMessage = e.message ?? 'An error occurred';
                            }
                            showAwesomeDialog(errorMessage);
                          }
                        }
                      },
                      buttonColor: Color.fromARGB(255, 64, 248, 255),
                      buttonText: "LOGIN",
                      fontFamily: "Lato",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          ),
                          child:  Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color.fromARGB(255, 64, 248, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0), // Added space
                    SizedBox(width: 8.0),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: googleContainer(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAwesomeDialog(String errorMessage) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: errorMessage,
    )..show();
  }
}
