import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Denek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('allUsers');
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc("C9nvPCW2TwemcjSVgm04").get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data.data();
                    return Container(
                      child: Text("a"),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            IconButton(
              iconSize: 100,
              color: Colors.white,
              onPressed: () {
                getIsFriendData();
              },
              icon: Icon(Icons.add_circle_outline),
            )
          ],
        ),
      ),
    );
  }
}
