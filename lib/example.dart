import 'package:WE/Screens/ProfileDrawer/Profile/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Resources/SizeConfig.dart';
import 'Screens/BottomNavigation/Leaderboard/Tabs/global.dart';
import 'Screens/ProfileDrawer/Profile/hisprofile.dart';

class Example extends StatefulWidget {
  const Example({Key key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  List l;

  void initState() {
    l = [];
    leaderboardFunction();
    setState(() {});
  }

  void leaderboardFunction() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        l.add({
          "uid": result.id,
          "recycled": result.data()["recycled"],
          "name": result.data()["name"],
          "avatar": result.data()["avatar"],
        });
        l.sort((a, b) => b["recycled"].compareTo(a["recycled"]));
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: l.length > 0
          ? ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HisProfile(uid: l[index]["uid"]);
                        },
                      ),
                    );
                  },
                  child: Card(
                      child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                        left: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                        right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                      ),
                    ),
                    child: ListTile(
                        trailing: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(index < 3
                                      ? leaderboardIcons[index]
                                      : leaderboardIcons[3]))),
                        ),
                        leading: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/Icons/user.png"))),
                        ),
                        title: Text(l[index]["name"].toString())),
                  )),
                );
              })
          : Center(child: CircularProgressIndicator()),
    );
  }
}
