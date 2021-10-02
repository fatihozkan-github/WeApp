// ignore_for_file: unused_field, prefer_final_fields

import 'package:WE/Resources/components/pop_up.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/models/model_friend.dart';
import 'package:WE/Resources/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HisProfile extends StatefulWidget {
  HisProfile({this.friend});
  final FriendModel friend;

  @override
  _HisProfileState createState() => _HisProfileState();
}

class _HisProfileState extends State<HisProfile> {
  TextStyle _textStyle = TextStyle(color: kSecondaryColor, fontSize: 30, fontWeight: FontWeight.bold);
  void hideWidget() => setState(() => _canShowButton = !_canShowButton);
  bool _canShowButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: Text('Profil Sayfasi'), backgroundColor: kPrimaryColor),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          SizedBox(height: 30),
          Column(
            children: <Widget>[
              Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/nodemcu-ac498.appspot.com/o/profilePhotos%2Fimage_picker7520950041675576623jpg?alt=media&token=0c07914f-e302-4708-9804-c709c9bcb9d8"))),
              ),
              SizedBox(height: 20),
              Text(widget.friend.name, style: TextStyle(color: kSecondaryColor, fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(widget.friend.superHero.toString(), style: TextStyle(color: kSecondaryColor, fontSize: 20)),
            ],
          ),
          SizedBox(height: 40),
          Wrap(
            runSpacing: 20,
            spacing: 20,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(widget.friend.level.toString(), style: _textStyle),
                  Text("Seviye\n", style: TextStyle(color: kSecondaryColor, fontSize: 12)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(widget.friend.recycled.toString(), style: _textStyle),
                  Text("Geri\ndönüştürülen", style: TextStyle(color: kSecondaryColor, fontSize: 12), textAlign: TextAlign.center),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.friend.coins.toString(), style: _textStyle),
                  Text(
                    "Toplam coin\n",
                    style: TextStyle(color: kSecondaryColor, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Provider.of<UserService>(context).currentUser.friends.contains(widget.friend) ||
                      Provider.of<UserService>(context).currentUser.userID == widget.friend.userID
                  ? Container()
                  : Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_alt_1_rounded, color: kPrimaryColor),
                            SizedBox(width: 10),
                            TextButton(
                              onPressed: () => Provider.of<UserService>(context, listen: false).addFriend(friend: widget.friend),
                              child: Text(
                                "ARKADAŞ EKLE",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kPrimaryColor, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !_canShowButton
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: IconButton(
                            icon: Image.asset("assets/Icons/swords.png"),
                            onPressed: () {
                              popUp(context, widget.friend.name + " düelloya davet edildi. Bol şans!", true);

                              /// TODO: Background functions.
                              // checkChallenges(widget.username);
                              // createChallenge(widget.uid, data["name"]);
                              //_number();
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Düelloya Davet Et!'),
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }
}
