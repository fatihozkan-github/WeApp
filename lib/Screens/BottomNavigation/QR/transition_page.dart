import 'dart:async';
import 'package:WE/Resources/constants.dart';
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
  int _counter = 20;
  Timer _initialTimer;

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (context1) {
          Timer(Duration(seconds: 5), () {
            openBox(false);
            _initialTimer.cancel();
            Navigator.pop(context1);
            Navigator.of(context)
              ..pop()
              ..pop();
          });
          return AlertDialog(
            title: Text('Her şey yolunda mı?'),
            actions: [
              TextButton(
                child: Text('Evet!'),
                onPressed: () {
                  setState(() {
                    _counter = 20;
                    _initialTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                      if (_counter > 0) {
                        setState(() {
                          _counter--;
                          print(_counter);
                        });
                      } else if (_counter <= 0) {
                        timer.cancel();
                        _initialTimer.cancel();
                        return showAlertBox();
                      }
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  checkAFK() {
    _initialTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
          print(_counter);
        });
      } else if (_counter <= 0) {
        timer.cancel();
        _initialTimer.cancel();
        return showAlertBox();
      }
    });
  }

  Future openBox(bool isOpen) async {
    await databaseReference.child('3566').update({'IN_USE': isOpen});
    await databaseReference.child('/3566/IS_USING').set(isOpen);
    checkAFK();
  }

  @override
  void initState() {
    super.initState();
    openBox(true);
  }

  @override
  void dispose() {
    openBox(false);
    _initialTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: size.height * 0.04),
            Text(_counter.toString()),
            SizedBox(height: 10),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        openBox(false);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => BottomNavigation(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: size.width * 0.1,
                        color: kPrimaryColor,
                      )),
                )),
            //SizedBox(height: size.height * 0.02),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Plastik atıklarını HeroStation\'a attıktan sonra onayla ve bitir.',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Lottie.asset('assets/lottie.json', height: 250),
            SizedBox(height: size.height * 0.05),
            NiceButton(
              width: size.width * 0.85,
              radius: 10,
              text: "Onayla",
              gradientColors: [Color(0xFFff4d00), Color(0xFFff9a00)],
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DelayPage(
                      qrResult: widget.qrResult,
                      currentText: widget.currentText,
                    ),
                  ),
                  (route) => false,
                );
              },
              background: kSecondaryColor,
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}
