


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Onboardingstyle extends StatelessWidget {
  const Onboardingstyle({
    super.key,
    required PageController controller,
    required this.onBoardingTitle,
    required this.onBoardingLottie,
    required this.onBoardingSubtitle,
  }) : _controller = controller;

  final PageController _controller;
  final List<String> onBoardingTitle;
  final List<String> onBoardingLottie;
  final List<String> onBoardingSubtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _controller,
        itemCount: onBoardingTitle.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 200.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: Lottie.asset(onBoardingLottie[index])),
              SizedBox(height: 20.h),
              Text(
                onBoardingTitle[index],
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  onBoardingSubtitle[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}