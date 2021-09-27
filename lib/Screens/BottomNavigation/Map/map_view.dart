// ignore_for_file: omit_local_variable_types, prefer_single_quotes

import 'dart:typed_data';
import 'package:WE/Resources/components/we_spin.dart';
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
  bool isCompleted = false;

  void setCustomMapPin() async {
    pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/heroStationIcon.png');
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/heroStationIcon.png', 100);
    // final recycleBins = await locations.getHeroStations();
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("HeroStation"),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: LatLng(40.408418, 29.092993),
        infoWindow: InfoWindow(title: "HeroStation", snippet: "3566"),
      );
      _markers["HeroStation"] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();

    /// TODO - FIX ASAP
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => isCompleted = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("HeroStation", style: TextStyle(fontFamily: "Montserrat_Alternates", fontSize: 24)),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapFeedbackPage())),
            child: Image.asset("assets/Icons/eventrequestwhite.png", scale: 1.1),
          ),
          SizedBox(width: size.width * 0.01)
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: isCompleted
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: const LatLng(40.408418, 29.092993), zoom: 14),
              markers: _markers.values.toSet(),
            )
          : Center(child: WESpinKit()),
      // : Center(child: CircularProgressIndicator()),
    );
  }
}

//   MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: Scaffold(
//     appBar: AppBar(
//       title: Text("HeroStation", style: TextStyle(fontFamily: "Montserrat_Alternates", fontSize: 24)),
//       centerTitle: true,
//       actions: [
//         InkWell(
//           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapFeedbackPage())),
//           child: Image.asset("assets/Icons/eventrequestwhite.png", scale: 1.1),
//         ),
//         SizedBox(width: size.width * 0.01)
//       ],
//       backgroundColor: kPrimaryColor,
//     ),
//     body: GoogleMap(
//       onMapCreated: _onMapCreated,
//       initialCameraPosition: CameraPosition(target: const LatLng(40.408418, 29.092993), zoom: 14),
//       markers: _markers.values.toSet(),
//     ),
//   ),
// );
