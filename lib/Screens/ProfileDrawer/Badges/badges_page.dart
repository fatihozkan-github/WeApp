// ignore_for_file: prefer_single_quotes

import 'dart:io';

import 'package:WE/Resources/components/social_icon.dart';
import 'package:WE/Resources/components/we_icon_button.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WE/Resources/components/pop_up.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

class BadgePage extends StatefulWidget {
  @override
  _BadgePageState createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  ScreenshotController screenshotController = ScreenshotController();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String _platformVersion = 'Unknown';

  Future<void> initPlatformState() async {
    String platformVersion;
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(firebaseUser.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
              appBar: AppBar(
                title: Text("Rozetler"),
                actions: [
                  Screenshot(
                    controller: screenshotController,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.3),
                                    title: Text("Şununla paylaş:"),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SocialIcon(
                                              iconSrc:
                                                  "assets/Icons/facebook64.png",
                                              press: () async {
                                                await screenshotController
                                                    .capture()
                                                    .then((image) async {
                                                  print('IMAGE: $image');
                                                  await SocialShare
                                                          .shareOptions("We")
                                                      .then((data) {
                                                    print(data);
                                                  });
                                                });
                                              },
                                            ),
                                            if (Platform.isAndroid)
                                              SocialIcon(
                                                iconSrc:
                                                    "assets/Icons/instagram2.png",
                                                press: () async {
                                                  /// TODO: Fix ASAP
                                                  // if(Platform.isAndroid) {
                                                  //   File file = await ImagePicker.pickImage(
                                                  //     source: ImageSource.gallery,
                                                  //   );
                                                  // } else if(Platform.isIOS) {
                                                  //   XFile file = await ImagePicker.pickImage(
                                                  //     source: ImageSource.gallery,
                                                  //   );
                                                  // }
                                                  // await SocialShare.shareInstagramStory(
                                                  //   file.path,
                                                  //   backgroundTopColor: "#ffffff",
                                                  //   backgroundBottomColor: "#FF6B00",
                                                  //   attributionURL: "https://deep-link-url",
                                                  // ).then((data) {
                                                  //   print(data);
                                                  // });
                                                },
                                              ),
                                            SocialIcon(
                                              iconSrc:
                                                  "assets/Icons/twitter.png",
                                              press: () async {
                                                await SocialShare.shareTwitter(
                                                  "We",
                                                  hashtags: [
                                                    "we",
                                                    "recycle",
                                                    "we-recycle-team"
                                                  ],
                                                  url: "",
                                                  trailingText: "",
                                                ).then((data) {
                                                  print(data);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SocialIcon(
                                              iconSrc:
                                                  "assets/Icons/linkedin.png",
                                              press: () async {
                                                await screenshotController
                                                    .capture()
                                                    .then((image) async {
                                                  await SocialShare
                                                          .shareOptions("We")
                                                      .then((data) {
                                                    print(data);
                                                  });
                                                });
                                              },
                                            ),
                                            SocialIcon(
                                              iconSrc:
                                                  "assets/Icons/upload.png",
                                              press: () async {
                                                await screenshotController
                                                    .capture()
                                                    .then((image) async {
                                                  await SocialShare
                                                          .shareOptions("We")
                                                      .then((data) {
                                                    print(data);
                                                  });
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                              });
                        },
                        icon: Icon(Icons.share)),
                  )
                ],
              ),
              backgroundColor: Colors.white,
              body: ListView(
                children: [
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    alignment: WrapAlignment.spaceEvenly,
                    runAlignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      WEIconButton(
                        title: 'DOSTLUK',
                        icon: Image.asset(
                            data["badges"]["badge1"]
                                ? allBadges[0][0]
                                : allBadges[0][1],
                            scale: 8),
                        onPressed: () {
                          if (data["badges"]["badge1"] == false) {
                            popUp(context, badges[0], true);
                          }
                        },
                      ),
                      WEIconButton(
                        title: 'ÖNCÜ',
                        icon: Image.asset(
                            data["badges"]["badge2"]
                                ? allBadges[1][0]
                                : allBadges[1][1],
                            scale: 8),
                        onPressed: () => popUp(context, badges[1], true),
                      ),
                      WEIconButton(
                        title: 'BİLGE',
                        icon: Image.asset(
                            data["badges"]["badge3"]
                                ? allBadges[2][0]
                                : allBadges[2][1],
                            scale: 8),
                        onPressed: () => popUp(context, badges[2], true),
                      ),
                      WEIconButton(
                        title: 'ÇAYLAK KAHRAMAN',
                        icon: Image.asset(
                            data["forbadgecount"] >= 3
                                ? allBadges[3][0]
                                : allBadges[3][1],
                            scale: 8),
                        onPressed: () => popUp(context, badges[3], true),
                      ),
                      WEIconButton(
                        title: 'HALK KAHRAMANI',
                        icon: Image.asset(
                            data["recycled"] >= 800
                                ? allBadges[4][0]
                                : allBadges[4][1],
                            scale: 8),
                        onPressed: () => popUp(context, badges[4], true),
                      ),
                      WEIconButton(
                          title: 'ŞAMPİYON',
                          icon: Image.asset(
                              data["badges"]["badge6"]
                                  ? allBadges[5][0]
                                  : allBadges[5][1],
                              scale: 8),
                          onPressed: () {
                            if (data["badges"]["badge6"] == false) {
                              popUp(context, badges[5], true);
                            }
                          }),
                      WEIconButton(
                        title: '',
                        icon: data["level"] < 10
                            ? Image.asset(
                                "assets/Images/Badges/Locked/inactiveBadgeX.png",
                                scale: 8)
                            : SizedBox(height: size.height * 0.01),
                        onPressed: () => popUp(
                            context,
                            "10. Seviyeye ulaştıktan sonra daha çok rozet görebileceksin!",
                            true),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
          return WESpinKit();
        });
  }
}

List<String> badges = [
  "2 arkadaşın onlara verdiğin kodla kayıt olmalı.",
  "WE'yi bir sosyal medya hesabında #werecycleteam hashtag'i ile paylaşmalısın.",
  "2 geri bildirim göndererek gelişime katkıda bulun.",
  "3 hafta boyunca en az 3 kez HeroStation'lardan dönüşüme katkıda bulunmalısınız.",
  "Dünyayı 800 gram geri dönüştürülemeyen plastikten kurtarmalısınız.",
  "15 arkadaşınız sizin için tanımlanmış kod ile WE'Nin bir parçası olmalıdır.",
];

List<String> badgesENG = [
  "2 of your friends must register with the code you gave them.",
  "You should share WE on a social media account with #werecycleteam hashtag.",
  "You must contribute to development by sending 2 feedbacks.",
  "You must contribute to the transformation from Herostations at least 3 times for 3 weeks.",
  "You have to save the earth from 800 grams of non-recyclable plastic.",
  "15 of your friends should be part of We with the code defined for you.",
];
List<List<String>> allBadges = [
  [
    "assets/Images/Badges/Unlocked/activeBadge1.png",
    "assets/Images/Badges/Locked/inactiveBadge1.png"
  ],
  [
    "assets/Images/Badges/Unlocked/activeBadge2.png",
    "assets/Images/Badges/Locked/inactiveBadge2.png"
  ],
  [
    "assets/Images/Badges/Unlocked/activeBadge3.png",
    "assets/Images/Badges/Locked/inactiveBadge3.png"
  ],
  [
    "assets/Images/Badges/Unlocked/activeBadge4.png",
    "assets/Images/Badges/Locked/inactiveBadge4.png"
  ],
  [
    "assets/Images/Badges/Unlocked/activeBadge5.png",
    "assets/Images/Badges/Locked/inactiveBadge5.png"
  ],
  [
    "assets/Images/Badges/Unlocked/activeBadge6.png",
    "assets/Images/Badges/Locked/inactiveBadge6.png"
  ],
];

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if (data["badges"]["badge1"] == false) {
//               popUp(context, badges[0], true);
//             }
//           },
//           child: Image.asset(data["badges"]["badge1"] ? allBadges[0][0] : allBadges[0][1], scale: 8),
//         ),
//         Text("DOSTLUK", style: TextStyle(color: Colors.grey, fontSize: size.width * 0.045)),
//       ],
//     ),
//     Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             popUp(context, badges[1], true);
//           },
//           child: Image.asset(data["badges"]["badge2"] ? allBadges[1][0] : allBadges[1][1], scale: 8),
//         ),
//         Text("ÖNCÜ", style: TextStyle(color: Colors.grey, fontSize: size.width * 0.045)),
//       ],
//     ),
//   ],
// ),
// SizedBox(height: size.height * 0.04),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             popUp(context, badges[2], true);
//           },
//           child: Image.asset(data["badges"]["badge3"] ? allBadges[2][0] : allBadges[2][1], scale: 8),
//         ),
//         Text("BİLGE", style: TextStyle(color: Colors.grey, fontSize: size.width * 0.045)),
//       ],
//     ),
//     Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             popUp(context, badges[3], true);
//           },
//           child: Image.asset(data["forbadgecount"] >= 3 ? allBadges[3][0] : allBadges[3][1], scale: 8),
//         ),
//         Text("ÇAYLAK KAHRAMAN", style: TextStyle(color: Colors.grey, fontSize: size.width * 0.045)),
//       ],
//     ),
//   ],
// ),
// SizedBox(height: size.height * 0.04),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             popUp(context, badges[4], true);
//           },
//           child: Image.asset(data["recycled"] >= 800 ? allBadges[4][0] : allBadges[4][1], scale: 8),
//         ),
//         Text("HALK KAHRAMANI", style: TextStyle(color: Colors.grey, fontSize: size.width * 0.045)),
//       ],
//     ),
//     Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             if (data["badges"]["badge6"] == false) {
//               popUp(context, badges[5], true);
//             }
//           },
//           child: Image.asset(data["badges"]["badge6"] ? allBadges[5][0] : allBadges[5][1], scale: 8),
//         ),
//         Text("ŞAMPİYON", style: TextStyle(color: Colors.grey, fontSize: size.width * 0.045)),
//       ],
//     ),
//   ],
// ),
// SizedBox(height: size.height * 0.045),
// Column(
//   children: [
//     GestureDetector(
//       onTap: () {
//         popUp(context, "10. Seviyeye ulaştıktan sonra daha çok rozet görebileceksin!", true);
//         // You will be able to see more badges after you reach Level 10
//       },
//       child: data["level"] < 10
//           ? Image.asset("assets/Images/Badges/Locked/inactiveBadgeX.png", scale: 8)
//           : SizedBox(height: size.height * 0.01),
//     ),
//   ],
// ),
// SizedBox(height: size.height * 0.02),
