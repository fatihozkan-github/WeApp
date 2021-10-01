// ignore_for_file: sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> impact;
  int recycled;
  int forbadgecount;
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
    // this.impact,
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
    );
  }
}
