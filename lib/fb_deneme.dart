import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FBD extends StatefulWidget {
  @override
  _FBDState createState() => _FBDState();
}

class _FBDState extends State<FBD> {
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;

  Query collectionReference =
      FirebaseFirestore.instance.collection("users").orderBy('coins');

  @override
//  passData(DocumentSnapshot snap) {
//    Navigator.of(context).push(
//        MaterialPageRoute(builder: (context) => EventPage(snapshot: snap,)));
//  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/instabg.jpg"),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black12,
                      ),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        child: Text(snapshot[index].data()["name"]),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
