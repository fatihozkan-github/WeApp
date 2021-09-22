import 'package:WE/Resources/components/or_divider.dart';
import 'package:WE/Screens/ProfileDrawer/Badges/badges_page.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/edit_profile.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Resources/SizeConfig.dart';
import 'package:flutter/material.dart';

import 'Services/user_service.dart';

class DenemePage extends StatefulWidget {
  @override
  _DenemePageState createState() => _DenemePageState();
}

class _DenemePageState extends State<DenemePage> {
  var currentUid = FirebaseAuth.instance.currentUser.uid;
  List<dynamic> friends = [];

  @override
  void initState() {
    // TODO: implement initState

    Query collectionReference =
        FirebaseFirestore.instance.collection("users").orderBy('coins');
    print(collectionReference.toString());
    print("*");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users =
        FirebaseFirestore.instance.collection('allUsers');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc("C9nvPCW2TwemcjSVgm04").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            friends.clear();
            for (int i = 1; i < data.length + 1; i++) {
              Map map = data["user" + i.toString()];
              friends.add(map);
              friends.sort((a, b) => b["coins"].compareTo(a["coins"]));
            }
            return Scaffold(
              body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HerProfile(
                                  username: friends[index]["name"].toString(),
                                  level: friends[index]["level"],
                                  coins: friends[index]["coins"],
                                  recycled: friends[index]["recycled"],
                                  superhero: friends[index]["superhero"],
                                  points: friends[index]["points"],
                                );
                              },
                            ),
                          );
                        },
                        title: Text(friends[index]["name"].toString()),
                      ));
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
