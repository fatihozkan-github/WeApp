import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:WE/Screens/Intro/welcome_screen.dart';
import 'package:WE/Services/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isLoggedIn == false
            ? BottomNavigation()
            : SplashScreen(
                loadingText:
                    Text("WE ekibinden", style: TextStyle(color: Colors.white)),
                seconds: 0,
                navigateAfterSeconds: AfterSplash(),
                image: Image.asset("assets/we2.png",
                    alignment: Alignment.center, width: 160),
                // backgroundColor: kSecondaryColor,
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
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => LoginService()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'WE',
                theme: ThemeData(
                  accentColor: Colors.orange,
                  fontFamily: "Montserrat_Alternates",
                  primaryColor: kPrimaryColor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: WelcomeScreen(),
              ),
            );
          },
        );
      },
    );
  }
}

// ? Scaffold(body: BottomNavigation())
// : Scaffold(
//     body: SplashScreen(
//       loadingText: Text("WE ekibinden", style: TextStyle(color: Colors.white)),
//       photoSize: 240,
//       seconds: 0,
//       navigateAfterSeconds: AfterSplash(),
//       image: Image.asset("assets/we2.png", alignment: Alignment.center, width: 160),
//       backgroundColor: kSecondaryColor,
//     ),
//   ));
