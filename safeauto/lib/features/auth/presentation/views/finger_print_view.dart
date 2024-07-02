import 'package:flutter/material.dart';

import 'widgets/finger_print_body.dart';

class FingerPrintView extends StatelessWidget {
  const FingerPrintView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FingerPrintBody(),
    );
  }
}