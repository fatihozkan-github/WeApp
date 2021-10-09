import 'dart:async';

import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ActivateBracelet extends StatefulWidget {
  const ActivateBracelet({Key key}) : super(key: key);

  @override
  _ActivateBraceletState createState() => _ActivateBraceletState();
}

class _ActivateBraceletState extends State<ActivateBracelet> {
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Bilekliği Etkinleştir"), backgroundColor: kPrimaryColor, centerTitle: true),
      body: PageView(
        controller: controller,
        children: [ReadyPage(controller: controller), ReadRf(controller: controller), Complete()],
      ),
    );
  }
}

class ReadyPage extends StatelessWidget {
  final PageController controller;
  const ReadyPage({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        Container(height: 300, child: Transform.scale(scale: 1.2, child: Lottie.asset('assets/7592-settings.json'))),
        Text('Hazırlan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28), textAlign: TextAlign.center),
        SizedBox(height: 10),
        Text(
          'HeroStation yakınlarında ol ve bilekliğini hazırla. Hazır olduğunda devam butonuna bas.',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        RoundedButton(
          text: 'DEVAM',
          onPressed: () {
            controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
      ],
    );
  }
}

class ReadRf extends StatefulWidget {
  final PageController controller;

  const ReadRf({Key key, this.controller}) : super(key: key);

  @override
  _ReadRfState createState() => _ReadRfState();
}

class _ReadRfState extends State<ReadRf> {
  @override
  void initState() {
    super.initState();
    print('hi');
    init();
  }

  Future<void> init() async {
    StreamSubscription streamEvent;
    final databaseReference = FirebaseDatabase.instance.reference();
    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: '${FirebaseAuth.instance.currentUser.uid}')
        .get();
    streamEvent = databaseReference.child('/3566/RFID_TEMP').onValue.listen((event) async {
      var data = event.snapshot.value as String;
      if (data != '' || data.replaceAll(' ', '') != '') {
        await FirebaseFirestore.instance.doc('users/${userRef.docs.first.id}').update({'rfId': '$data'});
        await databaseReference.child('/3566/RFID_TEMP').set('');
        await databaseReference.child('/3566/SIGN_UP').set(true);
        widget.controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.ease);
        streamEvent.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        SizedBox(height: 30),
        Lottie.asset('assets/34878-scanner.json', height: 300),
        SizedBox(height: 20),
        Text(
          'HeroStation\'a okut',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Bilekliğini HeroStation\'a okut ve onay bildirimini bekle.İşlem başarılı olunca bildirim gelecek.',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class Complete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        SizedBox(height: 30),
        Lottie.asset('assets/16729-congratulation-icon.json', height: 300),
        SizedBox(height: 20),
        Text(
          'Yupppii',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          'Artık bileklik ile giriş yapabileceksin. Kayıt tamamlama işlemi başarılı',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        RoundedButton(
          text: 'Ayarlara Dön',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
