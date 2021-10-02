// ignore_for_file: omit_local_variable_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class APIGeneralServices extends ChangeNotifier {
  Future getLeaderBoard() async {
    List returnList = [];
    await FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        returnList.add({
          "uid": result.id,
          "recycled": result.data()["recycled"],
          "name": result.data()["name"],
          "avatar": result.data()["avatar"],
        });
        returnList.sort((a, b) => b["recycled"].compareTo(a["recycled"]));
      });
    });
    return returnList;
  }
}
