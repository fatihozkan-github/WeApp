import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BraceletPage extends StatelessWidget {
  const BraceletPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(child: Lottie.asset('assets/bracelet.json')),
            Container(
                width: 250, child: Image.asset("assets/braceletwithhand.png"))
          ],
        ),
      ),
    );
  }
}
