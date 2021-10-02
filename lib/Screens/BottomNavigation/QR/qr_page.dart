// ignore_for_file: omit_local_variable_types

import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Screens/BottomNavigation/QR/bracelet_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/new_qr_page.dart';
import 'package:bubble/bubble.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/instructions.dart';
// class IconDt {
//   static const IconData bracelet = IconData(0xf523, fontFamily: 'Bracelet');
// //static const Icon bracelet2 = Icon();
//
// }

class QRScanPage extends StatefulWidget {
  @override
  QRScanPageState createState() {
    return QRScanPageState();
  }
}

final databaseReference = FirebaseDatabase.instance.reference();

class QRScanPageState extends State<QRScanPage> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HeroStation"), centerTitle: true, backgroundColor: kPrimaryColor),
      body: ListView(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              Expanded(child: Image.asset("assets/instruction.png", height: 220)),
              Expanded(
                child: Bubble(
                  margin: BubbleEdges.only(top: 10),
                  padding: BubbleEdges.all(12),
                  alignment: Alignment.topRight,
                  nip: BubbleNip.leftBottom,
                  color: kPrimaryColor,
                  child: Text('Hoş geldin kahraman!', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Lütfen dönüştürmeye başlamadan önce aşağıdaki görevleri tamamladığından emin ol!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 40),
          Column(
            children: [
              CarouselSlider(
                items: instructionItems,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    height: 125,
                    onPageChanged: (index, reason) => setState(() => _current = index)),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: instructions.map((url) {
                  int index = instructions.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? kPrimaryColor : Colors.grey),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedButton(
                showGradient: true,
                useCustomChild: true,
                constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                customChild: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.qr_code_rounded, color: Colors.white),
                    Text(
                      "TARAT",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample())),
              ),
              RoundedButton(
                showGradient: true,
                useCustomChild: true,
                constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                customChild: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "OKUT",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Container(width: 30, child: Image.asset("assets/Icons/bracelet.png", color: Colors.white)),
                  ],
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BraceletPage())),
              ),
            ],
          )
        ],
      ),
    );
  }
}

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
