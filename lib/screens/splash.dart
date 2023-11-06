// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/main.dart';
import 'package:taskmate/screens/home/home_screen.dart';
import 'package:taskmate/screens/onboarding/on_boarding1.dart';

class Splash extends StatefulWidget {
  const Splash({super.key}); 

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    checkLogin(context); // Check login status when the splash screen is initialized.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/images/splash-removebg-preview.png')
              .animate()
              .slideY(duration: const Duration(milliseconds: 400), curve: Curves.easeIn)
              .rotate(duration: const Duration(milliseconds: 500)), // Display the splash image with animations.
        ),
      ),
    );
  }
}

// Function to check the login status.
Future<void> checkLogin(context) async {
  
  final _sharedPrefs = await SharedPreferences.getInstance();
  final _userLoggedIn = _sharedPrefs.getBool(SAVE_KEY);

  if (_userLoggedIn == true) {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds.
    Get.off(() => const Home(),
        transition: Transition.cupertinoDialog,
        duration: const Duration(milliseconds: 600)); // Navigate to the Home screen.
  } else {
    gotoOnboarding(context); // If not logged in, go to the onboarding screen.
  }
}

  // Function to navigate to the onboarding screen.
Future<void> gotoOnboarding(context) async {

  await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds.
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding(),)); // Navigate to the OnBoarding screen.
}
