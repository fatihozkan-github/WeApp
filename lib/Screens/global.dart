import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WE/Resources/SizeConfig.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/user_profile.dart';

class GlobalTab extends StatelessWidget {
  var currentUid = FirebaseAuth.instance.currentUser.uid;
  List<dynamic> allUsers = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('allUsers');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc("C9nvPCW2TwemcjSVgm04").get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            allUsers.clear();
            for (int i = 1; i < data.length + 1; i++) {
              Map map = data["user" + i.toString()];
              allUsers.add(map);
              // TODO: implement points and friends tab
              allUsers.sort((a, b) => b["recycled"].compareTo(a["recycled"]));
            }
            return Scaffold(
              body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    trailing: Container(
                      height: 7 * SizeConfig.heightMultiplier,
                      width: 12 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: AssetImage(index < 3 ? leaderboardIcons[index] : leaderboardIcons[3]))),
                    ),
                    leading: Container(
                      height: 7 * SizeConfig.heightMultiplier,
                      width: 12 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: allUsers[index]["avatar"] == null
                                  ? AssetImage("assets/Icons/user.png")
                                  : NetworkImage(allUsers[index]["avatar"]))),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HerProfile(
                              username: allUsers[index]["name"].toString(),
                              level: allUsers[index]["level"],
                              coins: allUsers[index]["coins"],
                              recycled: allUsers[index]["recycled"],
                              superhero: allUsers[index]["superhero"],
                              uid: allUsers[index]["uid"],
                            );
                          },
                        ),
                      );
                    },
                    title: Text(allUsers[index]["name"].toString()),
                  ));
                },
              ),
            );
          }
          return WESpinKit();
        });
  }
}

final leaderboardIcons = [
  "assets/Icons/first.png",
  "assets/Icons/second.png",
  "assets/Icons/third.png",
  "assets/Icons/wreath.png",
];
