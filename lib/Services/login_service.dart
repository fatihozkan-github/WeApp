import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginService extends ChangeNotifier {
  /// Initialize
  final firestoreInstance = FirebaseFirestore.instance;
  final currentUid = FirebaseAuth.instance.currentUser.uid;

  void signUp(
      {String name,
      String password,
      String email,
      String city,
      String superhero,
      int level,
      double exp,
      int coins,
      int dailyCoins,
      int dailyRecycled,
      List<String> impact,
      List<String> friends,
      String avatar,
      int recycled,
      int forbadgecount,
      String uid}) {
    firestoreInstance.collection("users").doc(currentUid).set({
      "name": name,
      "password": password,
      "email": email,
      "city": city,
      "exp": 0.1,
      "superhero": superhero,
      "level": 1,
      "coins": 0,
      "points": 0,
      "dailyCoins": 0,
      "dailyRecycled": 0,
      "uid": currentUid,
      "recycled": 0,
      "forbadgecount": 0,
      "avatar": null,
      "raffle1": false,
      "raffle2": false,
      "raffle3": false,
      "impact": ["Nothing", "2-hour bulb energy", "2 fish", "2kWh energy"],
      "badges": {
        "badge1": false,
        "badge2": false,
        "badge3": false,
        "badge4": false,
        "badge5": false,
        "badge6": false,
        "challenges": false,
      }
    });
  }

  /// TODO: .is empty dene user0 var mı for döngüsünde user ekle yeni
  ///
  /// TODO: Need fixes.
  void create(
      {String name,
      String password,
      String email,
      String city,
      String superhero,
      int level,
      double exp,
      int coins,
      int dailyCoins,
      int dailyRecycled,
      List<String> impact,
      String avatar,
      int recycled,
      int forbadgecount,
      String uid}) async {
    var documentSnapshot;
    documentSnapshot = await FirebaseFirestore.instance
        .collection('allUsers')
        .doc('C9nvPCW2TwemcjSVgm04')
        .get();

    await FirebaseFirestore.instance
        .collection('allUsers')
        .doc('C9nvPCW2TwemcjSVgm04')
        .set({
      // currentUid: {
      "user" + (documentSnapshot.data().keys.length + 1).toString(): {
        "name": name,
        "password": password,
        "email": email,
        "city": city,
        "exp": 0.1,
        "superhero": superhero,
        "level": 1,
        "coins": 0,
        "points": 0,
        "raffle1": false,
        "raffle2": false,
        "raffle3": false,
        "forbadgecount": 0,
        "dailyCoins": 0,
        "dailyRecycled": 0,
        "uid": currentUid,
        "recycled": 0,
        "avatar": null,
        "impact": ["Nothing", "2-hour bulb energy", "2 fish", "2kWh energy"],
        "badges": {
          "badge1": false,
          "badge2": false,
          "badge3": false,
          "badge4": false,
          "badge5": false,
          "badge6": false,
          "challenges": false,
        }
      },
    }, SetOptions(merge: true));
  }
}
