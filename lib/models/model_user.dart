// ignore_for_file: sort_constructors_first, prefer_single_quotes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String userID;
  String name;
  String city;
  String avatar;
  String email;
  String superhero;
  int level;
  double exp;
  int coins;
  int dailyCoins;
  int dailyRecycled;
  List<dynamic> impact;
  int recycled;
  int forbadgecount;
  String address;
  int points;
  bool raffle1;
  bool raffle2;
  bool raffle3;
  String company;
  Map<String, dynamic> badges = {
    "badge3": false,
    "badge4": false,
    "badge5": false,
    "badge6": false,
    "challenges": false,
    "badge1": false,
    "badge2": false
  };

  /// TODO: Check null safety.
  UserModel({
    this.userID,
    this.name,
    this.city,
    this.avatar = '',
    this.email,
    this.superhero,
    this.level = 1,
    this.exp = 0.1,
    this.coins = 0,
    this.dailyCoins = 0,
    this.dailyRecycled = 0,
    this.recycled = 0,
    this.forbadgecount = 0,
    this.badges,
    this.address,
    this.impact = const [],
    this.points,
    this.raffle1 = false,
    this.raffle2 = false,
    this.raffle3 = false,
    this.company,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      userID: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      city: doc['city'],
      superhero: doc['superhero'],
      avatar: doc['avatar'],
      level: doc['level'],
      exp: doc['exp'],
      coins: doc['coins'],
      forbadgecount: doc['forbadgecount'],
      dailyCoins: doc['dailyCoins'],
      dailyRecycled: doc['dailyRecycled'],
      recycled: doc['recycled'],
      badges: doc['badges'],
      address: doc['address'],
      impact: doc['impact'],
      points: doc['points'],
      raffle1: doc['raffle1'],
      raffle2: doc['raffle2'],
      raffle3: doc['raffle3'],
      company: doc['company'],
    );
  }

  // Widget createAvatar({String newAvatar}) {
  //   avatar = newAvatar;
  //   return newAvatar != null
  //       ? Container(
  //           height: 120,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(newAvatar)),
  //           ),
  //         )
  //       : Icon(Icons.account_circle_rounded, size: 120, color: Colors.grey);
  // }

  /// TODO: Needs fix!
  ///
  /// • Calculates user level.
  void calculateLevel() async {
    var counter = 0;

    for (var i = 1; i <= 24; i++) {
      if (recycled / (expTable[i]) >= 1) {
        counter = counter + 1;
      }
    }
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      "level": counter + 1,
      "exp": (recycled + (expTable[counter])) / ((expTable[counter + 1]) - (expTable[counter])),
    });
  }
}

final Map<int, int> expTable = {
  0: 5,
  1: 50,
  2: 150,
  3: 300,
  4: 500,
  5: 750,
  6: 1050,
  7: 1400,
  8: 1800,
  9: 2250,
  10: 2750,
  11: 3300,
  12: 3900,
  13: 4550,
  14: 5250,
  15: 6000,
  16: 6800,
  17: 7650,
  18: 8550,
  19: 9500,
  20: 10500,
  21: 11550,
  22: 12650,
  23: 13800,
  24: 15000,
};
