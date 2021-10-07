import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';

class WESnackBar extends StatelessWidget {
  WESnackBar({
    this.content,
  });

  final SnackBarContent content;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('Panoya kopyalandı.'),
      backgroundColor: kPrimaryColor,
      duration: Duration(seconds: 2),
    );
  }
}

enum SnackBarContent {
  copied,
  success,
  fail,
}
