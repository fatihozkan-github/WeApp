// ignore_for_file: omit_local_variable_types, prefer_single_quotes

import 'package:WE/Resources/components/overScrollHandler.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DuelsPage extends StatefulWidget {
  @override
  _DuelsPageState createState() => _DuelsPageState();
}

/// TODO: Rework ASAP
class _DuelsPageState extends State<DuelsPage> {
  var currentUid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference challenges = FirebaseFirestore.instance.collection('challenges');
  Map data;
  List localList = [];
  List rawUserList = [];
  List userList = [];
  List timeList = [];
  bool _isLoading = true;
  List challengerRawList = [];
  List challengerNameList = [];
  List challengerTimeList = [];

  Future searchChallengeData() async {
    /// Get Challenges
    QuerySnapshot snapshot = await challenges.get();

    /// Search for challenges.
    snapshot.docs.toList().forEach((element) {
      Map map = element.data();
      if (map.keys.contains(currentUid)) {
        challengerRawList.add(element.id);
        map.values.toList().forEach((element) {
          /// Filter not accepted challenges.
          if (element['isAccepted'] == false) {
            challengerTimeList.add(element['time1']);
          }
        });
      }
    });

    /// Get challenger data
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for (int i = 0; i < challengerRawList.length; i++) {
      DocumentSnapshot rawData = await users.doc(challengerRawList[i]).get();
      data = rawData.data();
      challengerNameList.add(data['name']);
    }
  }

  Future getChallengeData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await challenges.doc(currentUid).get();
    data = snapshot.data();
    localList = data.keys.toList();
    for (int i = 0; i < localList.length; i++) {
      DocumentSnapshot userData = await users.doc(localList[i]).get();
      Map rawData = userData.data();
      rawUserList.add(rawData);
    }

    data.values.toList().forEach((element) {
      timeList.add(element['time1']);
    });

    if (localList.isNotEmpty) {
      rawUserList.forEach((element) {
        if (element != null) {
          userList.add(element['name']);
        }
      });
    }
  }

  getData() async {
    await searchChallengeData();
    await getChallengeData().onError((error, stackTrace) => print(error)).whenComplete(() => setState(() {
          _isLoading = false;
        }));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Düellolar')),
      body: _isLoading
          ? WESpinKit()
          : Column(
              children: [
                OverScroll(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: data[rawUserList[index]["uid"]]['isAccepted'] != true ? _duelWaiting(index) : _duelAccepted(index),
                      );
                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: challengerRawList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        /// TODO
                        title: Text(challengerNameList[index] + ' seni düelloya davet etti!'),
                        trailing: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              FirebaseFirestore.instance.collection('challenges').doc(challengerRawList[index]).update({
                                currentUid: {
                                  'isAccepted': true,
                                  'time1': DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now()),
                                }
                              }).onError((error, stackTrace) => print(error));
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: _getFAB(),
    );
  }

  ListTile _duelWaiting(index) => ListTile(
        title: Text(userList[index] + ' düelloya davet edildi!'),
        subtitle: Text(userList[index] + " düellonu kabul edince burada görebileceksin!"),
      );

  ListTile _duelAccepted(index) => ListTile(
        title: Text(userList[index] + ' ile şu anda bir düellodasın.'),
        subtitle: Text(timeList[index] + "'e kadar mücadele et!"),
        trailing: Icon(Icons.local_police_rounded),
      );

  FloatingActionButton _getFAB() => FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.local_police_rounded, color: Colors.white),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Düellolar hakkında bilgi'),
                  content: Text(
                      'Bu saydada sana meydan okunmuş düelloları görebilir ve onları kabul edebilirsin. Düello bitim tarihine kadar kim daha fazla geri dönüşüm yaparsa düelloya girdiği kişinin coinlerini de alır. Düelloyu kaybeden kişi ise kazandığı coinleri kaybeder. Düelloya girmeden önce iyi düşün, bu riskli bir iş!'),
                  actions: [
                    TextButton(
                      child: Text('Tamam', style: TextStyle(color: kPrimaryColor)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              });
        },
      );
}

/// old
// FutureBuilder<DocumentSnapshot>(
//     future: challenges.doc(currentUid).get(),
//     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//       if (snapshot.hasError) {
//         return Text("Something went wrong");
//       }
//       if (snapshot.connectionState == ConnectionState.done) {
//         Map<String, dynamic> data = snapshot.data.data();
//         print(data);
//         if (data != null) {
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               return Card(
//                   elevation: 10,
//                   child: data["user" + (index + 1).toString()]["isAccepted"] != true
//                       ? ListTile(
//                           title: Text(data["user" + (index + 1).toString()]["name"] + " sana düello teklif etti"),
//                           subtitle: Text(data["user" + (index + 1).toString()]["time1"] + "'e kadar."),
//                           trailing: IconButton(
//                             icon: Icon(Icons.check),
//                             onPressed: () {
//                               setState(() {
//                                 FirebaseFirestore.instance.collection('challenges').doc(currentUid).update({
//                                   "user" + (index + 1).toString(): {
//                                     "isAccepted": true,
//                                     "name": data["user" + (index + 1).toString()]["name"],
//                                     "time1": data["user" + (index + 1).toString()]["time1"],
//                                     "time2": formattedDate,
//                                   }
//                                 });
//                               });
//                             },
//                           ),
//                         )
//                       : ListTile(
//                           title: Text(data["user" + (index + 1).toString()]["name"] + " ile şu anda bir düellodasın."),
//                           subtitle: Text(data["user" + (index + 1).toString()]["time1"] + "'e kadar daha mücadele et."),
//                           trailing: Icon(Icons.local_police_rounded),
//                         ));
//             },
//           );
//         } else {
//           return Column(
//             children: [
//               SizedBox(height: size.height * 0.1),
//               GestureDetector(
//                 onTap: () {
//                   //Navigator.push(
//                   //                           context,
//                   //                           MaterialPageRoute(
//                   //                             builder: (context) {
//                   //                               return Leaderboard();
//                   //                             },
//                   //                           ),
//                   //                         );
//                 },
//                 child: Container(
//                   width: size.width * 0.8,
//                   height: size.height * 0.2,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: kPrimaryColor),
//                     borderRadius: BorderRadius.circular(32),
//                   ),
//                   child: Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Center(
//                           child: Text(
//                         "Şu anda herhangi bir düellon veya davetin bulunmuyor. Hadi sen arkadaşlarını düelloya davet ederek başla!",
//                         style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
//                       ))),
//                 ),
//               ),
//               SizedBox(height: size.height * 0.05),
//               Lottie.asset('assets/vs.json'),
//             ],
//           );
//         }
//       }
//       return WESpinKit();
//     }),
