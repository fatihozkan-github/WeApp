import 'dart:async';
import 'package:WE/Resources/components/or_divider.dart';
import 'package:WE/Screens/BottomNavigation/QR/bracelet_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/new_qr_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/pin_code.dart';
import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
import 'package:bubble/bubble.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WE/Resources/constants.dart';
import 'package:nice_button/nice_button.dart';
import 'package:WE/Screens/BottomNavigation/QR/instructions.dart';
import 'package:WE/Screens/BottomNavigation/QR/coin_screen.dart';

class IconDt {
  static const IconData bracelet = IconData(0xf523, fontFamily: 'Bracelet');
//static const Icon bracelet2 = Icon();

}

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

  var instructions = [
    "Bütün ürünler plastik atık olmalıdır.",
    "Atıklar temiz ve kuru olmalıdır.",
    "Küçük atıkları büyük atıkların içine koy.",
    "Poşetlerinizi bağlayarak at.",
    "HeroStation’ın üstünde bulunan QR kodu okut.",
    "Kapağın kapandığından emin ol."
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "HeroStation",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Bubble(
              margin: BubbleEdges.only(top: 10),
              padding: BubbleEdges.all(20),
              alignment: Alignment.topRight,
              nip: BubbleNip.leftBottom,
              color: kPrimaryColor,
              child: Text(
                'Hoş geldin kahraman!',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Image.asset("assets/instruction.png"),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 30, left: 30),
                child: Text(
                  "Lütfen dönüştürmeye başlamadan önce aşağıdaki görevleri tamamladığından emin ol!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Column(children: [
              Container(
                child: CarouselSlider(
                  items: instructionItems,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 3.0,
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
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return QRViewExample();
                            },
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFff4d00), Color(0xFFff9a00)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.qr_code_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                "TARAT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BraceletPage();
                            },
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFff4d00), Color(0xFFff9a00)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "OKUT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  width: 30,
                                  child: Image.asset(
                                      "assets/Icons/bracelet.png",
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
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
