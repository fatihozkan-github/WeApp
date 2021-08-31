import 'package:WE/Resources/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/post_model.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: posts.doc("posts").get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var post = data["post" + (data.length - index).toString()];
                  return Card(
                      color: kSecondaryColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Container(
                          width: double.infinity,
                          height: 550.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(0, 2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: ClipOval(
                                              child: Image(
                                                height: 50.0,
                                                width: 50.0,
                                                image:
                                                    NetworkImage(post["logo"]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        post["name"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(post["time"]),
                                    ),
                                    InkWell(
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        width: double.infinity,
                                        height: 400.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(0, 5),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: NetworkImage(post["asset"]),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
