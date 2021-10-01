// ignore_for_file: prefer_single_quotes, omit_local_variable_types

import 'package:WE/Resources/components/or_divider.dart';
import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/textOverFlowHandler.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Screens/ProfileDrawer/Badges/badges_page.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/edit_profile.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/second_edit_profile.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    calculateLevel(firebaseUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(firebaseUser.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot?.data.data();
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Profil Sayfası"),
                backgroundColor: Color(0xFFFF6B00),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SecondEditProfile())),
                      icon: Icon(Icons.settings))
                ],
              ),
              body: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  _header(data),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: RoundedButton(
                      text: 'Profili Düzenle',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile())),
                    ),
                  ),
                  SizedBox(height: 10),
                  _mainBody(data, size),
                  SizedBox(height: 10),
                  OrDivider(text: "Rozetler"),
                  _footer(data),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
          return WESpinKit();
        });
  }

  _header(data) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: data["avatar"] != null
                      ? Container(
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"])),
                          ),
                        )
                      : Icon(Icons.account_circle_rounded, size: 120, color: Colors.grey),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextOverFlowHandler(
                        child: Text(
                          data["name"].toString().trim() == null ? 'İsim Girilmedi!' : data["name"],
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Image.asset("assets/Icons/supermanicon.png", scale: 0.2, color: Colors.black, height: 30, width: 30),
                          SizedBox(width: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              data["superhero"].toString().trim() == null ? 'Kahraman İsmi Girilmedi!' : data["superhero"],
                              style: TextStyle(color: Colors.black, fontSize: 15),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(data["coins"].toString() ?? 0,
                        style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text("WE coin", style: TextStyle(color: Colors.black, fontSize: 15)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(data["recycled"].toString() ?? 0,
                        style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text("Geri dönüştürülen", style: TextStyle(color: Colors.black, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  _mainBody(data, size) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: SizedBox(
                  height: 190,
                  width: 190,
                  child: LiquidCircularProgressIndicator(
                      value: data["exp"],
                      valueColor: AlwaysStoppedAnimation(Colors.lightBlue[200]),
                      backgroundColor: Colors.white,
                      borderColor: kPrimaryColor,
                      borderWidth: 10.0,
                      direction: Axis.vertical,
                      center: data['level'].toString() != null ? Text("Seviye ${data['level'].toString()}") : Text('Seviye 1')))),
          IconButton(
            icon: Image.asset("assets/question-mark.png"),
            iconSize: 60,
            onPressed: () {
              data["recycled"].toString() != null
                  ? popUp(
                      context,
                      (data["recycled"] * 5.774).toStringAsFixed(0).length == 4
                          ? ((data["recycled"] * 5.774) / 1000).toStringAsFixed(2) + " kWh elektrik tasarrufu yaptın."
                          : (data["recycled"] * 5.774).toStringAsFixed(2) + " Wh elektrik tasarrufu yaptın.",
                      true,
                    )
                  : popUp(
                      context,
                      "0 Wh elektrik tasarrufu yaptın.",
                      true,
                    );
            },
          )
        ],
      );

  _footer(data) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BadgePage())),
        child: SizedBox(
          height: 90,
          child: ListView(
            itemExtent: 100,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Image.asset(data["badges"]["badge1"] ? allBadges[0][0] : allBadges[0][1]),
              Image.asset(data["badges"]["badge2"] ? allBadges[1][0] : allBadges[1][1], scale: 8),
              Image.asset(data["badges"]["badge3"] ? allBadges[2][0] : allBadges[2][1], scale: 8),
              Image.asset(data["forbadgecount"] >= 3 ? allBadges[3][0] : allBadges[3][1], scale: 8),
              Image.asset(data["recycled"] >= 800 ? allBadges[4][0] : allBadges[4][1], scale: 8),
              Image.asset(data["badges"]["badge6"] ? allBadges[5][0] : allBadges[5][1], scale: 8),
            ],
          ),
        ),
      );
}

List<List<String>> allBadges = [
  ["assets/Images/Badges/Unlocked/activeBadge1.png", "assets/Images/Badges/Locked/inactiveBadge1.png"],
  ["assets/Images/Badges/Unlocked/activeBadge2.png", "assets/Images/Badges/Locked/inactiveBadge2.png"],
  ["assets/Images/Badges/Unlocked/activeBadge3.png", "assets/Images/Badges/Locked/inactiveBadge3.png"],
  ["assets/Images/Badges/Unlocked/activeBadge4.png", "assets/Images/Badges/Locked/inactiveBadge4.png"],
  ["assets/Images/Badges/Unlocked/activeBadge5.png", "assets/Images/Badges/Locked/inactiveBadge5.png"],
  ["assets/Images/Badges/Unlocked/activeBadge6.png", "assets/Images/Badges/Locked/inactiveBadge6.png"],
];
