// ignore_for_file: prefer_final_fields, prefer_single_quotes

import 'package:WE/Resources/components/rounded_list_tile.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import '../../../ProfileDrawer/Profile/hisprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../global.dart';

class LeaderBoardTab extends StatefulWidget {
  @override
  _LeaderBoardTabState createState() => _LeaderBoardTabState();
}

class _LeaderBoardTabState extends State<LeaderBoardTab> {
  List localBoardList = [];
  bool _isLoading = true;

  void leaderBoardFunction() async {
    await FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        localBoardList.add({
          "uid": result.id,
          "recycled": result.data()["recycled"],
          "name": result.data()["name"],
          "avatar": result.data()["avatar"],
        });
        localBoardList.sort((a, b) => b["recycled"].compareTo(a["recycled"]));
      });
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  void initState() {
    super.initState();
    leaderBoardFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: localBoardList.length,
              itemBuilder: (context, index) {
                return RoundedListTile(
                  title: Text(localBoardList[index]["name"].toString()),
                  leading: Container(
                    width: 48,
                    height: 48,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image(
                      image: localBoardList[index]["avatar"] != null
                          ? NetworkImage(localBoardList[index]["avatar"].toString())
                          : AssetImage("assets/Icons/user.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  trailing: Image(
                    image: AssetImage(index < 3 ? leaderboardIcons[index] : leaderboardIcons[3]),
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HisProfile(uid: localBoardList[index]["uid"]))),
                );
              })
          : WESpinKit(),
    );
  }
}

///
// body: l.length > 0
//     ? ListView.builder(
//         itemCount: l.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HisProfile(uid: l[index]["uid"])),
//               );
//             },
//             child: Card(
//                 child: Container(
//               decoration: const BoxDecoration(
//                 border: Border(
//                   top: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
//                   left: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
//                   right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
//                   bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
//                 ),
//               ),
//               child: ListTile(
//                   trailing: Container(
//                     height: 48,
//                     width: 48,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: AssetImage(index < 3 ? leaderboardIcons[index] : leaderboardIcons[3]))),
//                   ),
//                   leading: Container(
//                     height: 48,
//                     width: 48,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/Icons/user.png"))),
//                   ),
//                   title: Text(l[index]["name"].toString())),
//             )),
//           );
//         })
//     : WESpinKit(),
// Center(child: CircularProgressIndicator()),
