import 'package:WE/Resources/components/default_appbar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondEditProfile extends StatefulWidget {
  @override
  State<SecondEditProfile> createState() => _SecondEditProfileState();
}

class _SecondEditProfileState extends State<SecondEditProfile> {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  String _oldPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Hesap Ayarları').build(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(height: 10),
          RoundedInputField(
            hintText: 'Eski Şifrenizi Giriniz',
            icon: Icons.lock,
            onChanged: (value) => setState(() => _oldPassword = value),
          ),
          if (_oldPassword != null)
            Column(
              children: [
                RoundedInputField(
                  hintText: 'Yeni Şifrenizi Giriniz',
                  icon: Icons.lock,
                ),
                RoundedInputField(
                  hintText: 'Yeni Şifrenizi Tekrar Giriniz',
                  icon: Icons.lock,
                ),
                RoundedButton(
                  text: 'KAYDET',
                  onPressed: () {},
                ),
              ],
            ),
        ],
      ),
    );
  }
}
