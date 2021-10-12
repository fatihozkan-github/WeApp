// ignore_for_file: prefer_final_fields, omit_local_variable_types, prefer_single_quotes, missing_return

import 'dart:collection';
import 'package:WE/Screens/BottomNavigation/Map/map_view.dart';
import 'package:WE/Screens/BottomNavigation/Offers/new_prize_page.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/profile_page.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WE/Screens/BottomNavigation/QR/qr_page.dart';
import 'package:WE/Screens/ProfileDrawer/profile_drawer.dart';
import 'package:provider/provider.dart';
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
  int selectedPage = 0;
  final _pageOptions = [ProfileDrawer(), MapView(), QRScanPage(), NewPrizePage(), ProfilePage()];

  /// We use ListQueue to stack visited pages. Generally, Flutter's Navigator does this for us.
  /// But in our case, we are not using navigator so we have to keep our own stack.
  ListQueue<int> _navStack = ListQueue();

  /// Finally, we update the state of ConvexAppBar by its key. See [_willPop].
  final GlobalKey<ConvexAppBarState> _convexAppBarKey = GlobalKey<ConvexAppBarState>();

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

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      avatarList.clear();
      avatarList.add(value);
    });
    checkReferralData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WE',
        theme: ThemeData(
          accentColor: Colors.orange,
          fontFamily: "Montserrat_Alternates",
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat_Alternates",
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: WillPopScope(onWillPop: _willPop, child: _pageOptions[selectedPage]),
          bottomNavigationBar: ConvexAppBar(
            key: _convexAppBarKey,
            items: itemList,
            activeColor: kPrimaryColor,
            backgroundColor: kPrimaryColor,
            initialActiveIndex: 0,
            onTap: _tapHandler,
          ),
        ),
      ),
    );
  }

  Future<bool> _willPop() async {
    bool returnValue = false;
    if (_navStack.isEmpty) returnValue = await _showDialog();
    if (_navStack.isNotEmpty) {
      setState(() {
        _navStack.removeLast();
        int position = _navStack.isEmpty ? 0 : _navStack.last;
        selectedPage = position;
        returnValue = false;
      });
    }
    _convexAppBarKey.currentState.tap(selectedPage);
    return returnValue;
  }

  _tapHandler(int index) {
    if (index != selectedPage) {
      _navStack.addLast(index);
      setState(() => selectedPage = index);
    }
  }

  _showDialog() async {
    return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Uygulamadan çıkmak istediğinize emin misiniz?'),
            actions: <Widget>[
              TextButton(child: Text('Hayır'), onPressed: () => Navigator.of(context).pop(false)),
              TextButton(child: Text('Evet'), onPressed: () => Navigator.of(context).pop(true)),
            ],
          );
        });
  }

  List<TabItem> itemList = [
    TabItem(icon: Image.asset("assets/Images/BottomNavigation/homeIcon.png")),
    TabItem(icon: Image.asset("assets/Images/BottomNavigation/mapIcon.png", color: kThirdColor)),
    TabItem(icon: Image.asset("assets/Images/BottomNavigation/qrIcon.png", color: kThirdColor)),
    TabItem(icon: Image.asset("assets/Images/BottomNavigation/privilege.png", color: kThirdColor)),
    TabItem(
        activeIcon: Icon(Icons.account_circle_rounded, color: Colors.white, size: 64),
        icon: Icon(Icons.account_circle_rounded, color: Colors.white))
  ];
}
