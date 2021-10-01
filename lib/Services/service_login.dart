// ignore_for_file: omit_local_variable_types, prefer_final_fields

import 'package:WE/API/API_login.dart';
import 'package:WE/Services/service_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService extends ChangeNotifier {
  APILogin _apiLogin = APILogin();

  /// • Login service for WE.
  Future login(BuildContext context, {String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('PREF: ${prefs.getString('userID')}');
    if (prefs.getString('userID') == null) {
      await _apiLogin.APIServicesLogin(email, password, context);
    } else if (prefs.getString('userID') != null) {
      Provider.of<UserService>(context, listen: false).initiateUser(prefs.getString('userID'), context);
    }
  }

  /// • Sign up service for WE.
  ///
  /// • TODO: Write & implement
  Future sign_up(BuildContext context, {String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userID').isEmpty) {
      await APILogin().APIServicesLogin(email, password, context);
    } else if (prefs.getString('userID').isNotEmpty) {
      Provider.of<UserService>(context, listen: false).initiateUser(prefs.getString('userID'), context);
    }
  }
}
