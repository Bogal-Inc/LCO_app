import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../test.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String myLocation = "Appuyez le bouton pour obtenir votre position";
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Carte', style: TextStyle(color: Colors.black),),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 700),
                      child: editProfile(),
                    )
                );
              },
            ),
            ListTile(
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: LatLng(3.9853783,9.8015108), zoom: 15),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () async {
                      Position? location = await _determinePosition().then((value) {
                        setState(() {
                          myLocation = "My location " + (value == null ? "Could not be gotten": " is ${value.latitude} : ${value.longitude}");
                          mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 14.4),));
                        });
                        return null;
                      });
                    },
                    child: const Text("Get My Location"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              builder: (context){
                DateTime date = DateTime.now();

                return Column(
                    children: [
                      const SizedBox(height: 20.0,),
                      const Text("Signaler une Coupure", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.8),),
                      Text("${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}", style: const TextStyle(fontSize: 16),),
                      const SizedBox(height: 20.0,),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Divider(height: 2.0, thickness: 2.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Changer"),
                          TextButton(
                            onPressed: () async {
                              TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(date));
                              if (time!=null){

                              }
                            },
                            child: const Text("l'heure", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                          ),
                          const Text("ou"),
                          TextButton(
                            onPressed: (){
                              showDatePicker(context: context, initialDate: date, firstDate: date.subtract(const Duration(days: 5)), lastDate: date);
                            },
                            child: const Text("la Date", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                          ),
                        ],
                      ),

                      Container(
                        color: Colors.amber,
                        height: 200,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: const GoogleMap(
                          zoomControlsEnabled: false,
                          compassEnabled: true,
                          mapToolbarEnabled: true,
                          initialCameraPosition: CameraPosition(target: LatLng(3.9853783,9.8015108), zoom: 15),
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      ElevatedButton(
                        onPressed: (){
                          /// Handle Signalisation
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                          child: Text("Signale", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.8)),
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      const Text("Annuler", style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),),

                    ],
                  );
              },
          );

        },
        label: const Text('Signaler une coupure', style: TextStyle(color: Colors.black),),
        icon: const Icon(Icons.flash_on_sharp, color: Colors.black,),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.

    Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
