import 'package:WE/Screens/BottomNavigation/Leaderboard/Tabs/global.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/hisprofile.dart';
import 'package:WE/Resources/components/rounded_list_tile.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/models/model_friend.dart';
import 'package:WE/Resources/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FriendsTab extends StatefulWidget {
  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<FriendModel> localFriends = [];

  @override
  void initState() {
    Provider.of<UserService>(context, listen: false).getFriends();
    localFriends = Provider.of<UserService>(context, listen: false).currentUser.friends;
    // print('localFriends $localFriends');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    localFriends = Provider.of<UserService>(context, listen: true).currentUser.friends;
    return Scaffold(body: localFriends.isNotEmpty ? _bodyWithFriends() : _bodyWithOutFriends());
  }

  Widget _bodyWithFriends() => ListView.builder(
      itemCount: localFriends.length,
      itemBuilder: (context, index) {
        return RoundedListTile(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => HisProfile(friend: localFriends[index]))),
          leading: Image(image: AssetImage("assets/Icons/user.png"), height: 48, width: 48, fit: BoxFit.cover),
          title: Text(localFriends[index].name),
          trailing: Image(
            image: AssetImage(index < 3 ? leaderboardIcons[index] : leaderboardIcons[3]),
            height: 48,
            width: 48,
            fit: BoxFit.cover,
          ),
        );
      });

  Column _bodyWithOutFriends() => Column(
        children: [
          SizedBox(height: 20),
          Padding(padding: const EdgeInsets.only(left: 32.0), child: Lottie.asset('assets/add_friend.json', repeat: false)),
          Container(
            decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(24.0),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
                child: Text(
              "Henüz hiç arkadaş eklemedin. Arkadaşlarını ekleyerek aranızdaki mücadeleyi buradan takip edebilirsin!",
              style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            )),
          ),
        ],
      );
}

final imagesPeople = [
  "assets/Images/People/larryPage.png",
  "assets/Images/People/alihan.png",
  "assets/Images/People/aysu.png",
  "assets/Images/People/sundarPichai.png",
];

// Container(
// height: 48,
// width: 48,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// image: DecorationImage(
// fit: BoxFit.cover,
// image:
// // localFriends[index].avatar == null
// //     ?
// AssetImage("assets/Icons/user.png")
// // :
// // NetworkImage(localFriends[index].avatar)
// )),
// ),
///
// future: users.doc(firebaseUser.uid).get(),
// builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// if (snapshot.hasError) {
// return Text("Something went wrong");
// }
// if (snapshot.connectionState == ConnectionState.done) {
// Map<String, dynamic> data = snapshot.data.data();
// if (data != null) {
// friends.clear();
// for (int i = 1; i < data.length + 1; i++) {
// Map map = data["friend" + i.toString()];
// friends.add(map);
// // TODO: implement points and friends tab
// friends.sort((a, b) => b["recycled"].compareTo(a["recycled"]));
// // print(friends);
// }
// }
