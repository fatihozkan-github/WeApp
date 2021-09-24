import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeTextFormField extends StatelessWidget {
  final String text;
  final TextInputType keyboardType;
  final String hintText;
  final FormFieldValidator validator;
  final List<TextInputFormatter> inputFormatter;
  final Function onChanged;
  final Function onEditingComplete;
  final String initialValue;
  final TextStyle hintStyle;
  final Color color;
  final EdgeInsets padding;
  final TextStyle style;
  final bool obscureText;
  final Key formKey;
  final TextAlign textAlign;
  final int maxLines;
  final TextEditingController controller;

  WeTextFormField({
    this.keyboardType,
    this.text,
    this.hintText,
    this.validator,
    this.inputFormatter,
    this.onChanged,
    this.initialValue,
    this.hintStyle,
    this.color,
    this.padding,
    this.style,
    this.obscureText,
    this.formKey,
    this.textAlign,
    this.maxLines,
    this.onEditingComplete,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete ?? () {},
      textAlign: textAlign ?? TextAlign.start,
      obscureText: obscureText ?? false,
      initialValue: initialValue,
      validator: validator,
      cursorColor: color ?? Colors.orange,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatter ?? [],
      style: style,
      autofocus: false,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hintText ?? 'Your Hint Text Here!',
        hintStyle: hintStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide.none),
        fillColor: Colors.grey.shade200,
        filled: true,
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color ?? Colors.orange, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        contentPadding: padding ?? EdgeInsets.only(left: 15, top: 14, bottom: 14, right: 15),
      ),
    );
  }
}
