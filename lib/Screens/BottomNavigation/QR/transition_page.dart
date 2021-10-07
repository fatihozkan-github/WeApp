import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/coin_screen.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nice_button/NiceButton.dart';

import 'delay_page.dart';

class TransitionPage extends StatefulWidget {
  final String qrResult;
  final String currentText;

  TransitionPage({this.qrResult, this.currentText});

  @override
  _TransitionPageState createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  void openBox(bool isOpen) {
    databaseReference.child('3566').update({'IN_USE': isOpen});
  }

  @override
  void initState() {
    super.initState();
    openBox(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(height: 30),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.cancel_outlined, size: size.width * 0.1, color: kPrimaryColor),
                  onPressed: () {
                    openBox(false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
                      (route) => false,
                    );
                  },
                ),
              )),
          Container(
            width: size.width * 0.8,
            height: size.height * 0.15,
            decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Geri dönüştürmek istedğin atıkları çöp kutusuna attıktan sonra, aşağıdaki butona basarak onayla ve bitir.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10),
          Lottie.asset('assets/lottie.json'),
          SizedBox(height: 10),
          RoundedButton(
            text: "Onayla",
            showGradient: true,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DelayPage(qrResult: widget.qrResult, currentText: widget.currentText),
                ),
                (route) => false,
              );
            },
          ),
          // NiceButton(
          //   width: size.width * 0.85,
          //   radius: 10,
          //   text: "Onayla",
          //   gradientColors: [Color(0xFFff4d00), Color(0xFFff9a00)],
          //   onPressed: () {
          //     Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => DelayPage(
          //           qrResult: widget.qrResult,
          //           currentText: widget.currentText,
          //         ),
          //       ),
          //       (route) => false,
          //     );
          //   },
          //   background: kSecondaryColor,
          // ),
        ],
      ),
    );
  }
}
