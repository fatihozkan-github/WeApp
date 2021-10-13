import 'dart:async';

import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/qr_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: BackButton(
          onPressed: () async {
            await databaseReference.child('/3566/SIGN_UP').set(false);
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Bilekliği Etkinleştir",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          ReadyPage(
            controller: controller,
          ),
          ReadRf(
            controller: controller,
          ),
          Complete()
        ],
      ),
    );
  }
}

class ReadyPage extends StatelessWidget {
  final PageController controller;
  const ReadyPage({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Transform.scale(
          scale: 1.2,
          child: Lottie.asset(
            'assets/7592-settings.json',
          ),
        ),
        Column(
          children: [
            Text(
              'Hazırlan!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'HeroStation yakınlarında ol ve bilekliğini hazırla. Hazır olduğunda Devam tuşuna bas.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
        TextButton(
          onPressed: () {
            controller.nextPage(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          },
          child: Text(
            'Devam',
            style: TextStyle(
              fontSize: 18,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
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
    // TODO: implement initState
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
    streamEvent = databaseReference
        .child('/3566/RFID_SIGN')
        .onValue
        .listen((event) async {
      await databaseReference.child('/3566/SIGN_UP').set(true);
      var data = event.snapshot.value as String;
      if (data != '' || data.replaceAll(' ', '') != '') {
        await FirebaseFirestore.instance
            .doc('users/${userRef.docs.first.id}')
            .update({'rfId': '$data'});
        await databaseReference.child('/3566/RFID_SIGN').set('');
        widget.controller.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.ease);
        await databaseReference.child('/3566/SIGN_UP').set(false);
        streamEvent.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Lottie.asset('assets/34878-scanner.json', height: 300),
        Column(
          children: [
            Text(
              'HeroStation\'a okut',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bilekliğini HeroStation\'a okut ve onay bildirimini bekle. \nİşlem başarılı olunca bildirim gelecek .',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Complete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Lottie.asset('assets/16729-congratulation-icon.json', height: 300),
        Column(
          children: [
            Text(
              'Tebrikler!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Artık telefonun yanında olmasa da \nbilekliğini gösterilen alana okutarak atıklarını geri dönüştürebilirsin!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ayarlara Dön',
                style: TextStyle(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
