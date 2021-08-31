import 'dart:async';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/coin_screen.dart';
import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
import 'package:WE/Screens/ProfileDrawer/Feedback/feedback_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'KODU GİR',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "HeroStationun üstündeki ",
                    children: [
                      TextSpan(
                          text: "4-haneli",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      TextSpan(
                          text: " kodu gir.",
                          style: TextStyle(color: Colors.white)),
                    ],
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.name,
                    backgroundColor: kSecondaryColor,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v.length < 3) {
                        return "";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      selectedFillColor: Colors.grey,
                      selectedColor: Colors.grey,
                      inactiveColor: kPrimaryColor,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 80,
                      fieldWidth: 60,
                      activeColor: hasError ? Colors.red : kPrimaryColor,
                      activeFillColor: hasError ? Colors.red : kPrimaryColor,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,

                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      print("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                hasError ? "*Please fill up all the cells properly" : "",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Align(
              alignment: Alignment(0.9, 0.5),
              child: TextButton(
                child: Text("Temizle"),
                onPressed: () {
                  textEditingController.clear();
                },
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.orange.shade200,
                        offset: Offset(1, -2),
                        blurRadius: 5),
                    BoxShadow(
                        color: Colors.orange.shade200,
                        offset: Offset(-1, 2),
                        blurRadius: 5)
                  ]),
              child: ButtonTheme(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    formKey.currentState.validate();
                    if (currentText.length != 4 || currentText != "3566") {
                      errorController.add(ErrorAnimationType.shake);
                      setState(() {
                        hasError = true;
                      });
                    } else {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              TransitionPage(currentText: currentText),
                        ),
                        (route) => false,
                      );
                      setState(
                        () {
                          hasError = false;
                        },
                      );
                    }
                  },
                  child: Center(
                      child: Text(
                    "DOĞRULA".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bir sorun mu var? ",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FeedbackPage();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "BİZE ULAŞ",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
