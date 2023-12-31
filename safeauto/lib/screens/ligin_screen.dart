import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeauto/screens/finger_print_screen.dart';
import 'package:safeauto/screens/home_screen.dart';
import 'package:safeauto/screens/register_screen.dart';
import 'package:safeauto/widget/google_container.dart';
import 'package:safeauto/widget/text_button.dart';
import 'package:safeauto/widget/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showEmailError = false;
  bool showPasswordError = false;

  @override
  void initState() {
    super.initState();
    // Sign out when the app starts
    _auth.signOut();
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'SAFEAUTO APP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lato",
                      ),
                    ),
                  ),
                  const SizedBox(height: 64.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Lato",
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
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
                      if (showEmailError && (value == null || value.isEmpty)) {
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
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          final UserCredential authResult =
                              await _auth.signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text);
                          final User? user = authResult.user;

                          // Print the user information for debugging
                          print('User Info: $user');

                          // Check if the user has registered with email/password
                          if (user != null &&
                              user.providerData.any((userInfo) =>
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid email or password.'),
                              ),
                            );
                          }
                        } catch (error) {
                          print('Email/password authentication failed: $error');
                          // Handle authentication failure, show an error message if needed
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid email or password.'),
                            ),
                          );
                        }
                      }
                    },
                    buttonColor: Color.fromARGB(255, 64, 248, 255),
                    buttonText: "LOGIN",
                    fontFamily: "Lato",
                    fontSize: 24,
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
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 16,
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
                    onTap: () async {
                      // Google Sign-In logic
                      try {
                        final GoogleSignInAccount? googleUser =
                            await googleSignIn.signIn();
                        final GoogleSignInAuthentication googleAuth =
                            await googleUser!.authentication;
                        final AuthCredential credential =
                            GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        final UserCredential authResult =
                            await _auth.signInWithCredential(credential);
                        final User? user = authResult.user;

                        print(
                            'Google authentication successful: ${user?.displayName}');

                        // Navigate to the home screen or perform other actions as needed
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FingerPrint(),
                          ),
                        );
                      } catch (error) {
                        print('Google authentication failed: $error');
                        // Handle authentication failure, show an error message if needed
                      }
                    },
                    child: googleContainer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
