import 'package:WE/Resources/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BraceletPage extends StatelessWidget {
  const BraceletPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Bileklik Tanımlama',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(child: Lottie.asset('assets/bracelet.json'), height: 180),
          Container(height: 200, child: Image.asset("assets/bileklik.png")),
          SizedBox(height: 50),
          Text(
            'Telefonun Yanında Olmasa da Geri Dönüştürebilirsin\n',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            'Bilekliğini HeroStation üzerinde gösterilen alana okutarak plastik atıklarını atabilirsin.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
