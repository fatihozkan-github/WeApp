// ignore_for_file: prefer_single_quotes, omit_local_variable_types

import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Services/challenge_service.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HisProfile extends StatefulWidget {
  HisProfile({Key key, this.uid, this.friends}) : super(key: key);
  final String uid;
  final List friends;
  @override
  _HisProfileState createState() => _HisProfileState();
}

class _HisProfileState extends State<HisProfile> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  var firebaseUser = FirebaseAuth.instance.currentUser;
  List<String> friendIDs = [];
  bool _canShowButton = true;
  bool _isLoading = true;
  bool test = false;

  void hideWidget() => setState(() => _canShowButton = !_canShowButton);

  bruh() async {
    await getUserData().whenComplete(() {
      setState(() {
        test = friendIDs.contains(widget.uid);
        _isLoading = false;
      });
    });
  }

  Future getUserData() async {
    var document = users.doc(firebaseUser.uid);
    await document.get();
    var collection = FirebaseFirestore.instance.collection('friends');
    var docSnapshot = await collection.doc(firebaseUser.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      data.forEach((key, value) {
        friendIDs.add(value["uid"]);
      });
      friendIDs = friendIDs.toSet().toList();
    }
  }

  @override
  void initState() {
    super.initState();
    bruh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            // test = friendIDs.contains(widget.uid);
            return !_isLoading
                ? Scaffold(
                    appBar: AppBar(title: Text("Profil Sayfası")),
                    body: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                        SizedBox(height: 30),
                        Column(
                          children: <Widget>[
                            data["avatar"] == null
                                ? Icon(Icons.account_circle_rounded, size: 200, color: Colors.grey)
                                : Container(
                                    height: 220,
                                    width: 220,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"]))),
                                  ),
                            SizedBox(height: 20),
                            Text(data["name"],
                                style: TextStyle(color: kSecondaryColor, fontSize: 26, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(data["superhero"].toString(), style: TextStyle(color: kSecondaryColor, fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 40),
                        Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  data["level"].toString(),
                                  style: TextStyle(color: kSecondaryColor, fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                                Text("Seviye", style: TextStyle(color: kSecondaryColor, fontSize: 12)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  data["coins"].toString(),
                                  style: TextStyle(color: kSecondaryColor, fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                                Text("Toplam coin", style: TextStyle(color: kSecondaryColor, fontSize: 12)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  data["recycled"].toString(),
                                  style: TextStyle(color: kSecondaryColor, fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Geri\ndönüştürülen",
                                  style: TextStyle(color: kSecondaryColor, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  test
                                      ? Icon(Icons.check_rounded, color: kPrimaryColor)
                                      : Icon(Icons.person_add_alt_1_rounded, color: kPrimaryColor),
                                  SizedBox(width: 10),
                                  test
                                      ? Text(
                                          "ARKADAŞSINIZ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: kPrimaryColor, fontSize: 15),
                                        )
                                      : TextButton(
                                          onPressed: () async {
                                            addKanka(
                                              uid: widget.uid,
                                              name: data["name"],
                                              recycled: data["recycled"],
                                              level: data["level"],
                                              superhero: data["superhero"],
                                              coins: data["coins"],
                                            );
                                            setState(() {
                                              test = true;
                                              // _isLoading = true;
                                              // bruh();
                                            });
                                          },
                                          child: Text(
                                            "ARKADAŞ EKLE",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: kPrimaryColor, fontSize: 15),
                                          ),
                                        ),
                                ]),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !_canShowButton
                                ? const SizedBox.shrink()
                                : Container(
                                    width: 80,
                                    height: 80,
                                    child: IconButton(
                                      icon: Image.asset("assets/Icons/swords.png"),
                                      onPressed: () {
                                        //checkChallenges(widget.username);
                                        createChallenge(widget.uid, data["name"]);
                                        popUp(context, data["name"] + " düelloya davet edildi. Bol şans!", true);

                                        //_number();
                                      },
                                    ),
                                  ),
                          ],
                        )
                      ],
                    ),
                  )
                : WESpinKit();
          }
          return WESpinKit();
        });
  }
}
