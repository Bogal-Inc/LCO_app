import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lightcutoff/Startup/Onboarding.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initStateFunction() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// TODO : Skip intro logic Here
  Timer(const Duration(seconds: 1), (){
    Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 700),
          child: const Onboarding(),
        )
    );
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
      body: Image.asset("assets/images/splash_screen.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
