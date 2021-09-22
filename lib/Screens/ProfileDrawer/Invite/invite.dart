import 'package:WE/Resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';

var firebaseUser = FirebaseAuth.instance.currentUser;

class InvitePage extends StatelessWidget {
  final _snackBar = SnackBar(content: Text('Panoya kopyalandı.'));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          Text(
            "Davet et ve Kazan",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Referans kodun ile arkadaşlarını davet et. Hem sen hem de onlar ekstra ayrıcalıklardan faydalanın.",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Image.asset(
            "assets/invite.png",
            scale: 5,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          GestureDetector(
            onTap: () async {
              Scaffold.of(context).showSnackBar(_snackBar);
              await SocialShare.copyToClipboard(
                firebaseUser.uid.substring(0, 6),
              ).then((data) {
                print(data);
              });
            },
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.1,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                      child: Text(
                        firebaseUser.uid.substring(0, 6),
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
