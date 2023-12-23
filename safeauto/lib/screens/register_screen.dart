import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeauto/screens/finger_print_screen.dart';
import 'package:safeauto/screens/ligin_screen.dart';
import 'package:safeauto/widget/text_button.dart';
import 'package:safeauto/widget/textformfield.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool showEmailError = false;

  bool showPasswordError = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 1 / 12,
                      left: 20,
                      right: 20,
                      top: MediaQuery.of(context).size.height * 1 / 12),
                  child: Image.asset(
                    "assets/istockphoto-1406257864-612x612.jpg",
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: MediaQuery.of(context).size.height * 2 / 3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 8, 9, 11),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Align(
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 1,
                      width: 100,
                      child: Image(
                        image: AssetImage(
                            'assets/SafeAuto-without-Background.png'),
                      ),
                    ),
                    const SizedBox(height: 64.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Lato",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    MyTextFormField(
                      icons: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 64, 248, 255),
                        ),
                      ),
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
                    MyTextFormField(
                      icons: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.key,
                          color: Color.fromARGB(255, 64, 248, 255),
                        ),
                      ),
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
                    const SizedBox(height: 30.0),
                    MyInkWellButton(
                      onTap: () async {
                        setState(() {
                          showEmailError = true;
                          showPasswordError = true;
                        });
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            // Check if the user already exists
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );

                            // Check if the user has registered with email/password
                            if (userCredential.user != null &&
                                userCredential.user!.providerData.any(
                                    (userInfo) =>
                                        userInfo.providerId == "password")) {
                              // User has registered with email/password
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FingerPrint(),
                                ),
                              );
                            } else {
                              // User did not register with email/password
                              await FirebaseAuth.instance.currentUser?.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Registration failed. Please use email/password registration.'),
                                ),
                              );
                            }
                          } catch (error) {
                            print('Email/password registration failed: $error');
                            // Handle registration failure, show an error message if needed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registration failed.'),
                              ),
                            );
                          }
                        }
                      },
                      buttonColor: Color.fromARGB(255, 64, 248, 255),
                      buttonText: "Sign Up",
                      fontFamily: "Lato",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen())),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 64, 248, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
