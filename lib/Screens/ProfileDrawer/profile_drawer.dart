// ignore_for_file: prefer_double_quotes, prefer_single_quotes, prefer_final_fields, always_declare_return_types, omit_local_variable_types

import 'package:WE/Resources/components/drawer_item.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/leaderboard.dart';
import 'package:WE/Screens/Intro/welcome_screen.dart';
import 'package:WE/Screens/ProfileDrawer/Badges/badges_page.dart';
import 'package:WE/Screens/ProfileDrawer/Duels/duel_page.dart';
import 'package:WE/Screens/ProfileDrawer/Invite/invite.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/profile_page.dart';
import 'package:WE/Screens/ProfileDrawer/Feedback/feedback_page.dart';
import 'package:WE/Screens/BottomNavigation/Feed/feed_deneme.dart';
import 'package:WE/Screens/ProfileDrawer/training_set/page/training_set.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/profile_search.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileDrawerState();
}

class ProfileDrawerState extends State<ProfileDrawer> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  List<Widget> drawerOptions = [];
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    for (var i = 0; i < drawerItems.length - 1; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
        ListTile(
          leading: Icon(d.icon, color: kPrimaryColor),
          title: Text(d.title, style: TextStyle(color: Colors.black)),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i + 1),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    /// TODO: Move
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(firebaseUser.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
              appBar: _getAppBar(),
              body: _getDrawerItemWidget(_selectedDrawerIndex),
              drawer: _getDrawer(data, drawerOptions),
            );
          }
          return WESpinKit();
        });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return FeedPage();
      case 1:
        return BadgePage();
      case 2:
        return DuelsPage();
      case 3:
        return InvitePage();
      case 4:
        return FeedbackPage();
      case 5:
        return TrainingSet();
      //  case 1:
      //  return ChallengePage();
      //case 4:
      //return EntertainmentPage();
      // case 4:
      //   return LessonsPage();
      //case 7:
      //return SupportPage();

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => _getDrawerItemWidget(index)));

  _getAppBar() => AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white, size: 30),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage())),
          ),
          IconButton(
            icon: Container(
                width: 30,
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: kPrimaryColor,
                  child: Image.asset("assets/Images/BottomNavigation/leaderboardIcon.png", color: Colors.white),
                )),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderBoard())),
          )
        ],
        title: Text("WE"),
      );

  _getDrawer(data, drawerOptions) => Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
                    child: data["avatar"] != null && data["avatar"] != ''
                        ? Container(
                            height: 110,
                            width: 110,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: CachedNetworkImage(
                              imageUrl: data["avatar"].toString(),
                              progressIndicatorBuilder: (context, url, progress) => WESpinKit(color: Colors.white),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.account_circle_rounded, size: 80, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data["name"].toString().trim().isEmpty ? 'İsim Girilmedi!' : data["name"],
                            style: TextStyle(color: kThirdColor, fontSize: 19)),
                        SizedBox(height: 5),
                        Text(
                            data["superhero"] == null || data["superhero"] == '' ? 'Kahraman İsmi Girilmedi!' : data["superhero"],
                            style: TextStyle(color: kThirdColor, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(children: drawerOptions),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');
                  await logout();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Çıkış yap ", style: TextStyle(color: Colors.grey)),
                        Icon(Icons.cancel_presentation, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  List<DrawerItem> drawerItems = [
    DrawerItem(title: "Rozetler", icon: Icons.badge),
    DrawerItem(title: "Düello", icon: Icons.local_police_rounded),
    DrawerItem(title: "Davet et ve Kazan", icon: Icons.share),
    DrawerItem(title: "Geri bildirim", icon: Icons.assistant_photo_rounded),
    DrawerItem(title: "Eğitim Seti", icon: Icons.collections_bookmark),
    DrawerItem(title: "Home", icon: Icons.help),
    //DrawerItem(title: "Meydan oku", icon: Icons.whatshot),
    // DrawerItem(title: "Did you know these?", icon: Icons.wb_incandescent),
    //  DrawerItem(title: "Eğitim", icon: Icons.book_outlined),
    // DrawerItem(title: "Destek", icon: Icons.help),
  ];

  Future logout() async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()), (route) => false));
  }
}

/// Drawer Items
// final drawerTitles = [
//   //DrawerItem(title: "Meydan oku", icon: Icons.whatshot),
//   DrawerItem(title: "Rozetler", icon: Icons.badge),
//   DrawerItem(title: "Düello", icon: Icons.local_police_rounded),
//   //DrawerItem(title: "Entertainment", icon: Icons.wb_incandescent),
//   // DrawerItem(title: "Eğitim", icon: Icons.book_outlined),
//   DrawerItem(title: "Davet et ve Kazan", icon: Icons.share),
//   DrawerItem(title: "Geri bildirim", icon: Icons.assistant_photo_rounded),
//   // DrawerItem(title: "Destek", icon: Icons.help),
//   DrawerItem(title: "Home", icon: Icons.help),
// ];
///
// UserAccountsDrawerHeader(
//   decoration: BoxDecoration(color: kPrimaryColor),
//   accountName: Text(
//       data["superhero"] == null || data["superhero"] == '' ? 'Kahraman İsmi Girilmedi!' : data["superhero"],
//       style: TextStyle(color: kThirdColor)),
//   accountEmail: Text(data["name"].toString().trim().isEmpty ? 'İsim Girilmedi!' : data["name"],
//       style: TextStyle(color: kThirdColor)),
//   currentAccountPicture: GestureDetector(
//     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
//     child: data["avatar"] != null
//         ? Container(
//             height: 110,
//             width: 220,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"]))),
//           )
//         : Icon(Icons.account_circle_rounded, size: 80, color: Colors.white),
//   ),
// ),
