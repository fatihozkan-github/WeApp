import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/post_model.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<DocumentSnapshot>(
          future: posts.doc("posts").get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => Divider(thickness: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  var post = data["post" + (data.length - index).toString()];
                  return PostModel(
                    name: post['name'],
                    logo: post['logo'],
                    time: post['time'],
                    text: post['text'],
                    asset: post['asset'],
                  );
                },
              );
            }
            return WESpinKit();
          }),
    );
  }
}

///
// return Padding(
// padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
// child: Container(
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(20.0),
// boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(1, 1))],
// ),
// child: Column(
// children: <Widget>[
// Padding(
// padding: EdgeInsets.symmetric(vertical: 10.0),
// child: Column(
// children: <Widget>[
// ListTile(
// leading: Container(
// width: 50.0,
// height: 50.0,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// boxShadow: [BoxShadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 6.0)],
// ),
// child: GestureDetector(
// onTap: () {},
// child: CircleAvatar(
// backgroundColor: Colors.white,
// child: ClipOval(
// child: Image(
// height: 50.0,
// width: 50.0,
// image: NetworkImage(post["logo"]),
// fit: BoxFit.cover,
// ),
// ),
// ),
// ),
// ),
// title: Text(post["name"], style: TextStyle(fontWeight: FontWeight.bold)),
// subtitle: Text(post["time"]),
// ),
// Container(
// margin: EdgeInsets.all(10.0),
// height: 350.0,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(25.0),
// image: DecorationImage(image: NetworkImage(post["asset"]), fit: BoxFit.fitHeight),
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// );
