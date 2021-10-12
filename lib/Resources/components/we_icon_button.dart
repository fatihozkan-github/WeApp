// ignore_for_file: sort_constructors_first

import 'package:WE/Resources/components/textOverFlowHandler.dart';
import 'package:flutter/material.dart';

class WEIconButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function onPressed;
  final TextStyle textStyle;
  final double width;

  WEIconButton({
    this.title,
    this.icon,
    this.onPressed,
    this.textStyle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 180,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange[200],
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            icon ?? Icon(Icons.help, size: 120),
            TextOverFlowHandler(
              child: Text(title ?? 'Title', style: textStyle ?? TextStyle(color: Colors.grey, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
