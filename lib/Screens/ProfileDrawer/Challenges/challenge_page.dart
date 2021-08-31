import 'package:WE/Resources/SizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/constants.dart';

class ChallengePage extends StatelessWidget {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
                centerTitle: true,
                title: Text(
                  "Meydan okumalar",
                  style: TextStyle(fontFamily: "Panthera", fontSize: 24),
                ),
              ),
              backgroundColor: Color(0xFF1B1B1B),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        indicator: data["avatar"] != null
                            ? Container(
                                height: 11 * SizeConfig.heightMultiplier,
                                width: 22 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(data["avatar"]))),
                              )
                            : Icon(
                                Icons.account_circle_rounded,
                                size: 60,
                                color: Colors.grey,
                              ),
                      ),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      hasIndicator: false,
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      endChild: const _Child(
                        textSize: 30,
                        text: "  Cesaret et!",
                      ),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    const TimelineDivider(
                      begin: 0.1,
                      end: 0.8,
                      thickness: 20,
                      color: kPrimaryColor,
                    ),
                    TimelineTile(
                      startChild: Padding(
                        padding: const EdgeInsets.only(right: 32.0, top: 15),
                        child: const _Child(
                          text: "AZIM",
                          textSize: 30,
                        ),
                      ),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.8,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                    ),
                    TimelineTile(
                      startChild: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const _Child(
                            textSize: 20,
                            text:
                                "WE dünyasına katılarak ilk meydan okumayı kazandın. Umarım bu şekilde devam eder ve azminle birlikte dünyayı daha güzel bir yer haline getiririz."),
                      ),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.8,
                      indicatorStyle: IndicatorStyle(
                        width: 150,
                        height: 150,
                        padding: EdgeInsets.symmetric(vertical: 1),
                        indicator: IconButton(
                          iconSize: 100,
                          icon: Image.asset('assets/Icons/perserverance.png'),
                          onPressed: () {
                            popUp(
                                context, "Azminle göz kamaştırıyorsun!", true);
                          },
                        ),
                      ),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.8,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    const TimelineDivider(
                      begin: 0.15,
                      end: 0.8,
                      thickness: 20,
                      color: kPrimaryColor,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.15,
                      hasIndicator: false,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      endChild: Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: const _Child(
                          textSize: 20,
                          text:
                              "Dünyanın 1024 gram plastikten kurtlamasını sağla",
                        ),
                      ),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      indicatorStyle: IndicatorStyle(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          indicator: data["recycled"] >= 1024
                              ? Icon(
                                  Icons.check,
                                  color: kPrimaryColor,
                                  size: size.width * 0.2,
                                )
                              : IconButton(
                                  onPressed: () {
                                    popUp(
                                        context,
                                        "Bu kilidi açmak için meydan okumayı tamamlamalısın",
                                        true);
                                  },
                                  icon:
                                      Image.asset('assets/Icons/padlock.png'))),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.15,
                      hasIndicator: false,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    const TimelineDivider(
                      begin: 0.15,
                      end: 0.85,
                      thickness: 20,
                      color: kPrimaryColor,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.85,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                    ),
                    TimelineTile(
                      startChild: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: const _Child(
                          textSize: 20,
                          text:
                              "5 arkadaşının WE'nin bir parçası olmasına öncülük et!",
                        ),
                      ),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.85,
                      indicatorStyle: IndicatorStyle(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        indicator: data["badges"]["challenges"]
                            ? Icon(
                                Icons.check,
                                color: kPrimaryColor,
                                size: size.width * 0.2,
                              )
                            : IconButton(
                                onPressed: () {
                                  popUp(
                                      context,
                                      "Bu kilidi açmak için meydan okumayı tamamlamalısın",
                                      true);
                                },
                                icon: Image.asset('assets/Icons/padlock.png')),
                      ),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.85,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    const TimelineDivider(
                      begin: 0.15,
                      end: 0.85,
                      thickness: 20,
                      color: kPrimaryColor,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.15,
                      hasIndicator: false,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      endChild: Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: const _Child(
                          textSize: 20,
                          text:
                              "2 geri bildirim yollayarak gelişimin parçası ol!",
                        ),
                      ),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.15,
                      indicatorStyle: IndicatorStyle(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        indicator: IconButton(
                            onPressed: () {
                              popUp(
                                  context,
                                  "Bu kilidi açmak için meydan okumayı tamamlamalısın",
                                  true);
                            },
                            icon: Image.asset('assets/Icons/padlock.png')),
                      ),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.15,
                      hasIndicator: false,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    const TimelineDivider(
                      begin: 0.15,
                      end: 0.85,
                      thickness: 20,
                      color: kPrimaryColor,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.85,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                    ),
                    TimelineTile(
                      startChild: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: const _Child(
                          textSize: 20,
                          text:
                              "Sosyal medyada farkındalık arttırıcı şeyler paylaş",
                        ),
                      ),
                      alignment: TimelineAlign.manual,
                      lineXY: 0.85,
                      indicatorStyle: IndicatorStyle(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        indicator: IconButton(
                            onPressed: () {
                              popUp(
                                  context,
                                  "Bu kilidi açmak için meydan okumayı tamamlamalısın",
                                  true);
                            },
                            icon: Image.asset('assets/Icons/padlock.png')),
                      ),
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.85,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                    ),
                    const TimelineDivider(
                      begin: 0.5,
                      end: 0.85,
                      thickness: 20,
                      color: kPrimaryColor,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.5,
                      beforeLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      afterLineStyle: const LineStyle(
                        color: kPrimaryColor,
                        thickness: 20,
                      ),
                      hasIndicator: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconButton(
                          iconSize: 200,
                          icon: Image.asset("assets/heroStationIcon.png"),
                          onPressed: () {
                            popUp(
                                context,
                                "Büyük meydan okumaya ulaşmak için önce diğerlerini tamamlamalısın.",
                                true);
                          }),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class _Child extends StatelessWidget {
  final String text;
  final double textSize;

  const _Child({
    @required this.text,
    @required this.textSize,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 120),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: textSize),
        ),
      ),
    );
  }
}
