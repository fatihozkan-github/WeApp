import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Screens/BottomNavigation/bottom_navigation.dart';

class MyApp extends StatefulWidget {
  MyApp({this.child});
  final Widget child;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamController<bool> _showLockScreenStream = StreamController();
  StreamSubscription _showLockScreenSubs;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final databaseReference = FirebaseDatabase.instance.reference();

  setFalse() async {
    print('hi');
    await databaseReference.child('/3566/IS_USING').set(false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _showLockScreenSubs = _showLockScreenStream.stream.listen((bool show) {
      if (mounted && show) {
        _showLockScreenDialog();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _showLockScreenSubs?.cancel();
    super.dispose();
  }

  // Listen for when the app enter in background or foreground state.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setFalse();
      _showLockScreenStream.add(true);
    } else if (state == AppLifecycleState.inactive) {
      setFalse();
      _showLockScreenStream.add(true);
    } else if (state == AppLifecycleState.paused) {
      setFalse();
      _showLockScreenStream.add(true);
    } else if (state == AppLifecycleState.detached) {
      setFalse();
      _showLockScreenStream.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      home: widget.child,
    );
  }

  void _showLockScreenDialog() {
    _navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return BottomNavigation();
    }));
  }
}