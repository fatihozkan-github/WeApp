import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  const AlreadyHaveAnAccountCheck({Key key, this.login = true, this.press}) : super(key: key);

  final bool login;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(login ? "Hesabın yok mu? " : "Zaten bir hesabın var mı? ", style: TextStyle(color: kPrimaryColor)),
        GestureDetector(
          onTap: press,
          child: Text(login ? "Kayıt ol" : "Giriş yap", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
