import 'package:flutter/material.dart';
import'package:lottie/lottie.dart';
import 'package:Recrutio/HOME/homescreen.dart';

class LottieAnimation extends StatefulWidget {
  const LottieAnimation({Key? key}) : super(key: key);

  @override
  State<LottieAnimation> createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()), // Navigate to the home page
      );
    });
    return Scaffold(
      body: Center(
        // Center the animation vertically and horizontally
        child: Container(
          alignment: Alignment.center,
          child: Lottie.asset(
            'lib/ANIMATION/1.json',
            height: 400,
            reverse: false,
            repeat: false,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
