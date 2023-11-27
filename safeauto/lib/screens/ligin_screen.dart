import 'package:flutter/material.dart';
import 'package:safeauto/api/finger_api.dart';
import 'package:safeauto/screens/home_screen.dart';
import 'package:safeauto/screens/register_screen.dart';
import 'package:safeauto/widget/text_button.dart';
import 'package:safeauto/widget/textformfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool authenticated = false;
  bool showEmailError = false;
  bool showPasswordError = false;

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
                  const Spacer(),
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
                  const SizedBox(height: 32.0),
                  MyTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (showEmailError && (value == null || value.isEmpty)) {
                        return 'Please enter your email.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  MyTextFormField(
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
                  const SizedBox(height: 32.0),
                  InkWell(
                    onTap: () async {
                      // Validate the form
                      {
                        // Use fingerprint authentication
                        bool isAuthenticate = await LocalAuthApi.authenticate();
                        setState(() {
                          authenticated = isAuthenticate;
                        });

                        print('can auth $authenticated');

                        if (authenticated) {
                          // Fingerprint authentication successful, proceed with login logic
                          // For example, you can navigate to the home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } else {
                          // Fingerprint authentication failed, show an error message if needed
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Fingerprint authentication failed.'),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 64, 248, 255),
                          width: 1.6,
                        ),
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 50,
                        color: Color.fromARGB(255, 64, 248, 255),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  MyInkWellButton(
                    onTap: () {},
                    buttonColor: Color.fromARGB(255, 64, 248, 255),
                    buttonText: "LOGIN",
                    fontFamily: "Lato",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5.0),
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
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell button(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          showEmailError = true;
          showPasswordError = true;
        });
        if (_formKey.currentState?.validate() ?? false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          // Proceed with the form submission logic
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 64, 248, 255),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Get Started",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Lato",
            ),
          ),
        ),
      ),
    );
  }
}
