import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lightcutoff/Models/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  final Function goToSignIn;
  const SignUp({Key? key, required this.goToSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = "No User";
  bool isLoading = false;
  bool passwordVisible = false;
  bool checkboxValue = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Color checkboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.black38;
  }

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
              flex: 2,
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
                    "Création de compte",
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
              child: SingleChildScrollView(
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
                            } else if (value.contains("@")) {
                              return "Email invalid";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.black, fontSize: 22),
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              hintStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                              hintText: "Nom d'utilisateur"),
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "error";
                            }/* else if (value.contains("@")) {
                              return "Email invalid";
                            }*/ else {
                              return null;
                            }
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.black, fontSize: 22),
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              hintStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                              hintText: 'Email'),
                        ),
                        const SizedBox(height: 12),

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
                          style: const TextStyle(color: Colors.black, fontSize: 22),
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
                              icon: const Icon(Icons.visibility_off_outlined),
                            )),
                            fillColor: Colors.transparent,
                            filled: true,
                            hintStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                            hintText: 'Mot de Passe',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs requis";
                            } else if (value.length < 8) {
                              return "Mot de passe trop court";
                            }
                            else if (value != passwordController.text){
                              passwordController.clear();
                              confirmPasswordController.clear();
                              return "Mot de passes pne correspondent pas";
                            }
                            else {
                              return null;
                            }
                          },
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !passwordVisible,
                          style: const TextStyle(color: Colors.black, fontSize: 22),
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
                              icon: const Icon(Icons.visibility_off_outlined),
                            )),
                            fillColor: Colors.transparent,
                            filled: true,
                            hintStyle:
                            const TextStyle(color: Colors.black, fontSize: 18),
                            hintText: 'Confirmez Mot de Passe',
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                  checkboxColor),
                              value: checkboxValue,
                              onChanged: (bool? value) {
                                setState(() {
                                  checkboxValue = value!;
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Accepté le ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    GestureDetector(
                                      child: const Text(
                                        "Contrat d'utilisation ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () async {
                                        if (await canLaunch(
                                            'https://admin.boncopbadcop.com/user-conditions')) {
                                          await launch(
                                            'https://admin.boncopbadcop.com/user-conditions',
                                            forceWebView: false,
                                            enableJavaScript: true,
                                          );
                                        } else {
                                          throw 'Could not launch https://admin.boncopbadcop.com/user-conditions';
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "et la ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    GestureDetector(
                                      child: const Text(
                                        "Politique de sécurité ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () async {
                                        if (await canLaunch(
                                            'https://admin.boncopbadcop.com/user-conditions')) {
                                          await launch(
                                            'https://admin.boncopbadcop.com/user-conditions',
                                            forceWebView: false,
                                            enableJavaScript: true,
                                          );
                                        } else {
                                          throw 'Could not launch https://admin.boncopbadcop.com/user-conditions';
                                        }
                                      },
                                    ),
                                    const Text(
                                      "de LightCutOff",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            InkWell(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 52,
                child: MaterialButton(
                  elevation: 26,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  onPressed: () async {
                    if (!checkboxValue) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vous devez accepter le contrat d'utilisation")),
                      );
                    } else {
                      if (!_formKey.currentState!.validate()) {
                        print("Form verification failed");
                      }
                      else {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                            .then((value){
                              value.user!.updateDisplayName(nameController.text);

                              FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(UserModel.getUserMap(DateTime.now()));
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Créer mon Compte',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
            InkWell(
              splashColor: Colors.white,
              onTap: () {
                widget.goToSignIn();
              },
              child: const Text(
                "retourner vers connexion",
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
