/// This is the Profile Page
/// It is here that the user modifies the settings relative to his app usage
/// and also the general settings
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  static const _txtCustomHead = TextStyle(
    color: Colors.white,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///App Bar, same like all the other tabs
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Paramètres",
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(90, 144, 53, 1),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///Settings set 1
            Setting(
              head: "Compte",
              sub1: "Information générale",
              sub1fxn: () {},
              sub2: "Changer mot de passe",
              sub2fxn: () {},
              sub3: "Paiement",
              sub3fxn: () {},
            ),

            ///Settings set 2
            Setting(
              head: "Paramètres",
              sub1: "Langue",
              sub1fxn: () {},
              sub2: "Confidentialité",
              sub2fxn: () {},
              /*sub3: DemoLocalizations.of(context).security,
              sub3fxn: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Security()),
                );
              },*/
            ),

            ///Settings set 3
            /*setting(
              head: DemoLocalizations.of(context).preferences,
              /*sub1: DemoLocalizations.of(context).accountActivity,
              sub1fxn: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AccountActivity()),
                );
              },*/
              sub1: DemoLocalizations.of(context).launchRecordingMode,
              sub1fxn: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LaunchRecordingMode()),
                );
              },
              /*sub2: DemoLocalizations.of(context).opportunity,
              sub2fxn: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Opportunity()),
                );
              },*/
            ),*/
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => AuthPage()),
                  );*/
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    color: Colors.redAccent.withOpacity(0.75),
                    child: const Padding(
                      padding:
                      EdgeInsets.only(top: 13.0, left: 20.0, bottom: 15.0),
                      child: Center(
                        child: Text(
                          "Déconnexion",
                          style: _txtCustomHead,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  static const _txtCustomHead = TextStyle(
    color: Color.fromRGBO(90, 144, 53, 1),
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static const _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  String head;
  String? sub1, sub2, sub3;
  VoidCallback? sub1fxn, sub2fxn, sub3fxn;

  Setting({
    required this.head,
    this.sub1,
    this.sub1fxn,
    this.sub2,
    this.sub2fxn,
    this.sub3,
    this.sub3fxn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        //height: sub3 != null ? 230.0 : sub2 != null ? 170 : 105 ,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                child: Text(
                  head,
                  style: _txtCustomHead,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ),
              sub1 != null ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: InkWell(
                  onTap: sub1fxn,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          sub1??"text",
                          style: _txtCustomSub,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ]),
                ),
              ) : Container(),

              sub1 != null ?
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ) : Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(),
              ),

              sub2 != null ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: InkWell(
                  onTap: sub2fxn,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          sub2??"",
                          style: _txtCustomSub,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ]),
                ),
              ):Container(),

              sub2 != null ?
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ):Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(),
              ),

              sub3 != null ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: InkWell(
                  onTap: sub3fxn,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          sub3??"",
                          style: _txtCustomSub,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black38,
                        )
                      ]),
                ),
              ):Container(),

              sub3 != null ?
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ):Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
