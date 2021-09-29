import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';

/// TODO: Do we really need this?
class DefaultAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  DefaultAppBar({
    this.title = "WE",
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: "Montserrat_Alternates",
        ),
      ),
      centerTitle: true,
      backgroundColor: kPrimaryColor,
      actions: actions,
    );
  }
}
