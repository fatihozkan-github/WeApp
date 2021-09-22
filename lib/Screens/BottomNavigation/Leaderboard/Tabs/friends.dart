import 'package:WE/Resources/SizeConfig.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/global.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/hisprofile.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/user_profile.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FriendsTab extends StatelessWidget {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  List<dynamic> friends = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CollectionReference users =
        FirebaseFirestore.instance.collection('friends');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(firebaseUser.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            if (data != null) {
              friends.clear();
              for (int i = 1; i < data.length + 1; i++) {
                Map map = data["friend" + i.toString()];
                friends.add(map);
                // TODO: implement points and friends tab
                friends.sort((a, b) => b["recycled"].compareTo(a["recycled"]));
                print(friends);
              }
            }

            return Scaffold(
                backgroundColor: Colors.white,
                body: data != null
                    ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Color(0xFFDFDFDF)),
                                left: BorderSide(
                                    width: 1.0, color: Color(0xFFDFDFDF)),
                                right: BorderSide(
                                    width: 1.0, color: Color(0xFF7F7F7F)),
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xFFffffff)),
                              ),
                            ),
                            child: Card(
                                child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HisProfile(
                                        uid: friends[index]["uid"],
                                      );
                                    },
                                  ),
                                );
                              },
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
                                        image: data["avatar"] == null
                                            ? AssetImage(
                                                "assets/Icons/user.png")
                                            : NetworkImage(data["avatar"]))),
                              ),
                              title: Text(friends[index]["name"]),
                            )),
                          );
                        },
                      )
                    : Column(
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Lottie.asset('assets/add_friend.json'),
                          ),
                          Container(
                            width: size.width * 0.8,
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kPrimaryColor,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Center(
                                    child: Text(
                                  "Henüz hiç arkadaş eklemedin. Arkadaşlarını ekleyerek kendi aranızdaki mücadeleyi buradan takip edebilirsin.",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))),
                          ),
                        ],
                      ));
          }
          return Center(
            child: Image.asset(
              "assets/giftir.gif",
              height: 250.0,
              width: 250.0,
            ),
          );
        });
  }
}

final imagesPeople = [
  "assets/Images/People/larryPage.png",
  "assets/Images/People/alihan.png",
  "assets/Images/People/aysu.png",
  "assets/Images/People/sundarPichai.png",
];
