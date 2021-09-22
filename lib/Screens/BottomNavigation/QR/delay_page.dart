import 'package:WE/Resources/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'coin_screen.dart';

class DelayPage extends StatefulWidget {
  final String qrResult;
  final String currentText;

  DelayPage({this.qrResult, this.currentText});

  @override
  _DelayPageState createState() => _DelayPageState();
}

final databaseReference = FirebaseDatabase.instance.reference();

void openBox(bool isOpen) {
  databaseReference.child('3566').update({'IN_USE': isOpen});
}

class _DelayPageState extends State<DelayPage> {
  @override
  void initState() {
    super.initState();
    openBox(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
        loadingText: Text(
          "Hesaplamalar yapılıyor...",
          style: TextStyle(color: Colors.white),
        ),
        photoSize: 240,
        seconds: 8,
        navigateAfterSeconds: CoinScreenExample(
          qrResult: widget.qrResult,
          currentText: widget.currentText,
        ),
        image: Image.asset(
          // TODO: gif düzenle
          "assets/we2.png",
          alignment: Alignment.center,
          width: 160,
        ),
        backgroundColor: kSecondaryColor,
      ),
    );
  }
}
