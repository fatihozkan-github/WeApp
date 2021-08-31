import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/friends.dart';
import 'package:flutter/material.dart';

import 'Tabs/global.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Lider Tablosu",
          style: TextStyle(fontSize: 30, fontFamily: "Panthera"),
        ),
      ),
      body: Stack(
        children: [
          Container(
              child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    height: 50,
                    child: TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            "WE",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                            child: Text("Arkadaşlar",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                      ],
                      labelColor: kPrimaryColor,
                      unselectedLabelColor: Colors.white,
                      indicatorColor: kPrimaryColor,
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: TabBarView(
                    children: [
                      GlobalTab(),
                      FriendsTab(),
                    ],
                  ),
                ))
              ],
            ),
          )),
        ],
      ),
    );
  }
}
