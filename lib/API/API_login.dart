// ignore_for_file: unused_local_variable, omit_local_variable_types, prefer_single_quotes

import 'package:WE/Services/service_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// • API services for Login & Sign up functions.
class APILogin extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  /// • Login function for WE.
  Future APIServicesLogin(String _email, String _password, BuildContext context) async {
    var user = await auth.signInWithEmailAndPassword(email: _email, password: _password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs?.setBool("isLoggedIn", true);
    await prefs?.setString("userID", user.user.uid);
  }

  /// TODO
  Future APIServicesSignup() {}

  Future APILogout(function) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userID');
    await FirebaseAuth.instance.signOut().then((value) => function());
  }
}
