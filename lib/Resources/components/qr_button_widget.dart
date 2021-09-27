import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  final String text;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text(text, style: TextStyle(fontSize: 24)),
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textColor: Colors.white,
        onPressed: onClicked,
      );
}
