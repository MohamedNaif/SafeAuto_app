
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    super.key,
    required PageController controller,
    required this.onBoardingTitle,
  }) : _controller = controller;

  final PageController _controller;
  final List<String> onBoardingTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SmoothPageIndicator(
        controller: _controller,
        count: onBoardingTitle.length,
        effect: WormEffect(
          dotHeight: 12,
          dotWidth: 12,
          spacing: 16,
          activeDotColor: Color.fromARGB(255, 64, 248, 255),
          dotColor: Colors.grey,
        ),
      ),
    );
  }
}
