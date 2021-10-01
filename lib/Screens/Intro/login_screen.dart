// ignore_for_file: omit_local_variable_types, prefer_single_quotes, unawaited_futures

import 'package:WE/Services/service_login.dart';
import 'package:flutter/material.dart';
import 'package:WE/Screens/Intro/signup_screen.dart';
import 'package:WE/Resources/components/already_have_an_account_acheck.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _obscureText = true;
  bool _showError = false;

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_email);
  }

  void _toggle() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: <Widget>[
              Image.asset("assets/we2.png", scale: 1.4),
              RoundedInputField(
                hintText: "E-posta",
                icon: Icons.mail,
                onChanged: (value) => setState(() {
                  _email = value.trim();
                  _showError = false;
                }),
                keyboardType: TextInputType.emailAddress,
                validator: (_typedValue) {
                  return (_typedValue.isEmpty)
                      ? 'Boş bırakılamaz'
                      : isValidEmail()
                          ? null
                          : "Lütfen geçerli bir mail adresi giriniz";
                },
              ),
              RoundedInputField(
                hintText: "Şifreniz",
                icon: Icons.lock,
                onChanged: (value) => setState(() {
                  _password = value.trim();
                  _showError = false;
                }),
                obscureText: _obscureText,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                  FocusScope.of(context).nextFocus();
                },
                suffixIcon: IconButton(onPressed: _toggle, icon: Icon(Icons.visibility), color: kPrimaryColor),
                validator: (_typed) {
                  if (_typed.isEmpty) {
                    return 'Boş bırakılamaz';
                  } else if (_typed.length < 6) {
                    return 'Şifreniz en az 6 karakter uzunluğunda olmalıdır.';
                  } else {
                    return null;
                  }
                },
              ),
              if (_showError)
                Text(
                  'Girdiğiniz bilgilere sahip bir kullanıcı bulamadık. Mailinizi ve şifrenizi kontrol edip tekrar deneyiniz.',
                  style: TextStyle(color: Colors.red),
                ),
              RoundedButton(
                text: "GİRİŞ YAP",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await Provider.of<LoginService>(context, listen: false)
                        .login(context, email: _email, password: _password)
                        .then((value) async {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => BottomNavigation()),
                        (route) => false,
                      );
                    }).catchError((err) => setState(() => _showError = true));
                  }
                },
              ),
              SizedBox(height: 20),
              AlreadyHaveAnAccountCheck(
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
