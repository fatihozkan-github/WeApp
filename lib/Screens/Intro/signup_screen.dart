import 'package:WE/Resources/components/already_have_an_account_acheck.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/unFocuser.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:WE/Screens/Intro/login_screen.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_email);
  }

  void _toggle() => setState(() => _obscureText = !_obscureText);

  Future<void> getCodes() async {
    var documentSnapshot;

    /// TODO: Fix
    ///
    /// Status{code=PERMISSION_DENIED, description=Missing or insufficient permissions., cause=null}
    documentSnapshot = await FirebaseFirestore.instance
        .collection('referralCodes')
        .doc('list')
        .get();
    codes.addAll(documentSnapshot.data()['listOfReferrals']);
    print(codes);
  }

  @override
  void initState() {
    super.initState();
    getCodes();
  }

  @override
  Widget build(BuildContext context) {
    return UnFocuser(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset('assets/we2.png', scale: 1.4),
                RoundedInputField(
                  hintText: 'İsim',
                  onChanged: (value) =>
                      setState(() => _username = value.trim()),
                ),
                RoundedInputField(
                  hintText: 'E-posta',
                  icon: Icons.mail,
                  onChanged: (value) => setState(() => _email = value.trim()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (_typedValue) {
                    return (_typedValue.isEmpty)
                        ? 'Boş bırakılamaz'
                        : isValidEmail()
                            ? null
                            : 'Lütfen geçerli bir mail adresi giriniz';
                  },
                ),
                RoundedInputField(
                  hintText: 'Şifreniz',
                  icon: Icons.lock,
                  onChanged: (value) =>
                      setState(() => _password = value.trim()),
                  obscureText: _obscureText,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                    FocusScope.of(context).nextFocus();
                  },
                  suffixIcon: IconButton(
                      onPressed: _toggle,
                      icon: Icon(Icons.visibility),
                      color: kPrimaryColor),
                  validator: (_typed) {
                    if (_typed.isEmpty) {
                      return 'Boş bırakılamaz';
                    } else if (_typed.length < 6) {
                      return 'Şifreniz en az 6 karakter uzunluğunda olmalıdır.';
                    } else {
                      return null;
                    }
                  },
                ),
                RoundedInputField(
                  hintText: 'Referans kodu zorunludur',
                  icon: Icons.lock,
                  onChanged: (value) => _referral = value.trim(),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 10),
                RoundedButton(
                  text: 'KAYIT OL',
                  onPressed: () {
                    _formKey.currentState.validate();
                    if (_referral.isNotEmpty) {
                      for (var i = 0; i <= codes.length; i++) {
                        if (_referral == codes[i.toString()]) {
                          auth
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
                            signUp(
                                name: _username,
                                email: _email,
                                password: _password,
                                city: _city,
                                uid: currentUid,
                                superhero: _superhero);

                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      BottomNavigation()),
                              (route) => false,
                            );
                          }).catchError((err) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  print(err.message);
                                  return AlertDialog(
                                    title: Text('Hata'),
                                    content: Text(err.message),
                                    actions: [
                                      TextButton(
                                          child: Text('Tamam'),
                                          onPressed: () =>
                                              Navigator.of(context).pop())
                                    ],
                                  );
                                });
                          });
                        } else
                          print('Problem!');
                      }
                    }
                  },
                ),
                SizedBox(height: 20),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen())),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///
// RoundedInputField(
//   hintText: "Şehir",
//   icon: Icons.location_city_outlined,
//   onChanged: (value) => _city = value.trim(),
// ),
// RoundedInputField(
//   hintText: "Favori süper kahraman",
//   icon: Icons.local_fire_department_outlined,
//   onChanged: (value) => _superhero = value.trim(),
// ),
///
// RoundedButton(
//   text: "KAYIT OL",
//   onPressed: () {
//     if (_referral.isNotEmpty) {
//       for (var i = 0; i <= codes.length; i++) {
//         if (_referral == codes[i.toString()]) {
//           isInclude = true;
//         }
//       }
//       _password.length >= 6
//           ? isInclude
//               ? auth.createUserWithEmailAndPassword(email: _email, password: _password).then((_) {
//                   create(
//                       name: _username,
//                       email: _email,
//                       password: _password,
//                       city: _city,
//                       uid: currentUid,
//                       superhero: _superhero);
//                   addReferralData(referralId: _referral.substring(0, 6), uid: currentUid);
//
//                   Navigator.pushAndRemoveUntil<dynamic>(
//                     context,
//                     MaterialPageRoute<dynamic>(
//                       builder: (BuildContext context) => BottomNavigation(),
//                     ),
//                     (route) => false,
//                   );
//                   signUp(
//                       name: _username,
//                       email: _email,
//                       password: _password,
//                       city: _city,
//                       uid: currentUid,
//                       superhero: _superhero);
//                 }).catchError((err) {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         print(err.message);
//                         return AlertDialog(
//                           title: Text("Error"),
//                           content: Text(err.message),
//                           actions: [
//                             FlatButton(
//                               child: Text("Ok"),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             )
//                           ],
//                         );
//                       });
//                 })
//               : showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text("Error"),
//                       content: Text("Your referral code is invalid"),
//                       actions: [
//                         FlatButton(
//                           child: Text("Ok"),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         )
//                       ],
//                     );
//                   })
//           : showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text("Error"),
//                   content: Text("Şifreniz en az 6 karakter uzunluğunda olmalıdır."),
//                   actions: [
//                     FlatButton(
//                       child: Text("Ok"),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     )
//                   ],
//                 );
//               });
//     } else {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Error"),
//               content: Text("WE'ye kayıt olmak için bir referans koduna ihtiyacınız olmalı."),
//               actions: [
//                 FlatButton(
//                   child: Text("Ok"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             );
//           });
//     }
//   },
// ),
