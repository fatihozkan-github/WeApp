import 'package:WE/Screens/BottomNavigation/Leaderboard/leaderboard.dart';
import 'package:WE/Screens/BottomNavigation/Map/map_view.dart';
import 'package:WE/Screens/BottomNavigation/Offers/new_prize_page.dart';
import 'package:WE/Screens/BottomNavigation/Offers/prizes.dart';
import 'package:WE/Screens/BottomNavigation/QR/new_qr_page.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/profile_page.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WE/Screens/BottomNavigation/QR/qr_page.dart';
import 'package:WE/Screens/ProfileDrawer/profile_drawer.dart';
import '../../Resources/constants.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<String> avatarList = [];
  final currentUid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot snapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      avatarList.clear();
      avatarList.add(value);
    });
    checkReferralData();
  }

  Future<String> getData() async {
    var document = await users.doc(currentUid);
    document.get().then((value) => print(value));
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(currentUid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      var avatar = data['avatar'];
      return avatar;
    }
  }

  int selectedPage = 0;
  final _pageOptions = [
    ProfileDrawer(),
    MapView(),
    QRScanPage(),
    NewPrizePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WE',
        theme: ThemeData(
          canvasColor: kSecondaryColor,
          fontFamily: "Montserrat_Alternates",
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: _pageOptions[selectedPage],
          bottomNavigationBar: ConvexAppBar(
            items: [
              TabItem(
                  icon: Image.asset(
                      "assets/Images/BottomNavigation/homeIcon.png")),
              TabItem(
                  icon: Image.asset(
                "assets/Images/BottomNavigation/mapIcon.png",
                color: kThirdColor,
              )),
              TabItem(
                  icon: Image.asset("assets/Images/BottomNavigation/qrIcon.png",
                      color: kThirdColor)),
              TabItem(
                  icon: Image.asset(
                "assets/Images/BottomNavigation/privilege.png",
                color: kThirdColor,
              )),
              TabItem(
                  activeIcon: Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                  icon: Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                  )),
            ],
            activeColor: kPrimaryColor,
            backgroundColor: kPrimaryColor,
            initialActiveIndex: 0,
            onTap: (int i) {
              setState(() {
                selectedPage = i;
              });
            },
          ),
        ),
      ),
    );
  }
}
