// ignore_for_file: omit_local_variable_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

void createChallenge(currentUserID, targetUserID) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);

  var documentSnapshot = await FirebaseFirestore.instance.collection('challenges').doc(currentUserID).get();

  if (documentSnapshot.exists) {
    await FirebaseFirestore.instance.collection('challenges').doc(currentUserID).update({
      targetUserID: {"isAccepted": false, "time1": formattedDate}
    });
    SetOptions(merge: true);
  } else {
    await FirebaseFirestore.instance.collection('challenges').doc(currentUserID).set({
      targetUserID: {"isAccepted": false, "time1": formattedDate}
    });
    SetOptions(merge: true);
  }
}

void approveChallenge(name, currentUser) async {
  var documentSnapshot;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  documentSnapshot = await FirebaseFirestore.instance.collection('challenges').doc(name).get();

  await FirebaseFirestore.instance.collection('challenges').doc(name).update({
    "user" + (documentSnapshot.data().length + 1).toString(): {"isAccepted": false, "time1": formattedDate, "name": currentUser}
  });
  SetOptions(merge: true);
}

void checkChallenges(name) async {
  DocumentSnapshot documentSnapshot;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  documentSnapshot = await FirebaseFirestore.instance.collection('challenges').doc("challenges").get();

  if (documentSnapshot != null) {
    print(documentSnapshot.data());
  } else {
    print("nullkksd");
  }
}

/// old
// void createChallenge(name, currentUser) async {
//   var documentSnapshot;
//   DateTime now = DateTime.now();
//   String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
//
//   documentSnapshot = await FirebaseFirestore.instance.collection('challenges').doc(name).get();
//
//   if (documentSnapshot.exists) {
//     await FirebaseFirestore.instance.collection('challenges').doc(name).update({
//       "user" + (documentSnapshot.data().length + 1).toString(): {"isAccepted": false, "time1": formattedDate, "name": currentUser}
//     });
//     SetOptions(merge: true);
//   } else {
//     await FirebaseFirestore.instance.collection('challenges').doc(name).set({
//       "user1": {"isAccepted": false, "time1": formattedDate, "name": currentUser}
//     });
//     SetOptions(merge: true);
//   }
// }
