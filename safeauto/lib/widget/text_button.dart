import 'package:flutter/material.dart';

class MyInkWellButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color buttonColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;

  const MyInkWellButton({
    Key? key,
    required this.onTap,
    this.buttonText = "Get Started",
    this.buttonColor = const Color.fromARGB(255, 64, 248, 255),
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = "Lato",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
