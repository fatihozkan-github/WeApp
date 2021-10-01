// ignore_for_file: omit_local_variable_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WE/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WE/API/API_initials.dart';

class UserService extends ChangeNotifier {
  UserModel currentUser = UserModel();
  String imageUrl;

  /// • Get the current user according to our user model.
  void initiateUser(String currentUserID, BuildContext context) async {
    DocumentSnapshot rawUserData = await Provider.of<APIInitials>(context, listen: false).fetchUser(currentUserID);
    print(rawUserData.data());
    currentUser = UserModel.fromDocument(rawUserData);
  }

  /// TODO: Needs fix!
  ///
  /// • Calculates user level.
  void calculateLevel() async {
    var counter = 0;

    for (var i = 1; i <= 24; i++) {
      if (currentUser.recycled / (expTable[i]) >= 1) {
        counter = counter + 1;
      }
    }
    await FirebaseFirestore.instance.collection('users').doc(currentUser.userID).update({
      "level": counter + 1,
      "exp": (currentUser.recycled + (expTable[counter])) / ((expTable[counter + 1]) - (expTable[counter])),
    });
  }

  /// • Test function for current user.
  void currentUserInfo() {
    print(currentUser.email);
    print(currentUser.userID);
    print(currentUser.superhero);
    print(currentUser.avatar);
    print(currentUser.level);
    print(currentUser.name);
    print(currentUser.exp);
    print(currentUser.badges);
    print(currentUser.recycled);
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
