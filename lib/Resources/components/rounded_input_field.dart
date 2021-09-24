import 'package:flutter/material.dart';
import 'package:WE/Resources/components/text_field_container.dart';
import 'package:WE/Resources/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final Widget suffixIcon;
  final TextInputAction textInputAction;
  final Function validator;
  final Function onEditingComplete;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.validator,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        textInputAction: textInputAction ?? TextInputAction.next,
        autocorrect: false,
        keyboardType: keyboardType,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        obscureText: obscureText,
        onEditingComplete: onEditingComplete,
        validator: validator ??
            (_typed) {
              if (_typed.isEmpty) {
                return 'Boş bırakılamaz';
              } else {
                return null;
              }
            },
        decoration: InputDecoration(
          prefixIcon: Padding(padding: EdgeInsets.only(right: 3), child: Icon(icon, color: kPrimaryColor)),
          suffixIcon: suffixIcon,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.orange, width: 2.0),
          ),
          // border: InputBorder.none,
        ),
      ),
    );
  }
}
