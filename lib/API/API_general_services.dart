// ignore_for_file: omit_local_variable_types

import 'package:WE/models/model_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class APIGeneralServices extends ChangeNotifier {
  Future<List<FriendModel>> getLeaderBoard() async {
    List<FriendModel> returnList = [];
    QuerySnapshot holder = await FirebaseFirestore.instance.collection('users').get();
    holder.docs.forEach((element) => returnList.add(FriendModel.fromJSON(element.data())));
    returnList.sort((a, b) => b.recycled.compareTo(a.recycled));
    return returnList;
  }
}
