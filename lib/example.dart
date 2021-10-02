// ignore_for_file: override_on_non_overriding_member, prefer_final_fields

import 'package:WE/Resources/components/rounded_list_tile.dart';
import 'Screens/BottomNavigation/Leaderboard/Tabs/global.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Services/service_general.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({Key key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  List localList = [];
  bool _isLoading = true;

  getLeaderBoard() async {
    localList = await Provider.of<GeneralServices>(context, listen: false).getLeaderBoard();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    getLeaderBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: localList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      // MaterialPageRoute(builder: (context) => HisProfile(friend ,: l[index]["uid"])),
                      // );
                    },
                    child: RoundedListTile(
                      title: Text(localList[index]["name"].toString()),
                      leading: Image(image: AssetImage("assets/Icons/user.png"), height: 48, width: 48, fit: BoxFit.cover),
                      trailing: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover, image: AssetImage(index < 3 ? leaderboardIcons[index] : leaderboardIcons[3]))),
                      ),
                    ));
              })
          : WESpinKit(),
    );
  }
}
