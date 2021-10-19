import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLMail() async {
    const url = 'mailto:we.recycle.team@gmail.com?subject=WE&body=Feedback';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _name;
  String _message;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Geri Bildirim", style: TextStyle(fontSize: 24)),
        backgroundColor: kPrimaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              "Bize bir mesaj bırakın. En yakın zamanda geri dönüş yapacağız.",
              style:
                  TextStyle(fontSize: 17.5, height: 1.3, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            RoundedInputField(
              hintText: 'İsim',
              onChanged: (value) => setState(() => _name = value),
            ),
            RoundedInputField(
              hintText: 'Mesajınız',
              icon: Icons.message,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              onChanged: (value) => setState(() => _message = value),
            ),
            SizedBox(height: 15),
            RoundedButton(
              text: 'Gönder',
              onPressed: () {
                setState(() {
                  if (_formKey.currentState.validate()) {
                    var params = Uri(
                      scheme: 'mailto',
                      path: 'we.recycle.team@gmail.com',
                      query: 'subject=From $_name&body=$_message',
                    );
                    launchUrl(params.toString());
                  }
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                  "Alternatif olarak bu platformlardan da bize ulaşabilirsiniz.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 17)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => launchUrl("https://github.com/alihansoykal/we"),
                  child: Icon(FontAwesomeIcons.github,
                      color: Colors.orange, size: 35),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => launchUrl(
                      "https://www.instagram.com/werecycle.official/"),
                  child: Icon(FontAwesomeIcons.instagram,
                      color: Color(0xfffb3958), size: 35),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => launchUrl(
                      "https://play.google.com/store/apps/details?id=com.we.werecyclemobile"),
                  child: Icon(FontAwesomeIcons.googlePlay,
                      color: Color(0xff1DA1F2), size: 35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///
// Padding(
//   padding: const EdgeInsets.all(10.0),
//   child: TextField(
//     onChanged: (val) {
//       if (val != null || val.length > 0) name = val;
//     },
//     controller: t1,
//     decoration: InputDecoration(
//       fillColor: Color(0xffe6e6e6),
//       filled: true,
//       contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//       hintText: 'İsim',
//       hintStyle: TextStyle(
//         color: Colors.blueGrey,
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         borderSide: BorderSide(color: Colors.grey[400]),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         borderSide: BorderSide(color: Colors.grey[400]),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         borderSide: BorderSide(color: Colors.grey[400]),
//       ),
//     ),
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.all(10),
//   child: TextField(
//     onChanged: (val) {
//       if (val != null || val.length > 0) message = val;
//     },
//     textAlign: TextAlign.start,
//     controller: t2,
//     decoration: InputDecoration(
//       fillColor: Color(0xffe6e6e6),
//       filled: true,
//       contentPadding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
//       hintText: 'Mesajınız',
//       hintStyle: TextStyle(
//         color: Colors.blueGrey,
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(17)),
//         borderSide: BorderSide(color: Colors.grey[400]),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(17)),
//         borderSide: BorderSide(color: Colors.grey[400]),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(17)),
//         borderSide: BorderSide(color: Colors.grey[400]),
//       ),
//     ),
//   ),
// ),
///
// Card(
// color: Colors.black,
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
// margin: EdgeInsets.symmetric(horizontal: 10.0),
// child: GestureDetector(
// onTap: () {
// setState(() {
// t1.clear();
// t2.clear();
// launchUrl("mailto:we.recycle.team@gmail.com?subject=From $name&body=$message");
// });
// },
// child: ListTile(
// title: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// Center(child: Icon(Icons.send, color: Colors.white)),
// SizedBox(width: MediaQuery.of(context).size.width * 0.03),
// Center(child: Text("Gönder", textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
// ],
// ),
// ),
// ),
// ),
