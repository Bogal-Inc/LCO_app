import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightcutoff/Authentication/SignIn.dart';
import 'package:lightcutoff/Authentication/SignUp.dart';
import 'package:lightcutoff/Screens/Home.dart';

import '../test.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("There was a error getting the authenication state"));
        }
        else{
          if (!(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)){
            return const Center(child: Text("Connecting to the servers..."));

          }
          else{
            User? user = snapshot.data as User?;

            if (user == null){
              return const Auth();
            }

            else{
              return const Home();
            }

          }
        }
      },
    );
  }
}

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  DateTime? _lastQuitTime;
  late AnimationController _controller;
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastQuitTime == null ||
            DateTime.now().difference(_lastQuitTime!).inSeconds > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Appuyez encore pour sortir")),
          );
          _lastQuitTime = DateTime.now();
          return false;
        } else {
          await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          return true;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomPaint(
              painter: BackgroundPainter(
                //animation: _controller,
              ),
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            ),
            ValueListenableBuilder(
              valueListenable: showSignInPage,
              builder: (BuildContext context, bool value, Widget? child) {
                return SizedBox.expand(
                  child: PageTransitionSwitcher(
                    reverse: !value,
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (child, animation, secondaryAnimation){
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                    child: value
                        ? SignIn(goToSignUp: (){
                      showSignInPage.value = false;
                      _controller.forward();
                    })
                        : SignUp(goToSignIn: (){
                      showSignInPage.value = true;
                      _controller.reverse();
                    }),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}


class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}


class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, size.height / 3);
    path.lineTo(size.width * 0.6, size.height / 3);
    //path.arcTo(Rect.fromLTRB(50, 100, 250, size.height * 0.7), 0.175, 0.349, false);
    path.lineTo(size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

