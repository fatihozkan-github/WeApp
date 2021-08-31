import 'dart:async';
import 'package:WE/Resources/components/or_divider.dart';
import 'package:WE/Screens/BottomNavigation/QR/new_qr_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/pin_code.dart';
import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WE/Resources/constants.dart';
import 'package:nice_button/nice_button.dart';
import 'package:WE/Screens/BottomNavigation/QR/instructions.dart';
import 'package:WE/Screens/BottomNavigation/QR/coin_screen.dart';

class QRScanPage extends StatefulWidget {
  @override
  QRScanPageState createState() {
    return QRScanPageState();
  }
}

final databaseReference = FirebaseDatabase.instance.reference();

class QRScanPageState extends State<QRScanPage> {
  static String result;

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "QR",
          style: TextStyle(fontFamily: "Panthera", fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "Seni burada gördüğümüze sevindik. Başlamadan önce gözden geçirmeni istediğimiz bir liste var.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              "Talimatlar",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            SizedBox(height: size.height * 0.02),
            Column(children: [
              Container(
                child: CarouselSlider(
                  items: instructionItems,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: instructions.map((url) {
                  int index = instructions.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? kPrimaryColor : Colors.grey),
                  );
                }).toList(),
              ),
            ]),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NiceButton(
                    width: 150,
                    radius: 10,
                    text: "QR",
                    icon: Icons.qr_code_rounded,
                    gradientColors: [Color(0xFFff4d00), Color(0xFFff9a00)],
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QRViewExample(),
                      ));
                    },
                    background: kSecondaryColor,
                  ),
                  // NiceButton(
                  //                     width: 150,
                  //                     radius: 10,
                  //                     text: "PIN",
                  //                     icon: Icons.add_to_home_screen_rounded,
                  //                     gradientColors: [Color(0xFFff4d00), Color(0xFFff9a00)],
                  //                     onPressed: () {
                  //                       Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                           builder: (context) {
                  //                             return PinCodeVerificationScreen();
                  //                           },
                  //                         ),
                  //                       );
                  //                     },
                  //                     background: kSecondaryColor,
                  //                   ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
