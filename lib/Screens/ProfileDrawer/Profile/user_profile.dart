import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Services/ChatService/we_chat.dart';
import 'package:WE/Services/challenge_service.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HerProfile extends StatefulWidget {
  HerProfile(
      {Key key,
      this.username,
      this.userPhoto,
      this.uid,
      this.level,
      this.coins,
      this.points,
      this.dailyCoins,
      this.dailyRecycled,
      this.recycled,
      this.superhero,
      this.isFriend})
      : super(key: key);

  final String username;
  final String userPhoto;
  final String uid;
  final String superhero;

  final int level;
  final int coins;
  final int points;
  final int dailyCoins;
  final int dailyRecycled;
  final int recycled;

  final bool isFriend;

  @override
  _HerProfileState createState() => _HerProfileState();
}

class _HerProfileState extends State<HerProfile> {
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
    getUserData(widget.username);
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
              backgroundColor: Color(0xffF8F8FA),
              body: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    color: kSecondaryColor,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, right: 15.0, top: 50),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(widget.userPhoto == null
                                          ? "assets/Icons/account.png"
                                          : widget.userPhoto),
                                    )),
                              ),
                              SizedBox(
                                height: 70,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.username,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 60,
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
                                    "Seviye " + widget.level.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.superhero.toString(),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    widget.coins.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Toplam coin",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    widget.recycled.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Geri dönüştürülen",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
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
                                                addFriend(
                                                  name: widget.username,
                                                  superhero: widget.superhero,
                                                  level: widget.level,
                                                  coins: widget.coins,
                                                  dailyCoins: widget.dailyCoins,
                                                  dailyRecycled:
                                                      widget.dailyRecycled,
                                                  recycled: widget.recycled,
                                                );
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
                                              widget.username +
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
