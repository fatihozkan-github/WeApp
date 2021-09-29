import 'package:WE/Resources/components/default_appbar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondEditProfile extends StatefulWidget {
  @override
  State<SecondEditProfile> createState() => _SecondEditProfileState();
}

class _SecondEditProfileState extends State<SecondEditProfile> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var data;

  String _typedOldPassword;
  String _typedNewPassword;
  String _reTypedNewPassword;
  bool _showError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getData() async {
    data = await users.doc(firebaseUser.uid).get();
    print(data.data());
    print(data['password']);
  }

  @override
  void initState() {
    getData();
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
              onChanged: (value) => setState(() => _typedOldPassword = value),
            ),
            RoundedInputField(
              hintText: 'Yeni Şifrenizi Giriniz',
              icon: Icons.lock,
              onChanged: (value) => setState(() => _typedNewPassword = value),
            ),
            RoundedInputField(
              hintText: 'Yeni Şifrenizi Tekrar Giriniz',
              icon: Icons.lock,
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
              onPressed: () {
                if (_formKey.currentState.validate() &&
                    _typedNewPassword == _reTypedNewPassword &&
                    _typedOldPassword == data["password"]) {
                  /// TODO: Success message.
                  firebaseUser.updatePassword(_typedNewPassword).catchError((error) {
                    setState(() => _showError = true);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
