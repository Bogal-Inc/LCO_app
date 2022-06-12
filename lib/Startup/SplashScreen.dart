import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lightcutoff/Authentication/Authentication.dart';
import 'package:lightcutoff/Startup/Onboarding.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initStateFunction() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _skipOnboarding = prefs.getBool("skipOnboarding");

    Timer(const Duration(seconds: 1), () {
      if (_skipOnboarding != null) {
        Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 700),
          child: const Authentication(),
        ));
      } else {
        Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 700),
          child: const Onboarding(),
        ));
      }
    });
  }

  @override
  void initState() {
    initStateFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        "assets/images/splash_screen.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
