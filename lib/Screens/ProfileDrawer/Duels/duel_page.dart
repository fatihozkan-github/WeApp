import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/Leaderboard/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DuelsPage extends StatefulWidget {
  @override
  _DuelsPageState createState() => _DuelsPageState();
}

class _DuelsPageState extends State<DuelsPage> {
  var currentUid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

    CollectionReference challenges =
        FirebaseFirestore.instance.collection('challenges');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.local_police_rounded),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    insetPadding:
                        EdgeInsets.symmetric(vertical: size.height * 0.3),
                    title: Text("Düellolar hakkında bilgi"),
                    content: Text(
                        "Bu saydada sana meydan okunmuş düelloları görebilir ve onları kabul edebilirsin. Düello bitim tarihine kadar kim daha fazla geri dönüşüm yaparsa düelloya girdiği kişinin coinlerini de alır. Düelloyu kaybeden kişi ise kazandığı coinleri kaybeder. Düelloya girmeden önce iyi düşün, bu riskli bir iş!"));
              });
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Düellolar',
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: challenges.doc(currentUid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();

              if (data != null) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: data["user" + (index + 1).toString()]
                                    ["isAccepted"] !=
                                true
                            ? ListTile(
                                title: Text(
                                    data["user" + (index + 1).toString()]
                                            ["name"] +
                                        " sana düello teklif etti"),
                                subtitle: Text(
                                    data["user" + (index + 1).toString()]
                                            ["time1"] +
                                        "'e kadar."),
                                trailing: IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection('challenges')
                                          .doc(currentUid)
                                          .update({
                                        "user" + (index + 1).toString(): {
                                          "isAccepted": true,
                                          "name": data["user" +
                                              (index + 1).toString()]["name"],
                                          "time1": data["user" +
                                              (index + 1).toString()]["time1"],
                                          "time2": formattedDate,
                                        }
                                      });
                                    });
                                  },
                                ),
                              )
                            : ListTile(
                                title: Text(
                                    data["user" + (index + 1).toString()]
                                            ["name"] +
                                        " ile şu anda bir düellodasın."),
                                subtitle: Text(
                                    data["user" + (index + 1).toString()]
                                            ["time1"] +
                                        "'e kadar daha mücadele et."),
                                trailing: Icon(Icons.local_police_rounded),
                              ));
                  },
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.1),
                    GestureDetector(
                      onTap: () {
                        //Navigator.push(
                        //                           context,
                        //                           MaterialPageRoute(
                        //                             builder: (context) {
                        //                               return Leaderboard();
                        //                             },
                        //                           ),
                        //                         );
                      },
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                                child: Text(
                              "Şu anda herhangi bir düellon veya davetin bulunmuyor. Hadi sen arkadaşlarını düelloya davet ederek başla!",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ))),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Lottie.asset('assets/vs.json'),
                  ],
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
