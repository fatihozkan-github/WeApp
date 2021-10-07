import 'dart:typed_data';

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
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
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

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    readData();
  }

  void setCustomMapPin() async {
    pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/heroStationIcon.png');
  }

  int latitude;
  final databaseReference = FirebaseDatabase.instance.reference();
  void readData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      coordinates.add(snapshot.value["3566"]["Location"]["latitude"]);
      coordinates.add(snapshot.value["3566"]["Location"]["longtitude"]);
      fullness = snapshot.value["3566"]["FULLNESS"];
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/heroStationIcon.png', 100);
    // final recycleBins = await locations.getHeroStations();
    setState(() {
      print(fullness.toString());
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("HeroStation"),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: LatLng(coordinates[0], coordinates[1]),
        infoWindow: InfoWindow(
          title: "HeroStation",
          snippet: "%" + fullness.toString() + " dolu",
        ),
      );
      _markers["HeroStation"] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "HeroStation",
            style: TextStyle(fontFamily: "Montserrat_Alternates", fontSize: 24),
          ),
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
              child: Image.asset("assets/Icons/eventrequestwhite.png", scale: 1.1),
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
      ),
    );
  }
}
