import 'package:WE/Resources/constants.dart';
import 'package:WE/Services/service_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

var firebaseUser = FirebaseAuth.instance.currentUser;

class InvitePage extends StatelessWidget {
  final _snackBar = SnackBar(content: Text('Panoya kopyalandı.'), backgroundColor: kPrimaryColor, duration: Duration(seconds: 2));
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(backgroundColor: kPrimaryColor, title: Text("Davet et ve Kazan"), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                "Referans kodun ile arkadaşlarını davet et. Hem sen hem de onlar ekstra ayrıcalıklardan faydalanın.",
                style: TextStyle(color: Colors.black, fontSize: 19),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/invite.png', scale: 5),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                _scaffoldKey.currentState.showSnackBar(_snackBar);
                await SocialShare.copyToClipboard(
                  Provider.of<UserService>(context, listen: false).currentUser.userID.substring(0, 6),
                ).then((data) {
                  print(data);
                });
              },
              child: Container(
                width: size.width * 0.6,
                height: size.height * 0.1,
                decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(32)),
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                        child: Text(Provider.of<UserService>(context, listen: false).currentUser.userID.substring(0, 6),
                            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24)))),
              ),
            ),
            SizedBox(height: 5),
            Text(
              '*Kopyalamak için koda tıklayabilirsin.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
