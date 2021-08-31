import 'package:WE/Screens/Intro/onboarding_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Resources/SizeConfig.dart';
import 'Resources/constants.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WE());
}

class WE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(
          loadingText: Text(
            "from the WE Team",
            style: TextStyle(color: Colors.white),
          ),
          photoSize: 240,
          seconds: 2,
          navigateAfterSeconds: AfterSplash(),
          image: Image.asset(
            // TODO: gif düzenle
            "assets/we2.png",
            alignment: Alignment.center,
            width: 160,
          ),
          backgroundColor: kSecondaryColor,
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
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'WE',
              theme: ThemeData(
                canvasColor: kSecondaryColor,
                fontFamily: "Montserrat_Alternates",
                primaryColor: kPrimaryColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: FirstScreen(),
            );
          },
        );
      },
    );
  }
}
