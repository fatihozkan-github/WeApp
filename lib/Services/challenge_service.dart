import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

void createChallenge(name, currentUser) async {
  DocumentSnapshot documentSnapshot;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  documentSnapshot =
      await FirebaseFirestore.instance.collection('challenges').doc(name).get();

  if (documentSnapshot.exists) {
    await FirebaseFirestore.instance.collection('challenges').doc(name).update({
      "user" + (documentSnapshot.data().length + 1).toString(): {
        "isAccepted": false,
        "time1": formattedDate,
        "name": currentUser
      }
    });
    SetOptions(merge: true);
  } else {
    await FirebaseFirestore.instance.collection('challenges').doc(name).set({
      "user1": {
        "isAccepted": false,
        "time1": formattedDate,
        "name": currentUser
      }
    });
    SetOptions(merge: true);
  }
}

void approveChallenge(name, currentUser) async {
  DocumentSnapshot documentSnapshot;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  documentSnapshot =
      await FirebaseFirestore.instance.collection('challenges').doc(name).get();

  await FirebaseFirestore.instance.collection('challenges').doc(name).update({
    "user" + (documentSnapshot.data().length + 1).toString(): {
      "isAccepted": false,
      "time1": formattedDate,
      "name": currentUser
    }
  });
  SetOptions(merge: true);
}

void checkChallenges(name) async {
  DocumentSnapshot documentSnapshot;
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  documentSnapshot = await FirebaseFirestore.instance
      .collection('challenges')
      .doc("challenges")
      .get();

  if (documentSnapshot != null) {
    print(documentSnapshot.data());
  } else {
    print("nullkksd");
  }
}
