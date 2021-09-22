import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestoreInstance = FirebaseFirestore.instance;
final currentUid = FirebaseAuth.instance.currentUser.uid;

void signUp(
    {String name,
    String password,
    String email,
    String city,
    String superhero,
    int level,
    double exp,
    int coins,
    int dailyCoins,
    int dailyRecycled,
    List<String> impact,
    List<String> friends,
    String avatar,
    int recycled,
    int forbadgecount,
    String uid}) {
  firestoreInstance.collection("users").doc(currentUid).set({
    "name": name,
    "password": password,
    "email": email,
    "city": city,
    "exp": 0.1,
    "superhero": superhero,
    "level": 1,
    "coins": 0,
    "points": 0,
    "dailyCoins": 0,
    "dailyRecycled": 0,
    "uid": currentUid,
    "recycled": 0,
    "forbadgecount": 0,
    "avatar": null,
    "raffle1": false,
    "raffle2": false,
    "raffle3": false,
    "impact": ["Nothing", "2-hour bulb energy", "2 fish", "2kWh energy"],
    "badges": {
      "badge1": false,
      "badge2": false,
      "badge3": false,
      "badge4": false,
      "badge5": false,
      "badge6": false,
      "challenges": false,
    }
  });
}

Future<String> fetchData(str) async {
  var collection = FirebaseFirestore.instance.collection(str);
  var docSnapshot = await collection.doc(currentUid).get();
  if (docSnapshot.exists) {
    Map<String, dynamic> data = docSnapshot.data();
  }
}

// TODO: .is empty dene user0 var mı for döngüsünde user ekle yeni
void create(
    {String name,
    String password,
    String email,
    String city,
    String superhero,
    int level,
    double exp,
    int coins,
    int dailyCoins,
    int dailyRecycled,
    List<String> impact,
    String avatar,
    int recycled,
    int forbadgecount,
    String uid}) async {
  DocumentSnapshot documentSnapshot;
  documentSnapshot = await FirebaseFirestore.instance
      .collection('allUsers')
      .doc('C9nvPCW2TwemcjSVgm04')
      .get();

  await FirebaseFirestore.instance
      .collection('allUsers')
      .doc('C9nvPCW2TwemcjSVgm04')
      .set({
    // currentUid: {
    "user" + (documentSnapshot.data().keys.length + 1).toString(): {
      "name": name,
      "password": password,
      "email": email,
      "city": city,
      "exp": 0.1,
      "superhero": superhero,
      "level": 1,
      "coins": 0,
      "points": 0,
      "raffle1": false,
      "raffle2": false,
      "raffle3": false,
      "forbadgecount": 0,
      "dailyCoins": 0,
      "dailyRecycled": 0,
      "uid": currentUid,
      "recycled": 0,
      "avatar": null,
      "impact": ["Nothing", "2-hour bulb energy", "2 fish", "2kWh energy"],
      "badges": {
        "badge1": false,
        "badge2": false,
        "badge3": false,
        "badge4": false,
        "badge5": false,
        "badge6": false,
        "challenges": false,
      }
    },
  }, SetOptions(merge: true));
}

void addReferralData({String referralId, String uid}) async {
  DocumentSnapshot documentSnapshot;

  documentSnapshot = await FirebaseFirestore.instance
      .collection('referralCodes')
      .doc('referrals')
      .get();
  DocumentSnapshot docSnapshot;

  docSnapshot = await FirebaseFirestore.instance
      .collection('referralCodes')
      .doc('list')
      .get();

  if (documentSnapshot.data()[referralId] != null) {
    await FirebaseFirestore.instance
        .collection('referralCodes')
        .doc('referrals')
        .set({
      referralId: {
        "user" +
            (documentSnapshot.data()[referralId].keys.length + 1)
                .toString(): uid,
      },
    }, SetOptions(merge: true));
  } else {
    await FirebaseFirestore.instance
        .collection('referralCodes')
        .doc('referrals')
        .set({
      referralId: {
        "user1": uid,
      },
    }, SetOptions(merge: true));
  }

  await FirebaseFirestore.instance.collection('referralCodes').doc('list').set({
    "listOfReferrals": {
      (docSnapshot.data()["listOfReferrals"].length).toString():
          uid.substring(0, 6),
    },
  }, SetOptions(merge: true));
  print("****************************");
  print(docSnapshot.data()["listOfReferrals"].length);

  // TODO: if (documentSnapshot.data().keys.length >2 badges update at
  // TODO: opsiyonel (digit code Upper case'le, burda olmak zorunda değil ama bunu da)
}

void checkReferralData({String referralId, String uid}) async {
  DocumentSnapshot documentSnapshot;
  documentSnapshot = await FirebaseFirestore.instance
      .collection('referralCodes')
      .doc('referrals')
      .get();

  if (documentSnapshot.data()[currentUid.substring(0, 6)].keys.length >= 2) {
    await FirebaseFirestore.instance.collection('users').doc(currentUid).set({
      "badges": {
        "badge1": true,
      },
    }, SetOptions(merge: true));
  }
  if (documentSnapshot.data()[currentUid.substring(0, 6)].keys.length >= 15) {
    await FirebaseFirestore.instance.collection('users').doc(currentUid).set({
      "badges": {
        "badge6": true,
      },
    }, SetOptions(merge: true));
  }
  if (documentSnapshot.data()[currentUid.substring(0, 6)].keys.length >= 5) {
    await FirebaseFirestore.instance.collection('users').doc(currentUid).set({
      "badges": {
        "challenges": true,
      },
    }, SetOptions(merge: true));
  }
  // TODO: if (documentSnapshot.data().keys.length >2 badges update at
  // TODO: opsiyonel (digit code Upper case'le, burda olmak zorunda değil ama bunu da)
}

void addKanka(
    {String uid,
    String name,
    dynamic recycled,
    dynamic level,
    dynamic coins,
    String superhero}) async {
  DocumentSnapshot documentSnapshot;
  documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUid)
      .get();
  int check = 0;
  DocumentSnapshot docSnapshot;
  docSnapshot = await FirebaseFirestore.instance
      .collection('friends')
      .doc(currentUid)
      .get();
  if (docSnapshot.data() != null) {
    for (var i = 1; i <= docSnapshot.data().length; i++) {
      if (docSnapshot.data()["friend" + i.toString()].containsValue(uid)) {
        check = check + 1;
      }
    }
  }

  if (check == 0) {
    await FirebaseFirestore.instance.collection('friends').doc(currentUid).set({
      "friend" +
          (docSnapshot.data() == null ? 1 : docSnapshot.data().length + 1)
              .toString(): {
        "uid": uid,
        "name": name,
        "recycled": recycled,
        "supehero": superhero,
        "coins": coins,
        "level": level
      },
    }, SetOptions(merge: true));
  }
}

void addFriend(
    {String name,
    String superhero,
    int level,
    int coins,
    int dailyCoins,
    int dailyRecycled,
    String avatar,
    int recycled,
    bool isFriend,
    String uid}) async {
  DocumentSnapshot documentSnapshot;
  documentSnapshot = await FirebaseFirestore.instance
      .collection('allUsers')
      .doc('C9nvPCW2TwemcjSVgm04')
      .get();
  DocumentSnapshot docSnapshot;

  docSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUid)
      .get();

  await FirebaseFirestore.instance.collection('users').doc(currentUid).set({
    "friends": {
      "friend" +
          (docSnapshot.data()["friends"] == null
                  ? 1
                  : docSnapshot.data()["friends"].length + 1)
              .toString(): {
        "name": name,
        "isFriend": isFriend,
        "superhero": superhero,
        "level": 1,
        "coins": 0,
        "points": 0,
        "dailyCoins": 0,
        "dailyRecycled": 0,
        "uid": currentUid,
        "recycled": 0,
        "avatar": null
      }
    },
  }, SetOptions(merge: true));
}

void getIsFriendData() async {
  DocumentSnapshot docSnapshot;
  docSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc("zag8tuPzwKMWqD2m4uU6conEoSB2")
      .get();
  for (var i = 1; i <= docSnapshot.data()["friends"].length; i++) {
    if (docSnapshot.data()["friends"]["friend" + i.toString()]["isFriend"] &&
        docSnapshot.data()["friends"]["friend" + i.toString()]["name"] == "x") {
      var isFriend =
          docSnapshot.data()["friends"]["friend" + i.toString()]["isFriend"];
      return isFriend;
    }
  }
}

void update100gData(currentUser) async {
  DocumentSnapshot documentSnapshot;
  documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .get();
  await FirebaseFirestore.instance.collection('users').doc(currentUser).update(
      {"forbadgecount": (documentSnapshot.data()["forbadgecount"] + 1)});
}

void getUserDataForL(uid) async {
  DocumentSnapshot documentSnapshot;

  documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return documentSnapshot.data()["name"];
}

void read() async {
  DocumentSnapshot documentSnapshot;

  documentSnapshot = await FirebaseFirestore.instance
      .collection('allUsers')
      .doc('C9nvPCW2TwemcjSVgm04')
      .get();
  print(documentSnapshot.data().keys.length);
  //documentSnapshot.data().keys=="user"+documentSnapshot.data().keys.length.toString()?print("var"):print("user"+documentSnapshot.data().keys.length.toString());
  //for (var i = 0; i <= 10; i++) {
  //documentSnapshot.data().keys.elementAt(i).isNotEmpty?print(documentSnapshot.data().keys.elementAt(i)):i=10;
  // }
  //print(documentSnapshot.data().keys.elementAt(0));
}

// if("user0".isNotEmpty){"user0": ["Alihan",500, 2]
//   } else {"user0":["Alihan",60, 2]
//   }

void calculateLevel(currentUser) async {
  DocumentSnapshot documentSnapshot;

  final Map<int, int> expTable = {
    1: 50,
    2: 150,
    3: 300,
    4: 500,
    5: 750,
    6: 1050,
    7: 1400,
    8: 1800,
    9: 2250,
    10: 2750,
    11: 3300,
    12: 3900,
    13: 4550,
    14: 5250,
    15: 6000,
    16: 6800,
    17: 7650,
    18: 8550,
    19: 9500,
    20: 10500,
    21: 11550,
    22: 12650,
    23: 13800,
    24: 15000,
  };
  var counter = 0;

  documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .get();
  for (var i = 1; i <= 24; i++) {
    print(i);
    if (documentSnapshot.data()["recycled"] / (expTable[i]) >= 1) {
      counter = counter + 1;
    }
  }
  await FirebaseFirestore.instance.collection('users').doc(currentUser).update({
    "level": counter + 1,
    "exp": (documentSnapshot.data()["recycled"] - (expTable[counter])) /
        ((expTable[counter + 1]) - (expTable[counter]))
  });
  print(documentSnapshot.data()["recycled"]);
  print((expTable[counter]));
}
