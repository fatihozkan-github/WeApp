// ignore_for_file: prefer_double_quotes, prefer_single_quotes, prefer_final_fields, always_declare_return_types, omit_local_variable_types, prefer_if_null_operators

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
import 'package:WE/Services/service_login.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';
import 'package:provider/provider.dart';
import '../../Services/profile_search.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileDrawerState();
}

class ProfileDrawerState extends State<ProfileDrawer> {
  UserModel currentUser = UserModel();
  List<Widget> drawerOptions = [];
  int _selectedDrawerIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    currentUser = Provider.of<UserService>(context, listen: false).currentUser;
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
    currentUser = Provider.of<UserService>(context, listen: true).currentUser;
    if (currentUser.userID == null && currentUser.userID == '') {
      _isLoading = true;
    } else {
      _isLoading = false;
    }
    return _isLoading
        ? WESpinKit()
        : Scaffold(
            appBar: _getAppBar(),
            body: _getDrawerItemWidget(_selectedDrawerIndex),
            drawer: _getDrawer(drawerOptions),
          );
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return FeedPage();
      //  case 1:
      //  return ChallengePage();
      case 1:
        return BadgePage();
      case 2:
        return DuelsPage();
      //case 4:
      //return EntertainmentPage();
      // case 4:
      //   return LessonsPage();
      case 3:
        return InvitePage();
      case 4:
        return FeedbackPage();
      //case 7:
      //return SupportPage();

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => _getDrawerItemWidget(index)));

  AppBar _getAppBar() => AppBar(
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
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text("WE"),
      );

  Drawer _getDrawer(drawerOptions) => Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
                    child: currentUser.avatar != null
                        ? Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(currentUser.avatar))),
                          )
                        : Icon(Icons.account_circle_rounded, size: 80, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.superhero == null ? 'Kahraman İsmi Girilmedi!' : currentUser.superhero,
                          style: TextStyle(color: kThirdColor),
                        ),
                        SizedBox(height: 5),
                        Text(
                          currentUser.name == null ? 'İsim Girilmedi!' : currentUser.name,
                          style: TextStyle(color: kThirdColor),
                        ),
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
                  await Provider.of<LoginService>(context, listen: false).log_out(
                      function: () => Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (bc) => WelcomeScreen()), (route) => false));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Çıkış yap ", style: TextStyle(color: Colors.grey)),
                        Icon(Icons.logout, color: Colors.grey),
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
    DrawerItem(title: "Home", icon: Icons.help),
    //DrawerItem(title: "Meydan oku", icon: Icons.whatshot),
    // DrawerItem(title: "Did you know these?", icon: Icons.wb_incandescent),
    //  DrawerItem(title: "Eğitim", icon: Icons.book_outlined),
    // DrawerItem(title: "Destek", icon: Icons.help),
  ];
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
//   accountName: Text(currentUser.superhero == null ? 'Kahraman İsmi Girilmedi!' : currentUser.superhero,
//       style: TextStyle(color: kThirdColor)),
//   accountEmail:
//       Text(currentUser.name == null ? 'İsim Girilmedi!' : currentUser.name, style: TextStyle(color: kThirdColor)),
//   currentAccountPicture: GestureDetector(
//     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
//     child: currentUser.avatar != null
//         ? Container(
//             height: 110,
//             width: 220,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(currentUser.avatar))),
//           )
//         : Icon(Icons.account_circle_rounded, size: 80, color: Colors.white),
//   ),
// ),
