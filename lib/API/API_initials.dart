import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class APIInitials extends ChangeNotifier {
  Future<DocumentSnapshot> fetchUser(String currentUserID) async {
    return await FirebaseFirestore.instance.collection('users').doc(currentUserID).get();
  }
}
