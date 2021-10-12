import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/tab_leader_board.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/tab_friends.dart';
import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lider Tablosu')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 50,
              child: TabBar(
                tabs: [
                  Tab(child: Text("WE", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  Tab(child: Text("Arkadaşlar", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                ],
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.black,
                indicatorColor: kPrimaryColor,
              ),
            ),
            Expanded(child: TabBarView(children: [LeaderBoardTab(), FriendsTab()]))
          ],
        ),
      ),
    );
  }
}
