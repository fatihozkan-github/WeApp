// ignore_for_file: omit_local_variable_types, prefer_single_quotes
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/Map/map_feedback.dart';
import 'package:WE/Services/locations_service.dart' as locations;

import 'dart:ui' as ui;

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  BitmapDescriptor pinLocationIcon;
  final Map<String, Marker> _markers = {};
  List coordinates = [];
  int fullness;
  int batteryPercent;
  bool isAdmin = false;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/heroStationIcon.png');
  }

  int latitude;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future readData() async {
    await databaseReference.once().then((DataSnapshot snapshot) {
      coordinates.add(snapshot.value["3566"]["Location"]["latitude"]);
      coordinates.add(snapshot.value["3566"]["Location"]["longtitude"]);
      fullness = (snapshot.value["3566"]["FULLNESS"] as int).round();
      batteryPercent =
          (snapshot.value["3566"]["BATTERY_CAPACITY"] as int).round();
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/heroStationIcon.png', 100);
    // final recycleBins = await locations.getHeroStations();
    await readData().whenComplete(() => setState(() {
          print(fullness.toString());
          _markers.clear();
          final marker = Marker(
            markerId: MarkerId("HeroStation"),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: LatLng(coordinates[0], coordinates[1]),
            infoWindow: isAdmin
                ? InfoWindow(
                    title: "HeroStation",
                    snippet:
                        "%${fullness.toString()} Dolu \n%$batteryPercent Şarj")
                : InfoWindow(
                    title: "HeroStation",
                    snippet: "%" + fullness.toString() + " Dolu "),
          );
          _markers["HeroStation"] = marker;
        }));
  }

  Future checkAdmin() async {
    final currentUid = FirebaseAuth.instance.currentUser.uid;
    if (currentUid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> value) {
        if (value.data().containsKey('admin')) {
          if (value.data()['admin'] == true) {
            isAdmin = true;
          }
        }
      });
    }
  }

  @override
  void initState() {
    checkAdmin();
    super.initState();
    setCustomMapPin();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("HeroStation"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MapFeedbackPage();
                  },
                ),
              );
            },
            child:
                Image.asset("assets/Icons/eventrequestwhite.png", scale: 1.1),
          ),
          SizedBox(
            width: size.width * 0.01,
          )
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: const LatLng(40.408418, 29.092993),
          zoom: 14,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}

///
// import 'dart:typed_data';
// import 'package:WE/Resources/components/we_spin_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:WE/Resources/constants.dart';
// import 'package:WE/Screens/BottomNavigation/Map/map_feedback.dart';
// import 'package:WE/Services/locations_service.dart' as locations;
// import 'dart:ui' as ui;
//
// Future<Uint8List> getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
// }
//
// class MapView extends StatefulWidget {
//   @override
//   _MapViewState createState() => _MapViewState();
// }
//
// class _MapViewState extends State<MapView> {
//   BitmapDescriptor pinLocationIcon;
//   final Map<String, Marker> _markers = {};
//   bool isCompleted = false;
//
//   void setCustomMapPin() async {
//     pinLocationIcon =
//         await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/heroStationIcon.png');
//     setState(() => isCompleted = true);
//   }
//
//   Future<void> _onMapCreated(GoogleMapController controller) async {
//     final Uint8List markerIcon = await getBytesFromAsset('assets/heroStationIcon.png', 100);
//     // final recycleBins = await locations.getHeroStations();
//     setState(() {
//       _markers.clear();
//       final marker = Marker(
//         markerId: MarkerId("HeroStation"),
//         icon: BitmapDescriptor.fromBytes(markerIcon),
//         position: LatLng(40.408418, 29.092993),
//         infoWindow: InfoWindow(title: "HeroStation", snippet: "3566"),
//       );
//       _markers["HeroStation"] = marker;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setCustomMapPin();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("HeroStation"),
//         centerTitle: true,
//         backgroundColor: kPrimaryColor,
//         actions: [
//           GestureDetector(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapFeedbackPage())),
//             child: Image.asset("assets/Icons/eventrequestwhite.png", scale: 1.1),
//           ),
//         ],
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(target: const LatLng(40.408418, 29.092993), zoom: 14),
//         markers: _markers.values.toSet(),
//       ),
//     );
//   }
// }

///
// return isCompleted
//     ? Scaffold(
//         appBar: AppBar(
//           title: Text("HeroStation", style: TextStyle(fontFamily: "Montserrat_Alternates", fontSize: 24)),
//           centerTitle: true,
//           actions: [
//             InkWell(
//               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapFeedbackPage())),
//               child: Image.asset("assets/Icons/eventrequestwhite.png", scale: 1.1),
//             ),
//             SizedBox(width: size.width * 0.01)
//           ],
//           backgroundColor: kPrimaryColor,
//         ),
//         body: isCompleted
//             ? GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(target: const LatLng(40.408418, 29.092993), zoom: 14),
//                 markers: _markers.values.toSet(),
//               )
//             : WESpinKit(),
//       )
//     : WESpinKit();
