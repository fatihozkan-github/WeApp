import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/tab_friends.dart';
import 'package:WE/Resources/components/overScrollHandler.dart';
import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/tab_leaders.dart';

class LeaderBoard extends StatelessWidget {
  final TextStyle _textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: Text('Lider Tablosu'), backgroundColor: kPrimaryColor),
      body: OverScroll(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [Tab(child: Text("Genel", style: _textStyle)), Tab(child: Text("Arkadaşlar", style: _textStyle))],
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.black,
                indicatorColor: kPrimaryColor,
              ),
              Expanded(child: TabBarView(children: [LeadersTab(), FriendsTab()]))
            ],
          ),
        ),
      ),
    );
  }
}
