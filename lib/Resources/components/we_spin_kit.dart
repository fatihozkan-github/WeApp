import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WESpinKit extends StatefulWidget {
  WESpinKit({this.color});
  final Color color;
  @override
  State<WESpinKit> createState() => _WESpinKitState();
}

class _WESpinKitState extends State<WESpinKit> with SingleTickerProviderStateMixin {
  @override
  Widget build(context) => Center(child: SpinKitSpinningLines(color: widget.color ?? Colors.deepOrangeAccent, size: 50.0));
}
