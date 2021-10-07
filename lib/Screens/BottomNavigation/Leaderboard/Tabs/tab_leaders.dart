// ignore_for_file: override_on_non_overriding_member, prefer_final_fields

import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/tab_friends.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/hisprofile.dart';
import 'package:WE/Resources/components/rounded_list_tile.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Services/service_general.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/models/model_friend.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LeadersTab extends StatefulWidget {
  @override
  _LeadersTabState createState() => _LeadersTabState();
}

class _LeadersTabState extends State<LeadersTab> {
  List<FriendModel> localList = [];
  bool _isLoading = true;

  Future getLeaderBoard() async {
    localList = await Provider.of<GeneralServices>(context, listen: false).getLeaderBoard();
    await Provider.of<UserService>(context, listen: false).getFriends();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    getLeaderBoard();
    super.initState();
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
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HisProfile(friend: localList[index]))),
                    child: RoundedListTile(
                      title: Text(localList[index].name.toString()),
                      leading: Image(image: AssetImage("assets/Icons/user.png"), height: 48, width: 48, fit: BoxFit.cover),
                      trailing: Image(
                        image: AssetImage(index < 3 ? leaderboardIcons[index] : leaderboardIcons[3]),
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                      ),
                    ));
              })
          : WESpinKit(),
    );
  }
}
