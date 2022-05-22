import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lightcutoff/Models/UserModel.dart';
import 'package:twitter_login/twitter_login.dart';

class SignIn extends StatefulWidget {
  final Function goToSignUp;
  const SignIn({
    Key? key,
    required this.goToSignUp,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String name = "No User";
  bool isLoading = false;
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 30),

            ///Logo
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Card(
                      elevation: 40,
                      color: Colors.transparent,
                      child: Image.asset(
                        "assets/images/logo.png",
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Connexion",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),

            //Form
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "error";
                          } /*else if (value.contains("@")) {
                            return "Email invalid";
                          }*/ else {
                            return null;
                          }
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22),
                        decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            filled: true,
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            hintText: 'Email'),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champs requis";
                          } else if (value.length < 8) {
                            return "Mot de passe trop court";
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !passwordVisible,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 22),
                        decoration: InputDecoration(
                          suffixIcon: (!passwordVisible
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = true;
                                    });
                                  },
                                  icon: const Icon(Icons.visibility_outlined),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = false;
                                    });
                                  },
                                  icon:
                                      const Icon(Icons.visibility_off_outlined),
                                )),
                          fillColor: Colors.transparent,
                          filled: true,
                          hintStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          hintText: 'Mot de Passe',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Button
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  //Connection button
                  InkWell(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 52,
                      child: MaterialButton(
                        elevation: 6,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            print("Form verification failed");
                          } else {
                            FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                            }
                        },
                        child: const Text(
                          'Connexion',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    onPressed: () {
                      _handleSignInAnonymously();
                    },
                    child: const Text(
                      "Continuer sans se connecter",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),

                  //Divider
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              height: 5,
                              thickness: 5,
                            ),
                          ),
                        ),
                        Text("OU"),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              height: 5,
                              thickness: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Socials
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _handleSignInWithFacebook();
                        },
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Image.asset(
                            "assets/images/facebook_logo.png",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                      GestureDetector(
                        onTap: () {
                          _handleSignInWithGoogle();
                        },
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Image.asset(
                            "assets/images/google_logo.png",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 45),
                      GestureDetector(
                        onTap: () {
                          _handleSignInWithTwitter();
                        },
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: Image.asset(
                            "assets/images/twitter_logo.png",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            InkWell(
              splashColor: Colors.white,
              onTap: () {
                widget.goToSignUp();
              },
              child: const Text(
                "aller vers création de compte",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
/*return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("ID : $name"),
          ElevatedButton(
            onPressed: _handleSignInAnonymously,
            child: Row(
              children: const [
                //Image.asset("anonymous_icon.png"),
                Text("Sign In Anonymously"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _handleSignInWithGoogle,
            child: Row(
              children: const [
                //Image.asset("google_icon.png"),
                Text('Sign in with Google'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _handleSignInWithFacebook,
            child: Row(
              children: const [
                //Image.asset("facebook_icon.png"),
                Text('Sign in with Facebook'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _handleSignInWithTwitter,
            child: Row(
              children: const [
                //Image.asset("twitter_icon.png"),
                Text('Sign in with Twitter'),
              ],
            ),
          ),
        ],
      ),
    );*/

Future<void> _handleSignInAnonymously() async {
  FirebaseAuth.instance.signInAnonymously();
}

Future<void> _handleSignInWithGoogle() async {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  try {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      FirebaseAuth.instance.currentUser!.updateDisplayName(googleUser!.displayName);
      FirebaseAuth.instance.currentUser!.updatePhotoURL(googleUser.photoUrl);
      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(UserModel.getUserMap(DateTime.now()));
    });
  } catch (error) {
    print(error);
  }
}

Future<void> _handleSignInWithFacebook() async {
  final LoginResult result = await FacebookAuth.instance
      .login(); // by default we request the email and the public profile
  // or FacebookAuth.i.login()
  if (result.status == LoginStatus.success) {
    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(credential);

    // await _instance.getUserData().then((userData) async {
    //   await FirebaseAuth.instance.currentUser!.updateEmail(userData["email"]);
    // });

  } else {
    print(result.status);
    print(result.message);
  }
}

Future<void> _handleSignInWithTwitter() async {
  final twitterLogin = TwitterLogin(
    apiKey: 'xxxx',
    apiSecretKey: 'xxxx',
    redirectURI: 'lightcutoff://',
  );

  final authResult = await twitterLogin.login();
  switch (authResult.status) {
    case TwitterLoginStatus.loggedIn:
      final AuthCredential twitterAuthCredential =
          TwitterAuthProvider.credential(
              accessToken: authResult.authToken!,
              secret: authResult.authTokenSecret!);

      await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
      break;

    case TwitterLoginStatus.cancelledByUser:
      // cancel
      break;

    case TwitterLoginStatus.error:
      // error
      break;

    default:
      // unknown error
      break;
  }
}
