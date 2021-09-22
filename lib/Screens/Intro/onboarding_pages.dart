import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/Intro/welcome_screen.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class FirstScreen extends StatefulWidget {
  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen>
    with AfterLayoutMixin<FirstScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirstOpen", "false");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildImage(String assetName, {double scale, double width = 350}) {
    return Image.asset(
      'assets/$assetName',
      width: width,
      scale: scale,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: kSecondaryColor);

    const pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.only(top: 50),
      titleTextStyle: TextStyle(
          color: kSecondaryColor, fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 50),
    );
    const initialPageDecoration = PageDecoration(
      contentPadding: EdgeInsets.only(top: 50),
      titleTextStyle: TextStyle(
          color: kSecondaryColor, fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 50),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: RichText(
            text: TextSpan(
                text: "Kazançlı",
                children: [
                  TextSpan(
                      text: " ve",
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                  TextSpan(
                    text: " Oyunlaştırılmış",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text: " geri dönüşüm",
                      style: TextStyle(
                        color: Color(0xFF8CC8EE),
                        fontWeight: FontWeight.bold,
                      )),
                ],
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            textAlign: TextAlign.center,
          ),
          body: "Hadi, bugünün plastik geri dönüşümünü birlikte dönüştürelim!",
          image: _buildImage('we2.png', scale: 1.2),
          decoration: initialPageDecoration,
        ),
        PageViewModel(
          title: "Plastik Atıkları Geri Dönüştür",
          body:
              "HeroStation'ların üst kısmındaki QR kodu veya 4 haneli kodu kullanarak plastik atıklarınızı geri dönüştürebilirsin.",
          image: _buildImage('Images/Onboarding/intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Senin etkin",
          body: "Çevreye olan pozitif etkini takip et.",
          image: _buildImage('Images/Onboarding/intro2.png', scale: 0.4),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ödülü al",
          body: "Fırsat ve ayrıcalıkların tadını çıkar.",
          image: _buildImage('Images/Onboarding/intro3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
            title: "Takip et",
            body: "Arkadaşlarının WE'deki hareketlerini takip edebilirsin.",
            image: _buildImage('Images/Onboarding/intro4.png'),
            decoration: pageDecoration),
        PageViewModel(
            title: "Eğlen!",
            image: _buildImage('Images/Onboarding/intro5.png'),
            bodyWidget: Wrap(children: [
              Text(
                  "Daha fazla rozet ve WE coin kazanmak için meydan okumaları tamamlayabilir ve eğlenmek için diğer insanlarla düello yapabilirsin.",
                  textAlign: TextAlign.center,
                  style: bodyStyle)
            ]),
            decoration: pageDecoration),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text(
        'Geç',
        style: TextStyle(color: kSecondaryColor),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: kSecondaryColor,
      ),
      done: const Text('Bitti',
          style:
              TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      dotsDecorator: const DotsDecorator(
        activeColor: kPrimaryColor,
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
