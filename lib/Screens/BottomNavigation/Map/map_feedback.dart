import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:WE/Resources/constants.dart';

class MapFeedbackPage extends StatefulWidget {
  @override
  _MapFeedbackPageState createState() => _MapFeedbackPageState();
}

class _MapFeedbackPageState extends State<MapFeedbackPage> {
  final Geolocator geolocator = Geolocator();
  Position _currentPosition;
  String _currentAddress;
  String _infoMessage = "WE topluluğu ile birlikte alanı temizlemek için etkinlik düzenleme isteği gönderebilirsin";
  String _subject;
  String _message;
  final GlobalKey<FormState> _formKey = GlobalKey();

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor, title: Text('Etkinlik İsteği'), centerTitle: true),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: <Widget>[
            SizedBox(height: 40),
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    boxShadow: [BoxShadow(color: kPrimaryColor, offset: Offset(15, 15))],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Kirli Olduğunu Düşündüğün Bölgeyi Bize Bildir!',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(_infoMessage, style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            RoundedInputField(
              hintText: 'Konu',
              icon: Icons.mail_rounded,
              onChanged: (value) => setState(() => _subject = value),
            ),
            RoundedInputField(
              hintText: 'Mesajınız',
              icon: Icons.message,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              onChanged: (value) => setState(() => _message = value),
            ),
            SizedBox(height: 15),
            RoundedButton(
              text: 'Gönder',
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    launchUrl("mailto:we.recycle.team@gmail.com?subject=$_subject&body=$_message");
                  }
                });
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Old
//    Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 13),
//                 child: Text(
//                   "Şu anki konum: $_currentAddress",
//                   style:
//                       TextStyle(fontSize: 20, height: 1.3, color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
