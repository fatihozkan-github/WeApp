// ignore_for_file: sort_constructors_first

import 'package:WE/Resources/components/overScrollHandler.dart';
import 'package:WE/Resources/components/textOverFlowHandler.dart';
import 'package:flutter/material.dart';

class RoundedListTile extends StatelessWidget {
  final Function onPressed;
  final Widget title;
  final Widget leading;
  final Widget trailing;

  RoundedListTile({
    this.onPressed,
    this.leading,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.all(5.0),
      shadowColor: Colors.orange,
      elevation: 2,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: OverScroll(child: TextOverFlowHandler(child: title)),
            onTap: onPressed,
            leading: leading,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
