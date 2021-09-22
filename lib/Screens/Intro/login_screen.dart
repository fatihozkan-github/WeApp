import 'dart:io';

import 'package:WE/Resources/components/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:WE/Screens/Intro/signup_screen.dart';
import 'package:WE/Resources/components/already_have_an_account_acheck.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/rounded_password_field.dart';
import 'package:WE/Resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/we.png",
                scale: 2,
              ),
              RoundedInputField(
                keyboardType: TextInputType.emailAddress,
                hintText: "   E-posta",
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
              TextFieldContainer(
                child: TextField(
                  // keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Şifre",
                    icon: Container(
                      color: Colors.white,
                      child: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _toggle,
                      icon: Icon(Icons.visibility),
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              RoundedButton(
                text: "GİRİŞ YAP",
                onPressed: () {
                  _email != null || _password != null
                      ? auth
                          .signInWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((_) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs?.setBool("isLoggedIn", true);

                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  BottomNavigation(),
                            ),
                            (route) => false,
                          );
                        }).catchError((err) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Hata"),
                            content: Text(err.message),
                            actions: [
                              FlatButton(
                                child: Text("Tamam"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  })
                      : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Hata"),
                          content: Text("Lütfen bütün alanları doldurun"),
                          actions: [
                            FlatButton(
                              child: Text("Tamam"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
