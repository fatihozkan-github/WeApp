import 'package:flutter/material.dart';
import 'package:WE/Resources/components/text_field_container.dart';
import 'package:WE/Resources/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextInputType keyboardType;
  final Function onPressed;
  final bool obscure;

  const RoundedPasswordField({
    Key key,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.onPressed,
    this.obscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscure,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          icon: Container(
            color: Colors.white,
            child: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
          ),
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.visibility),
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
