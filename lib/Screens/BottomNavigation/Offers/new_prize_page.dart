import 'package:WE/Resources/components/opportunities/sliding_cards.dart';
import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';

class NewPrizePage extends StatefulWidget {
  @override
  _NewPrizePageState createState() => _NewPrizePageState();
}

class _NewPrizePageState extends State<NewPrizePage> {
  List<int> coinsList = [];
  List<bool> boolList = [];
  int _current = 0;
  var items = [
    1,
    2,
    3,
  ];

  @override
  void initState() {
    // TODO: implement initState
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

  Future<void> updateCoins(
    int i,
    int decrease,
    bool isRegistered1,
    bool isRegistered2,
    bool isRegistered3,
  ) {
    isRegistered1;
    return users
        .doc(currentUid)
        .update({
          'coins': i - decrease,
          "raffle1": isRegistered1,
          "raffle2": isRegistered2,
          "raffle3": isRegistered3
        })
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ayrıcalıklar',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              child: Container(
                color: kPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                          future: users.doc(currentUid).get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data = snapshot.data.data();
                              return Text(
                                data["coins"].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                      Text(
                        'WE Coin',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
                future: prizes.doc("1pHYVNY6et3U7RcVIiJp").get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> prizeData = snapshot.data.data();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PhysicalModel(
                              elevation: 10.0,
                              shape: BoxShape.rectangle,
                              shadowColor: kPrimaryColor,
                              color: Colors.grey[850],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Container(
                                    color: Colors.white,
                                    width: size.width,
                                    height: size.height * 0.3,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                              width: size.width,
                                              color: Colors.white,
                                              child: Center(
                                                  child: Text(
                                                prizeData["prize1"]["title"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            )),
                                        Expanded(
                                            flex: 10,
                                            child: Container(
                                              width: size.width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                    prizeData["prize1"]
                                                        ["photo"]),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              width: size.width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        popUp(
                                                            context,
                                                            prizeData["prize1"]
                                                                ["subtitle"],
                                                            true);
                                                      },
                                                      icon: Icon(
                                                          Icons.info_outline)),
                                                  FutureBuilder<
                                                          DocumentSnapshot>(
                                                      future: users
                                                          .doc(currentUid)
                                                          .get(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              "Something went wrong");
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          Map<String, dynamic>
                                                              data = snapshot
                                                                  .data
                                                                  .data();

                                                          return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7.0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            510.0)),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    if (data["coins"] >
                                                                            50 &&
                                                                        data["raffle1"] ==
                                                                            false) {
                                                                      updateCoins(
                                                                          data[
                                                                              "coins"],
                                                                          50,
                                                                          true,
                                                                          data[
                                                                              "raffle2"],
                                                                          data[
                                                                              "raffle3"]);
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
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    height: 30,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    child: Center(
                                                                        child: Text(
                                                                      "50 WE Coin",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                  ),
                                                                ),
                                                              ));
                                                        }
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            FutureBuilder<DocumentSnapshot>(
                future: prizes.doc("1pHYVNY6et3U7RcVIiJp").get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> prizeData = snapshot.data.data();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PhysicalModel(
                              elevation: 10.0,
                              shape: BoxShape.rectangle,
                              shadowColor: kPrimaryColor,
                              color: Colors.grey[850],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Container(
                                    color: Colors.white,
                                    width: size.width,
                                    height: size.height * 0.3,
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
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            )),
                                        Expanded(
                                            flex: 10,
                                            child: Container(
                                              width: size.width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                    prizeData["prize2"]
                                                        ["photo"]),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              width: size.width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        popUp(
                                                            context,
                                                            prizeData["prize2"]
                                                                ["subtitle"],
                                                            true);
                                                      },
                                                      icon: Icon(
                                                          Icons.info_outline)),
                                                  FutureBuilder<
                                                          DocumentSnapshot>(
                                                      future: users
                                                          .doc(currentUid)
                                                          .get(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              "Something went wrong");
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          Map<String, dynamic>
                                                              data = snapshot
                                                                  .data
                                                                  .data();

                                                          return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7.0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            510.0)),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    if (data["coins"] >
                                                                            500 &&
                                                                        data["raffle2"] ==
                                                                            false) {
                                                                      updateCoins(
                                                                          data[
                                                                              "coins"],
                                                                          500,
                                                                          data[
                                                                              "raffle1"],
                                                                          true,
                                                                          data[
                                                                              "raffle3"]);
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
                                                                  child:
                                                                      Container(
                                                                    width: 110,
                                                                    height: 30,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    child: Center(
                                                                        child: Text(
                                                                      "500 WE Coin",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                  ),
                                                                ),
                                                              ));
                                                        }
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            FutureBuilder<DocumentSnapshot>(
                future: prizes.doc("1pHYVNY6et3U7RcVIiJp").get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> prizeData = snapshot.data.data();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PhysicalModel(
                              elevation: 10.0,
                              shape: BoxShape.rectangle,
                              shadowColor: kPrimaryColor,
                              color: Colors.grey[850],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Container(
                                    color: Colors.white,
                                    width: size.width,
                                    height: size.height * 0.3,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 4,
                                            child: Container(
                                              width: size.width,
                                              color: Colors.white,
                                              child: Center(
                                                  child: Text(
                                                prizeData["prize3"]["title"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            )),
                                        Expanded(
                                            flex: 10,
                                            child: Container(
                                              width: size.width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                    prizeData["prize3"]
                                                        ["photo"]),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              width: size.width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        popUp(
                                                            context,
                                                            prizeData["prize3"]
                                                                ["subtitle"],
                                                            true);
                                                      },
                                                      icon: Icon(
                                                          Icons.info_outline)),
                                                  FutureBuilder<
                                                          DocumentSnapshot>(
                                                      future: users
                                                          .doc(currentUid)
                                                          .get(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              "Something went wrong");
                                                        }
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          Map<String, dynamic>
                                                              data = snapshot
                                                                  .data
                                                                  .data();

                                                          return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7.0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            510.0)),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    if (data["coins"] >
                                                                            5000 &&
                                                                        data["raffle3"] ==
                                                                            false) {
                                                                      updateCoins(
                                                                          data[
                                                                              "coins"],
                                                                          5000,
                                                                          data[
                                                                              "raffle1"],
                                                                          data[
                                                                              "raffle2"],
                                                                          true);
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
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    height: 30,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    child: Center(
                                                                        child: Text(
                                                                      "5000 WE Coin",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                  ),
                                                                ),
                                                              ));
                                                        }
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
