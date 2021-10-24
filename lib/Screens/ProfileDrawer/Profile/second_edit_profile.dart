// ignore_for_file: omit_local_variable_types

import 'package:WE/Resources/components/default_appbar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondEditProfile extends StatefulWidget {
  @override
  State<SecondEditProfile> createState() => _SecondEditProfileState();
}

class _SecondEditProfileState extends State<SecondEditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User firebaseUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot data;
  List localUserList = [];
  String _oldPassword;
  String _typedOldPassword;
  String _typedNewPassword;
  String _reTypedNewPassword;
  bool _showError = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  void _changePassword(String oldPass, String newPass) async {
    User user = FirebaseAuth.instance.currentUser;
    String email = user.email;
    String oldPassword = oldPass;
    String newPassword = newPass;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: oldPassword,
      );

      await user.updatePassword(newPassword).then((_) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Şifre Değiştirildi!'),
                actions: [TextButton(child: Text('Tamam'), onPressed: () => Navigator.pop(context))],
              );
            });
        print("Successfully changed password");
      }).catchError((error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Bir Sorun Oluştu!'),
                actions: [TextButton(child: Text('Tamam'), onPressed: () => Navigator.pop(context))],
              );
            });
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Girdiğiniz Şifre Yanlış!'),
                actions: [TextButton(child: Text('Tamam'), onPressed: () => Navigator.pop(context))],
              );
            });
        print('Wrong password provided for that user.');
      }
    }
  }

  void _toggle1() => setState(() => _obscureText1 = !_obscureText1);
  void _toggle2() => setState(() => _obscureText2 = !_obscureText2);
  void _toggle3() => setState(() => _obscureText3 = !_obscureText3);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: 'Hesap Ayarları').build(context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            SizedBox(height: 10),
            RoundedInputField(
              hintText: 'Eski Şifrenizi Giriniz',
              icon: Icons.lock_open_rounded,
              obscureText: _obscureText1,
              suffixIcon: IconButton(onPressed: _toggle1, icon: Icon(Icons.visibility), color: kPrimaryColor),
              onChanged: (value) => setState(() => _typedOldPassword = value),
            ),
            RoundedInputField(
              hintText: 'Yeni Şifrenizi Giriniz',
              icon: Icons.lock,
              obscureText: _obscureText2,
              suffixIcon: IconButton(onPressed: _toggle2, icon: Icon(Icons.visibility), color: kPrimaryColor),
              onChanged: (value) => setState(() => _typedNewPassword = value),
            ),
            RoundedInputField(
              hintText: 'Yeni Şifrenizi Tekrar Giriniz',
              icon: Icons.lock,
              obscureText: _obscureText3,
              suffixIcon: IconButton(onPressed: _toggle3, icon: Icon(Icons.visibility), color: kPrimaryColor),
              onChanged: (value) => setState(() => _reTypedNewPassword = value),
              validator: (_typed) {
                if ((_typedNewPassword == _reTypedNewPassword) &&
                    !(_typedNewPassword.length < 6 || _reTypedNewPassword.length < 6)) {
                  return null;
                } else if (_typedNewPassword != _reTypedNewPassword) {
                  return 'Girdiğiniz Şifreler Uyuşmuyor!';
                } else if (_typedNewPassword.length < 6 || _reTypedNewPassword.length < 6) {
                  return 'Şifreniz en az 6 karakter uzunluğunda olmalıdır.';
                } else
                  return 'Bilinmeyen bir hata oluştu!';
              },
            ),
            if (_showError)
              Text(
                '*Bu işlemi gerçekleştirebilmeniz için uygulamaya yakın bir zamanda giriş yapmış olmanız gerekmektedir. Uygulamaya yeniden giriş yaptıktan sonra tekrar deneyiniz.\n '
                '*Eğer sorunun bu olmadığını düşünüyorsanız lütfen uygulamanın ilgili bölümünden bizimle iletişime geçin.',
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            RoundedButton(
                text: 'KAYDET',
                onPressed: () async {
                  print(_formKey.currentState.validate());
                  print(_typedNewPassword == _reTypedNewPassword);

                  if (_formKey.currentState.validate() && _typedNewPassword == _reTypedNewPassword) {
                    _changePassword(_typedOldPassword, _typedNewPassword);
                  } else {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Girdiğiniz Bilgileri Kontrol Ediniz'),
                            actions: [TextButton(child: Text('Tamam'), onPressed: () => Navigator.pop(context))],
                          );
                        });
                  }
                }
                // {
                //   if (_formKey.currentState.validate() &&
                //       _typedNewPassword == _reTypedNewPassword &&
                //       _typedOldPassword == _oldPassword) {
                //     /// TODO: Success message.
                //     print('ch1');
                //     _changePassword(_typedNewPassword);
                //     // firebaseUser.updatePassword(_typedNewPassword).whenComplete(() => print('success!')).catchError((error) {
                //     //   print(error);
                //     //   setState(() => _showError = true);
                //     // });
                //   }
                // },
                ),
          ],
        ),
      ),
    );
  }
}
