// ignore_for_file: omit_local_variable_types, prefer_final_fields

import 'package:WE/API/API_initials.dart';
import 'package:WE/API/API_login.dart';
import 'package:WE/Resources/functions.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/models/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService extends ChangeNotifier {
  APILogin _apiLogin = APILogin();
  Functions _functions = Functions();

  /// • Get the current user according to our user model.
  Future initiateUser(String currentUserID, BuildContext context) async {
    DocumentSnapshot rawUserData = await Provider.of<APIInitials>(context, listen: false).fetchUser(currentUserID);
    UserModel _currentUser = UserModel.fromDocument(rawUserData);
    // Provider.of<UserService>(context, listen: false).currentUser = _currentUser;
    Provider.of<UserService>(context, listen: false).gotUser(loggedInUser: _currentUser);
    notifyListeners();
  }

  /// • Login service for WE.
  Future login(BuildContext context, {String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_functions.nullCheck(prefs.getString('userID'))) {
      await _apiLogin.APIServicesLogin(email, password, context);
    } else if (!_functions.nullCheck(prefs.getString('userID'))) {
      /// TODO: Status check.
      await initiateUser(prefs.getString('userID'), context);
    }
    notifyListeners();
  }

  /// • Sign up service for WE.
  ///
  /// • TODO: Write & implement
  Future sign_up(BuildContext context, {String email, String password}) async {
    await _apiLogin.APIServicesSignup();
  }

  Future log_out({Function function}) async => await _apiLogin.APILogout(function);
}
