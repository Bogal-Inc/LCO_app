import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _showNewPasswordForm = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool oldPasswordVisible = true;
  bool newPasswordVisible = true;
  late AnimationController _animationController;

  void _handleOldPasswordCheck() {
    /// Check if old password is correct
    /// Re-authenticate the user
    /// Update showNewPassword value
  }

  void _handlePasswordChange() {
    /// Change password
    /// Notify the user
    /// Pop after 5 seconds
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Changer mot de passe",
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _showNewPasswordForm,
        builder: (BuildContext context, bool value, Widget? child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: !value
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Opacity(
                              opacity: 0.9,
                              child: Image(
                                image: AssetImage(
                                    "assets/images/old_password.png"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          const Text(
                            "Changer mot de passe",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          const Text(
                            "Veillez entrer votre ancien mot de passe",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Champ requis";
                                      } else if (value.length < 8) {
                                        return "Mot de passe trop court";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _oldPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    obscureText: oldPasswordVisible,
                                    obscuringCharacter: "*",
                                    decoration: InputDecoration(
                                        suffixIcon: (oldPasswordVisible
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    oldPasswordVisible = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.visibility_outlined))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    oldPasswordVisible = true;
                                                  });
                                                },
                                                icon: const Icon(Icons
                                                    .visibility_off_outlined))),
                                        contentPadding:
                                            const EdgeInsets.only(bottom: 3),
                                        labelText: "Ancien mot de passe",
                                        //hintText:DemoLocalizations.of(context).oldPassword,
                                        hintStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  User user =
                                      FirebaseAuth.instance.currentUser!;
                                  final cred = EmailAuthProvider.credential(
                                      email: user.email!,
                                      password: _oldPasswordController.text);
                                  user
                                      .reauthenticateWithCredential(cred)
                                      .then((value) => setState(() {
                                            _showNewPasswordForm.value = true;
                                          }))
                                      .onError((error, stackTrace) {
                                    _oldPasswordController.clear();
                                    if (error.toString().contains(
                                        "[firebase_auth/wrong-password]")) {
                                      showSnackBar(context,
                                          "Mauvais mot de passe", true);
                                    }
                                    showSnackBar(context,
                                        "une erreur s'est produit", true);
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Vérifier ancien mot de passe",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 7,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Opacity(
                              opacity: 0.9,
                              child: Image(
                                image: AssetImage(
                                    "assets/images/new_password.png"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          const Text(
                            "Changer mot de passe",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          const Text(
                            "Veillez entrer le nouveau mot de passe",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Champ requis";
                                      } else if (value.length < 8) {
                                        _newPasswordController.clear();
                                        return "Mot de passe trop court";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _newPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.next,
                                    obscureText: newPasswordVisible,
                                    obscuringCharacter: "*",
                                    decoration: InputDecoration(
                                        suffixIcon: (newPasswordVisible
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    newPasswordVisible = false;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.visibility_outlined))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    newPasswordVisible = true;
                                                  });
                                                },
                                                icon: const Icon(Icons
                                                    .visibility_off_outlined))),
                                        contentPadding:
                                            const EdgeInsets.only(bottom: 3),
                                        labelText: "Nouveau mot de passe",
                                        //hintText:DemoLocalizations.of(context).oldPassword,
                                        hintStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Champ requis";
                                      } else if (value.length < 8) {
                                        _confirmNewPasswordController.clear();
                                        return "Mot de passe trop court";
                                      } else if (_newPasswordController.text !=
                                          _confirmNewPasswordController.text) {
                                        _confirmNewPasswordController.clear();
                                        return "Les mots de passes ne correspondent pas";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _confirmNewPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    obscuringCharacter: "*",
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 3),
                                        labelText:
                                            "Confirmer nouveau mot de passe",
                                        //hintText:DemoLocalizations.of(context).oldPassword,
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  FirebaseAuth.instance.currentUser!
                                      .updatePassword(
                                          _newPasswordController.text)
                                      .then((value) {
                                    showSnackBar(context,
                                        "Mot de passe changer avec succès");
                                    _oldPasswordController.clear();
                                    _newPasswordController.clear();
                                    _confirmNewPasswordController.clear();
                                  }).onError((error, stackTrace) {
                                    showSnackBar(
                                        context,
                                        "Le mot de passe n'a pas pu être changé",
                                        true);
                                  });
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Changer mot de passe",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message, [bool? error]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:
          error != null ? Colors.redAccent : Colors.amber.withOpacity(0.6),
    ),
  );
}
