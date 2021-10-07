// ignore_for_file: deprecated_member_use

import 'package:WE/API/API_general_services.dart';
import 'package:WE/API/API_initials.dart';
import 'package:WE/API/API_login.dart';
import 'package:WE/API/API_user_service.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:WE/Screens/Intro/welcome_screen.dart';
import 'package:WE/Services/service_general.dart';
import 'package:WE/Services/service_login.dart';
import 'package:WE/Services/service_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Resources/SizeConfig.dart';
import 'Resources/constants.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  runApp(WE(isLoggedIn: status == true ? false : true));
}

class WE extends StatelessWidget {
  WE({
    Key key,
    this.isLoggedIn,
  }) : super(key: key);

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => APIInitials()),
        ChangeNotifierProvider(create: (context) => APILogin()),
        ChangeNotifierProvider(create: (context) => APIGeneralServices()),
        ChangeNotifierProvider(create: (context) => APIUserService()),
        ChangeNotifierProvider(create: (context) => GeneralServices()),
        ChangeNotifierProvider(create: (context) => LoginService()),
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WE',
        theme: ThemeData(
          accentColor: kPrimaryColor,
          fontFamily: 'Montserrat_Alternates',
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat_Alternates',
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: kPrimaryColor,
          ),
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: isLoggedIn == false
              ? BottomNavigation()
              : SplashScreen(
                  loadingText: Text('WE ekibinden', style: TextStyle(color: Colors.white)),
                  photoSize: 240,
                  seconds: 0,
                  navigateAfterSeconds: AfterSplash(),
                  image: Image.asset('assets/we2.png', alignment: Alignment.center, width: 160),
                  // backgroundColor: kSecondaryColor,
                ),
        ),
      ),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return WelcomeScreen();
          },
        );
      },
    );
  }
}
