import 'package:flutter/material.dart';
import 'package:safeauto/api/finger_api.dart';
import 'package:safeauto/screens/home_screen.dart';
import 'package:safeauto/screens/ligin_screen.dart';
import 'package:safeauto/widget/text_button.dart';
import 'package:safeauto/widget/textformfield.dart';

// TextEditingController userNameTextEditingControllrt =
//     TextEditingController(); // global

// final String myNAme = "Mohamed";

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool authenticated = false;
  bool showEmailError = false;
  bool showPasswordError = false;

  RegisterScreen({super.key});

  final _loginFormKey = GlobalKey<FormState>();

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
                    child:
                        //Image(image: AssetImage(assetName))

                        Image.asset(
                      "assets/istockphoto-1406257864-612x612.jpg",
                      // height: MediaQuery.of(context).size.width * 0.5,
                      // width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  )),
            ),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: MediaQuery.of(context).size.height * 2 / 3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color:
                      // const Color(0xff030A10),
                      Color.fromARGB(255, 8, 9, 11),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Form(
                key: _loginFormKey,
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
                        )),
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
                        )),

                    const SizedBox(height: 20.0),
                    MyTextFormField(
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
                    // const SizedBox(height: 16.0),
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
                    // const SizedBox(height: 15.0),
                    InkWell(
                      onTap: () async {
                        // Use fingerprint authentication
                        bool isAuthenticated =
                            await LocalAuthApi.authenticate();
                        print('can auth $isAuthenticated');

                        if (isAuthenticated) {
                          // Fingerprint authentication successful, proceed with login logic
                          // For example, you can navigate to the home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
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
                      },
                      child: const Icon(
                        Icons.fingerprint,
                        size: 50,
                        color: Color.fromARGB(255, 64, 248, 255),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    // const Spacer(),
                    MyInkWellButton(
                      onTap: () {},
                      buttonColor: Color.fromARGB(255, 64, 248, 255),
                      buttonText: "Get Started",
                      fontFamily: "Lato",
                      fontSize: 18,
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
            // Positioned(
            //   bottom: MediaQuery.of(context).size.height * 0.75,
            //   left: 100,
            //   child: Container(
            //     height: 100,
            //     width: 100,
            //     color: Colors.red,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
