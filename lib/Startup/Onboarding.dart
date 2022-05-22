import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../Authentication/Authentication.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      isTopSafeArea: true,
      pages: listPagesViewModel,
      onDone: () {
        /// TODO: set onboarding pref as true
        Navigator.of(context).pushReplacement(
            PageTransition(
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500),
              child: const Authentication(),
            )
        );
      },
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      next: const Icon(Icons.keyboard_arrow_right_outlined),
      done: const Text('Done', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 18)),
      curve: Curves.fastLinearToSlowEaseIn,
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(30.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}


const pageDecoration = PageDecoration(
  titleTextStyle: TextStyle(color: Colors.black87, fontSize: 28.0, fontWeight: FontWeight.w700),
  contentMargin: EdgeInsets.symmetric(vertical: 28.0, horizontal: 12.0),
  titlePadding: EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
  bodyPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  imagePadding: EdgeInsets.fromLTRB(16.0, 50, 16, 16),
);


List<PageViewModel> listPagesViewModel = [
  PageViewModel(
    title: "On coupe, Je signale",
    body: "Here will be kept the description of the page, to explain something...",
    image: Center(child: Image.asset("assets/images/onboarding_1.png")),
    decoration: pageDecoration,
  ),
  PageViewModel(
    title: "Vos coupures, Localisez les",
    body: "Here you can write the description of the page, to explain something...",
    image: Center(child: Image.asset("assets/images/onboarding_2.png")),
    decoration: pageDecoration,
  ),
  PageViewModel(
    title: "En cas de coupure, je me déplace",
    body: "Here you can write the description of the page, to explain something...",
    image: Center(child: Image.asset("assets/images/onboarding_3.png")),
    decoration: pageDecoration,
  ),
];
