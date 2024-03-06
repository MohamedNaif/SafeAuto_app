import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:safeauto/screens/finger_print_screen.dart';
import 'package:safeauto/auth/login_screen.dart';
import 'package:safeauto/auth/widget/text_button.dart';
import 'package:safeauto/auth/widget/textformfield.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController userName = TextEditingController();

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showEmailError = false;

  bool showPasswordError = false;

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      body: SingleChildScrollView(
        child: Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                        height: 1.h,
                        width: 100.w,
                        child: Image(
                          image: AssetImage(
                              'assets/SafeAuto-without-Background.png'),
                        ),
                      ),
                      const SizedBox(height: 64.0),
                       Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
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
                            Icons.person,
                            color: Color.fromARGB(255, 64, 248, 255),
                          ),
                        ),
                        controller: userName,
                        labelText: 'User Name',
                        validator: (value) {
                          if (showEmailError &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter your Name.';
                          }
                          return null;
                        },
                      ),
                      MyTextFormField(
                        icons: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 64, 248, 255),
                          ),
                        ),
                        controller: emailController,
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

                          if (_formKey.currentState!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: _passwordController.text,
                              );

                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              String errorMessage = 'An error occurred';
                              if (e.code == 'weak-password') {
                                errorMessage =
                                    'The password provided is too weak.';
                              } else if (e.code == 'email-already-in-use') {
                                errorMessage =
                                    'The account already exists for that email.';
                              } else {
                                errorMessage = e.message ?? 'An error occurred';
                              }

                              showAwesomeDialog(errorMessage);
                            }
                          }

                          
                        },
                        buttonColor: Color.fromARGB(255, 64, 248, 255),
                        buttonText: "Sign Up",
                        fontFamily: "Lato",
                        fontSize: 24.sp,
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
                            child:  Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16.sp,
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
