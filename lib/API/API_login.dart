// ignore_for_file: unused_local_variable, omit_local_variable_types, prefer_single_quotes

import 'package:WE/models/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// • API services for Login & Sign up functions.
class APILogin extends ChangeNotifier {
  /// • Login function for WE.
  Future APIServicesLogin(String _email, String _password, BuildContext context) async {
    UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs?.setBool("isLoggedIn", true);
    await prefs?.setString("userID", user.user.uid);
  }

  /// TODO
  Future APIServicesSignup({Map<String, dynamic> newUserMap}) async {
    DocumentSnapshot documentSnapshot;
    documentSnapshot = await FirebaseFirestore.instance.collection('allUsers').doc('C9nvPCW2TwemcjSVgm04').get();

    await FirebaseFirestore.instance.collection('allUsers').doc('C9nvPCW2TwemcjSVgm04').set({
      "user" + (documentSnapshot.data().keys.length + 1).toString(): newUserMap,
    }, SetOptions(merge: true));
  }

  Future APILogout(function) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userID');
    await FirebaseAuth.instance.signOut().then((value) => function());
  }
}

// {
// "name": newUser.name,
// "password": newUser.password,
// "email": newUser.email,
// "city": newUser.city,
// "exp": 0.1,
// "superhero": newUser.superhero,
// "level": 1,
// "coins": 0,
// "points": 0,
// "raffle1": false,
// "raffle2": false,
// "raffle3": false,
// "forbadgecount": 0,
// "dailyCoins": 0,
// "dailyRecycled": 0,
// "uid": newUser.userID,
// "recycled": 0,
// "avatar": null,
// "impact": ["Nothing", "2-hour bulb energy", "2 fish", "2kWh energy"],
// "badges": {
//   "badge1": false,
//   "badge2": false,
//   "badge3": false,
//   "badge4": false,
//   "badge5": false,
//   "badge6": false,
//   "challenges": false,
// }
// },
