// ignore_for_file: prefer_single_quotes

import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NewPrizePage extends StatefulWidget {
  @override
  _NewPrizePageState createState() => _NewPrizePageState();
}

class _NewPrizePageState extends State<NewPrizePage> {
  List<int> coinsList = [];
  List<bool> boolList = [];
  int _current = 0;
  var items = [1, 2, 3];

  @override
  void initState() {
    super.initState();
    getCoinData().then((value) {
      coinsList.clear();
      coinsList.add(int.parse(value));
    });
  }

  final databaseReference = FirebaseDatabase.instance.reference();
  final currentUid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference prizes = FirebaseFirestore.instance.collection('prizes');

  Future<void> updateCoins(int i, int decrease, bool isRegistered1, bool isRegistered2, bool isRegistered3) {
    isRegistered1;
    return users
        .doc(currentUid)
        .update({'coins': i - decrease, "raffle1": isRegistered1, "raffle2": isRegistered2, "raffle3": isRegistered3})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<String> getCoinData() async {
    var document = await users.doc(currentUid);
    document.get().then((value) => print(value));
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(currentUid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      var coins = data['coins'];
      return coins.toString();
    }
  }

  Future<bool> getRaffleData(int i) async {
    var document = await users.doc(currentUid);
    document.get().then((value) => print(value));
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(currentUid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data();
      var raffle = data["raffle" + i.toString()];
      return raffle;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Ayrıcalıklar')),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            color: kPrimaryColor,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: users.doc(currentUid).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data.data();
                        return Text(
                          data["coins"].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),
                        );
                      }
                      return WESpinKit();
                    }),
                Text('WE Coin', style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<DocumentSnapshot>(
              future: prizes.doc("1pHYVNY6et3U7RcVIiJp").get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> prizeData = snapshot.data.data();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2)]),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Center(
                                    child: Text(prizeData["prize1"]["title"], style: TextStyle(fontWeight: FontWeight.bold)))),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Image.network(prizeData["prize1"]["photo"])),
                            ),
                            Expanded(
                                flex: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () => popUp(context, prizeData["prize1"]["subtitle"], true),
                                        icon: Icon(Icons.info_outline)),
                                    FutureBuilder<DocumentSnapshot>(
                                        future: users.doc(currentUid).get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text("Something went wrong");
                                          }
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            Map<String, dynamic> data = snapshot.data.data();
                                            // try {
                                            //   data.update("coins", (value) => 999);
                                            // } catch (e) {
                                            //   print(e);
                                            // }
                                            print(data["coins"]);
                                            return Padding(
                                                padding: EdgeInsets.all(7.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(510.0)),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      /// TODO: Fix
                                                      if (data["coins"] >= 50 && data["raffle1"] == false) {
                                                        updateCoins(data["coins"], 50, true, data["raffle2"], data["raffle3"]);
                                                        popUp(
                                                            context,
                                                            "Çekilişe kaydınız başarıyla alınmıştır. Kalan WE Coin: " +
                                                                (data["coins"] - 50).toString(),
                                                            false);
                                                      } else {
                                                        popUp(
                                                            context,
                                                            "Yeterli WE Coine sahip değilsiniz veya zaten bu çekilişe katıldınız.",
                                                            true);
                                                      }
                                                    },
                                                    child: Container(
                                                        width: 100,
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        color: kPrimaryColor,
                                                        child: Text("50 WE Coin", style: TextStyle(color: Colors.white))),
                                                  ),
                                                ));
                                          }
                                          return WESpinKit();
                                        }),
                                  ],
                                )),
                          ],
                        )),
                  );
                }
                return WESpinKit();
              }),
          FutureBuilder<DocumentSnapshot>(
              future: prizes.doc("1pHYVNY6et3U7RcVIiJp").get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> prizeData = snapshot.data.data();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2)]),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Container(
                                  width: size.width,
                                  color: Colors.white,
                                  child: Center(
                                      child: Text(
                                    prizeData["prize2"]["title"],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                )),
                            Expanded(
                                flex: 10,
                                child: Container(
                                  width: size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(prizeData["prize2"]["photo"]),
                                  ),
                                )),
                            Expanded(
                                flex: 5,
                                child: Container(
                                  width: size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            popUp(context, prizeData["prize2"]["subtitle"], true);
                                          },
                                          icon: Icon(Icons.info_outline)),
                                      FutureBuilder<DocumentSnapshot>(
                                          future: users.doc(currentUid).get(),
                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Text("Something went wrong");
                                            }
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              Map<String, dynamic> data = snapshot.data.data();

                                              return Padding(
                                                  padding: EdgeInsets.all(7.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(510.0)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (data["coins"] >= 500 && data["raffle2"] == false) {
                                                          updateCoins(data["coins"], 500, data["raffle1"], true, data["raffle3"]);
                                                          popUp(
                                                              context,
                                                              "Çekilişe kaydınız başarıyla alınmıştır. Kalan WE Coin: " +
                                                                  (data["coins"] - 500).toString(),
                                                              false);
                                                        } else {
                                                          popUp(
                                                              context,
                                                              "Yeterli WE Coine sahip değilsiniz veya zaten bu çekilişe katıldınız.",
                                                              true);
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 110,
                                                        height: 30,
                                                        color: kPrimaryColor,
                                                        child: Center(
                                                            child: Text(
                                                          "500 WE Coin",
                                                          style: TextStyle(color: Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                  ));
                                            }
                                            return WESpinKit();
                                          }),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                  );
                }
                return WESpinKit();
              }),
          FutureBuilder<DocumentSnapshot>(
              future: prizes.doc("1pHYVNY6et3U7RcVIiJp").get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> prizeData = snapshot.data.data();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width,
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2)]),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Container(
                                    width: size.width,
                                    color: Colors.white,
                                    child: Center(
                                        child:
                                            Text(prizeData["prize3"]["title"], style: TextStyle(fontWeight: FontWeight.bold))))),
                            Expanded(
                                flex: 10,
                                child: Container(
                                  width: size.width,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0), child: Image.network(prizeData["prize3"]["photo"])),
                                )),
                            Expanded(
                                flex: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () => popUp(context, prizeData["prize3"]["subtitle"], true),
                                        icon: Icon(Icons.info_outline)),
                                    FutureBuilder<DocumentSnapshot>(
                                        future: users.doc(currentUid).get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text("Something went wrong");
                                          }
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            Map<String, dynamic> data = snapshot.data.data();

                                            return Padding(
                                                padding: EdgeInsets.all(7.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(510.0)),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (data["coins"] >= 5000 && data["raffle3"] == false) {
                                                        updateCoins(data["coins"], 5000, data["raffle1"], data["raffle2"], true);
                                                        popUp(
                                                            context,
                                                            "Çekilişe kaydınız başarıyla alınmıştır. Kalan WE Coin: " +
                                                                (data["coins"] - 5000).toString(),
                                                            true);
                                                      } else {
                                                        popUp(
                                                            context,
                                                            "Yeterli WE Coine sahip değilsiniz veya zaten bu çekilişe katıldınız.",
                                                            true);
                                                      }
                                                    },
                                                    child: Container(
                                                        width: 120,
                                                        height: 30,
                                                        color: kPrimaryColor,
                                                        child: Center(
                                                            child: Text("5000 WE Coin", style: TextStyle(color: Colors.white)))),
                                                  ),
                                                ));
                                          }
                                          return WESpinKit();
                                        }),
                                  ],
                                )),
                          ],
                        )),
                  );
                }
                return WESpinKit();
              }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

///
// FutureBuilder<DocumentSnapshot>(
// future: users.doc(currentUid).get(),
// builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// if (snapshot.hasError) {
// return Text("Something went wrong");
// }
// if (snapshot.connectionState == ConnectionState.done) {
// Map<String, dynamic> data = snapshot.data.data();
//
// return Padding(
// padding: EdgeInsets.all(7.0),
// child: ClipRRect(
// borderRadius: BorderRadius.all(Radius.circular(510.0)),
// child: GestureDetector(
// onTap: () {
// /// TODO: Fix
// if (data["coins"] > 50 && data["raffle1"] == false) {
// updateCoins(data["coins"], 50, true, data["raffle2"], data["raffle3"]);
// popUp(
// context,
// "Çekilişe kaydınız başarıyla alınmıştır. Kalan WE Coin: " +
// (data["coins"] - 50).toString(),
// false);
// } else {
// popUp(
// context,
// "Yeterli WE Coine sahip değilsiniz veya zaten bu çekilişe katıldınız.",
// true);
// }
// },
// child: Container(
// width: 100,
// height: 30,
// color: kPrimaryColor,
// child: Center(
// child: Text(
// "50 WE Coin",
// style: TextStyle(color: Colors.white),
// )),
// ),
// ),
// ));
// }
// return WESpinKit();
// }),
