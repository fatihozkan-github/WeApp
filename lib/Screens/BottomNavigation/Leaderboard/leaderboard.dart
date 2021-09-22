import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/friends.dart';
import 'package:WE/example.dart';
import 'package:flutter/material.dart';
import 'Tabs/global.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Lider Tablosu",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Stack(
        children: [
          Container(
              color: Colors.white,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    SafeArea(
                      child: Container(
                        color: Colors.white,
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
                          unselectedLabelColor: Colors.black,
                          indicatorColor: kPrimaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.white,
                      child: TabBarView(
                        children: [Example(), FriendsTab()],
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
