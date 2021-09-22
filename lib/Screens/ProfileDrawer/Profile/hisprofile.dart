import 'package:WE/Resources/SizeConfig.dart';
import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Services/ChatService/we_chat.dart';
import 'package:WE/Services/challenge_service.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HisProfile extends StatefulWidget {
  HisProfile({
    Key key,
    this.uid,
  }) : super(key: key);

  final String uid;

  @override
  _HisProfileState createState() => _HisProfileState();
}

class _HisProfileState extends State<HisProfile> {
  bool _canShowButton = true;

  void hideWidget() {
    setState(() {
      _canShowButton = !_canShowButton;
    });
  }

  var firebaseUser = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection("users");

  List<bool> isFriend = [];

  void getUserData(str) async {
    var document = await users.doc(currentUid);
    document.get().then((value) => print(value));
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(currentUid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      for (var i = 1; i <= docSnapshot.data()["friends"].length; i++) {
        if (data["friends"]["friend" + i.toString()]["name"] == str) {
          isFriend.add(true);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserData(widget.username);
  }

  var currentUid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Profil Sayfasi",
                  style: TextStyle(fontFamily: "Panthera", fontSize: 24),
                ),
              ),
              body: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, right: 15.0, top: 50),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: 220,
                                width: 220,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://firebasestorage.googleapis.com/v0/b/nodemcu-ac498.appspot.com/o/profilePhotos%2Fimage_picker7520950041675576623jpg?alt=media&token=0c07914f-e302-4708-9804-c709c9bcb9d8"))),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data["name"],
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Seviye " + data["level"].toString(),
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data["superhero"].toString(),
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    data["coins"].toString(),
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Toplam coin",
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    data["recycled"].toString(),
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Geri dönüştürülen",
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isFriend.contains(true)
                                  ? Container()
                                  : Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kPrimaryColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person_add_alt_1_rounded,
                                              color: kPrimaryColor,
                                            ),
                                            SizedBox(width: 10),
                                            TextButton(
                                              onPressed: () {
                                                addKanka(
                                                    uid: widget.uid,
                                                    name: data["name"],
                                                    recycled: data["recycled"],
                                                    level: data["level"],
                                                    superhero:
                                                        data["superhero"],
                                                    coins: data["coins"]);
                                              },
                                              child: Text(
                                                "ARKADAŞ EKLE",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !_canShowButton
                                  ? const SizedBox.shrink()
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      child: IconButton(
                                        icon: Image.asset(
                                            "assets/Icons/swords.png"),
                                        onPressed: () {
                                          //checkChallenges(widget.username);
                                          createChallenge(
                                              widget.uid, data["name"]);
                                          popUp(
                                              context,
                                              data["name"] +
                                                  " düelloya davet edildi. Bol şans!",
                                              true);

                                          //_number();
                                        },
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
