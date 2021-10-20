// ignore_for_file: omit_local_variable_types, prefer_single_quotes, unawaited_futures

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:WE/Screens/Intro/signup_screen.dart';
import 'package:WE/Resources/components/already_have_an_account_acheck.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
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
  bool _showError = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_email);
  }

  void _toggle() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            Image.asset("assets/we2.png", scale: 1.4),
            RoundedInputField(
              hintText: "E-posta",
              icon: Icons.mail,
              onChanged: (value) => setState(() {
                _email = value.trim();
                _showError = false;
              }),
              keyboardType: TextInputType.emailAddress,
              validator: (_typedValue) {
                return (_typedValue.isEmpty)
                    ? 'Boş bırakılamaz'
                    : isValidEmail()
                        ? null
                        : "Lütfen geçerli bir mail adresi giriniz";
              },
            ),
            RoundedInputField(
              hintText: "Şifreniz",
              icon: Icons.lock,
              onChanged: (value) => setState(() {
                _password = value.trim();
                _showError = false;
              }),
              obscureText: _obscureText,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
                FocusScope.of(context).nextFocus();
              },
              suffixIcon: IconButton(onPressed: _toggle, icon: Icon(Icons.visibility), color: kPrimaryColor),
              // validator: (_typed) {
              //   if (_typed.isEmpty) {
              //     return 'Boş bırakılamaz';
              //   } else if (_typed.length < 6) {
              //     return 'Şifreniz en az 6 karakter uzunluğunda olmalıdır.';
              //   } else {
              //     return null;
              //   }
              // },
            ),
            _showError
                ? Text(
                    'Girdiğiniz bilgilere sahip bir kullanıcı bulamadık. Mailinizi ve şifrenizi kontrol edip tekrar deneyiniz.',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            RoundedButton(
              /// TODO: User check
              text: "GİRİŞ YAP",
              onPressed: () {
                print(_email);
                print(_password);
                if (_formKey.currentState.validate()) {
                  auth.signInWithEmailAndPassword(email: _email, password: _password).then(
                    (_) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs?.setBool("isLoggedIn", true);
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(builder: (BuildContext context) => BottomNavigation()),
                        (route) => false,
                      );
                    },
                  ).catchError((err) {
                    print(err);
                    setState(() {
                      _showError = true;
                    });
                    // return showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       print(err.message);
                    //       return AlertDialog(
                    //         title: Text("Hata"),
                    //         content: Text(err.message),
                    //         actions: [TextButton(child: Text("Tamam"), onPressed: () => Navigator.of(context).pop())],
                    //       );
                    //     });
                  });
                  // .onError((error, stackTrace) async => setState(() => _showError = true));
                }
              },
            ),
            SizedBox(height: 20),
            AlreadyHaveAnAccountCheck(
              press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

///
// RoundedInputField(
//   keyboardType: TextInputType.emailAddress,
//   hintText: "   E-posta",
//   onChanged: (value) {
//     setState(() {
//       _email = value.trim();
//     });
//   },
// ),
// TextFieldContainer(
//   child: TextField(
//     // keyboardType: TextInputType.visiblePassword,
//     obscureText: _obscureText,
//     onChanged: (value) {
//       setState(() {
//         _password = value.trim();
//       });
//     },
//     cursorColor: kPrimaryColor,
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       hintText: "Şifre",
//       icon: Container(
//         color: Colors.white,
//         child: Icon(
//           Icons.lock,
//           color: kPrimaryColor,
//         ),
//       ),
//       suffixIcon: IconButton(
//         onPressed: _toggle,
//         icon: Icon(Icons.visibility),
//         color: kPrimaryColor,
//       ),
//       border: InputBorder.none,
//     ),
//   ),
// ),
///
// TextFieldContainer(
//   child: TextField(
//     // keyboardType: TextInputType.visiblePassword,
//     obscureText: _obscureText,
//     onChanged: (value) {
//       setState(() {
//         _password = value.trim();
//       });
//     },
//     cursorColor: kPrimaryColor,
//     decoration: InputDecoration(
//       filled: true,
//       fillColor: Colors.white,
//       hintText: "Şifre",
//       icon: Container(
//         color: Colors.white,
//         child: Icon(
//           Icons.lock,
//           color: kPrimaryColor,
//         ),
//       ),
//       suffixIcon: IconButton(
//         onPressed: _toggle,
//         icon: Icon(Icons.visibility),
//         color: kPrimaryColor,
//       ),
//       border: InputBorder.none,
//     ),
//   ),
// ),
///
// onPressed: () {
//   _email != null || _password != null
//       ? auth.signInWithEmailAndPassword(email: _email, password: _password).then((_) async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs?.setBool("isLoggedIn", true);
//
//           Navigator.pushAndRemoveUntil<dynamic>(
//             context,
//             MaterialPageRoute<dynamic>(
//               builder: (BuildContext context) => BottomNavigation(),
//             ),
//             (route) => false,
//           );
//         }).catchError((err) {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text("Hata"),
//                   content: Text(err.message),
//                   actions: [
//                     FlatButton(
//                       child: Text("Tamam"),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     )
//                   ],
//                 );
//               });
//         })
//       : showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Hata"),
//               content: Text("Lütfen bütün alanları doldurun"),
//               actions: [
//                 FlatButton(
//                   child: Text("Tamam"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
// },
