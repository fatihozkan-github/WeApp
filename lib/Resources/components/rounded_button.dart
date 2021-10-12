// ignore_for_file: sort_constructors_first

// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color, textColor;
  final Gradient gradient;
  final bool showGradient;
  final bool useCustomChild;
  final Widget customChild;
  final BoxConstraints constraints;

  const RoundedButton({
    Key key,
    this.text,
    this.onPressed,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.gradient,
    this.showGradient = false,
    this.useCustomChild = false,
    this.customChild,
    this.constraints,
  })  : assert(useCustomChild == false || customChild != null, '\nIf useCustomChild parameter is true, then set a custom child.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        color: color,
        gradient: showGradient ? gradient ?? LinearGradient(colors: [Color(0xFFff4d00), Color(0xFFff9a00)]) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: useCustomChild ? customChild : Text(text, style: TextStyle(color: textColor)),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
    );

    // return Container(
    //   margin: EdgeInsets.symmetric(vertical: 10),
    //   width: size.width * 0.8,
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(20),
    //     child: FlatButton(
    //       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
    //       color: color,
    //       onPressed: onPressed,
    //       child: Text(text, style: TextStyle(color: textColor)),
    //     ),
    //   ),
    // );
  }
}
