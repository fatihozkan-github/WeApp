import 'package:flutter/material.dart';
import 'package:WE/Screens/Intro/login_screen.dart';
import 'package:WE/Screens/Intro/signup_screen.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            SizedBox(height: 60),
            Center(
              child: Text("WE'ye HOŞGELDİN!", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 32)),
            ),
            Image.asset("assets/we2.png", scale: 1.4),
            RoundedButton(
              text: "GİRİŞ YAP",
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
            ),
            SizedBox(height: 10),
            RoundedButton(
              text: "KAYIT OL",
              color: kSecondaryColor,
              textColor: Colors.white,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
