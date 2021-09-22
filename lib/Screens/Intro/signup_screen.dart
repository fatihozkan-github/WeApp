import 'package:WE/Resources/components/text_field_container.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WE/Screens/Intro/login_screen.dart';
import 'package:WE/Resources/components/already_have_an_account_acheck.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/rounded_password_field.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:WE/Services/user_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _username, _email, _password, _city, _superhero, _referral;
  final auth = FirebaseAuth.instance;
  Map<String, dynamic> codes = {};
  bool isInclude = false;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    getCodes();
  }

  Future<void> getCodes() async {
    DocumentSnapshot documentSnapshot;
    documentSnapshot = await FirebaseFirestore.instance
        .collection('referralCodes')
        .doc('list')
        .get();
    codes.addAll(documentSnapshot.data()["listOfReferrals"]);
    print(codes);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.1),
            RoundedInputField(
              hintText: "   İsim",
              onChanged: (value) {
                setState(() {
                  _username = value.trim();
                });
              },
            ),
            RoundedInputField(
              keyboardType: TextInputType.emailAddress,
              hintText: "   E-posta",
              icon: Icons.mail,
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
                  hintText: "Şifreniz en az 6 karakter uzunluğunda olmalıdır.",
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
            RoundedInputField(
              hintText: "   Şehir",
              icon: Icons.location_city_outlined,
              onChanged: (value) {
                _city = value.trim();
              },
            ),
            RoundedInputField(
              hintText: " Favori süper kahraman",
              icon: Icons.local_fire_department_outlined,
              onChanged: (value) {
                _superhero = value.trim();
              },
            ),
            RoundedInputField(
              hintText: " Referans kodu zorunludur",
              icon: Icons.lock,
              onChanged: (value) {
                _referral = value.trim();
              },
            ),
            SizedBox(
              height: size.height * 0.07,
            ),
            RoundedButton(
              text: "KAYIT OL",
              onPressed: () {
                if (_referral.isNotEmpty) {
                  for (var i = 0; i <= codes.length; i++) {
                    if (_referral == codes[i.toString()]) {
                      isInclude = true;
                    }
                  }
                  _password.length >= 6
                      ? isInclude
                      ? auth
                      .createUserWithEmailAndPassword(
                      email: _email, password: _password)
                      .then((_) {
                    create(
                        name: _username,
                        email: _email,
                        password: _password,
                        city: _city,
                        uid: currentUid,
                        superhero: _superhero);
                    addReferralData(
                        referralId: _referral.substring(0, 6),
                        uid: currentUid);

                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            BottomNavigation(),
                      ),
                          (route) => false,
                    );
                    signUp(
                        name: _username,
                        email: _email,
                        password: _password,
                        city: _city,
                        uid: currentUid,
                        superhero: _superhero);
                  }).catchError((err) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          print(err.message);
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(err.message),
                            actions: [
                              FlatButton(
                                child: Text("Ok"),
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
                          title: Text("Error"),
                          content:
                          Text("Your referral code is invalid"),
                          actions: [
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      })
                      : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "Şifreniz en az 6 karakter uzunluğunda olmalıdır."),
                          actions: [
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "WE'ye kayıt olmak için bir referans koduna ihtiyacınız olmalı."),
                          actions: [
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }
              },
            ),
            SizedBox(height: size.height * 0.04),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
