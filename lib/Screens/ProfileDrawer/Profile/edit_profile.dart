// ignore_for_file: omit_local_variable_types, prefer_single_quotes, unused_field, prefer_final_fields

import 'package:WE/Resources/components/progress_bar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

/// TODO
class _EditProfileState extends State<EditProfile> {
  String _username, _city, _address, _superhero, _company, _referral, _bracelet;
  // _email, _password,
  String imageUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DocumentReference sightingRef = FirebaseFirestore.instance.collection("users").doc();
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var firebaseUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot;
  int _currentProgress = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Map<String, dynamic> data;

  Future<Widget> getData() async {
    snapshot = await users.doc(firebaseUser.uid).get();
    print(snapshot.data());
    setState(() => data = snapshot.data());
    print(data["name"]);
    if (data["name"] != null) _currentProgress++;
    if (data["city"] != null) _currentProgress++;
    if (data["address"] != null) _currentProgress++;
    if (data["superhero"] != null) _currentProgress++;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return snapshot != null
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(backgroundColor: kPrimaryColor),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 8),
                children: [
                  /// TODO: Fix initial values & new areas.
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => Provider.of<UserService>(context, listen: false).uploadImage(),
                    child: Column(
                      children: [
                        /// TODO: Null path error!
                        imageUrl != null
                            ? Container(
                                height: 220,
                                // width: 440,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"]))),
                              )
                            : Icon(Icons.account_circle_rounded, size: 150, color: Colors.grey),
                        Text(
                          "Profil fotoğrafını değiştirmek için avatara dokun.",
                          style: TextStyle(fontSize: width / 40, color: Colors.grey, decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ProgressBar(currentValue: _currentProgress),
                  SizedBox(height: 20),
                  RoundedInputField(
                    hintText: "Kullanıcı Adı",
                    onChanged: (value) => setState(() => _username = value.trim()),
                    initialValue: data["name"],
                  ),
                  RoundedInputField(
                    hintText: "Şehir",
                    icon: Icons.location_city_outlined,
                    onChanged: (value) => _city = value.trim(),
                    initialValue: data["city"],
                  ),
                  RoundedInputField(
                    hintText: "Adres",
                    icon: Icons.location_on_rounded,
                    onChanged: (value) => _address = value.trim(),
                    initialValue: data["address"],
                    validator: (value) {},
                  ),
                  RoundedInputField(
                    hintText: "Şirket",
                    icon: Icons.work_rounded,
                    onChanged: (value) => _company = value.trim(),
                    initialValue: data["company"],
                    validator: (value) {},
                  ),
                  RoundedInputField(
                    hintText: "Favori süper kahraman",
                    icon: Icons.local_fire_department_outlined,
                    onChanged: (value) => _superhero = value.trim(),
                    initialValue: data["superhero"],
                  ),
                  RoundedInputField(
                    hintText: "Bileklik",
                    icon: Icons.local_fire_department_outlined,
                    onChanged: (value) => _bracelet = value.trim(),
                    textInputAction: TextInputAction.done,
                    validator: (value) {},
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    text: "KAYDET",
                    onPressed: () async {
                      _formKey.currentState.validate();

                      /// TODO: Update user.
                      await brewCollection.doc(currentUid).update({
                        "name": _username,
                        "city": _city,
                        // "adress": _address,
                        // "company": _company,
                        "superhero": _superhero,
                      });
                      setState(() => Navigator.pop(context));
                    },
                  ),
                ],
              ),
            ),
          )
        : WESpinKit();
    //   FutureBuilder<DocumentSnapshot>(
    //   future: users.doc(firebaseUser.uid).get(),
    //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data = snapshot.data.data();
    //       return _getBody(data, context, size);
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }

  /// Olds
  // _getBody(data, context, size) => Scaffold(
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: ListView(
  //           children: [
  //             GestureDetector(
  //               onTap: () => uploadImage(),
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                     child: imageUrl != null
  //                         ? Container(
  //                             height: 220,
  //                             width: 440,
  //                             decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"]))),
  //                           )
  //                         : Icon(Icons.account_circle_rounded, size: 150, color: Colors.grey),
  //                   ),
  //                   Container(
  //                     child: Center(
  //                         child:
  //                             Text("Profil fotoğrafını değiştirmek için avatara dokun.", style: TextStyle(color: Colors.grey))),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             ListTile(
  //                 title: Text('Kullancı adı:', style: TextStyle(color: Colors.grey, fontSize: 20)),
  //                 subtitle: TextField(
  //                   onSubmitted: (value1) {
  //                     setState(() {
  //                       _newUsername = value1.trim();
  //                       brewCollection.doc(currentUid).update({
  //                         "name": _newUsername,
  //                       });
  //                     });
  //                   },
  //                   style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  //                   decoration: InputDecoration(
  //                     hintStyle: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  //                     hintText: data["name"],
  //                   ),
  //                 )),
  //             ListTile(
  //                 title: Text('Şehir:', style: TextStyle(color: Colors.grey, fontSize: 20)),
  //                 subtitle: TextField(
  //                   onSubmitted: (value) {
  //                     setState(() {
  //                       _newCity = value.trim();
  //                       brewCollection.doc(currentUid).update({
  //                         "city": _newCity,
  //                       });
  //                     });
  //                   },
  //                   style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  //                   decoration: InputDecoration(
  //                     hintStyle: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  //                     hintText: data["city"],
  //                   ),
  //                 )),
  //             ListTile(
  //               title: Text('Favori süper kahraman', style: TextStyle(color: Colors.grey, fontSize: 20)),
  //               subtitle: TextField(
  //                 onSubmitted: (value) {
  //                   setState(() {
  //                     _newSuperhero = value.trim();
  //                     brewCollection.doc(currentUid).update({"superhero": _newSuperhero});
  //                   });
  //                 },
  //                 style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  //                 decoration: InputDecoration(
  //                   hintStyle: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  //                   hintText: data["superhero"],
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //                 onPressed: () {
  //                   setState(() => Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation())));
  //                 },
  //                 child: Container(
  //                   color: kPrimaryColor,
  //                   height: size.height * 0.05,
  //                   width: size.width * 0.9,
  //                   child: Center(child: Text("Onayla", style: TextStyle(color: Colors.black, fontSize: 16))),
  //                 ))
  //           ],
  //         ),
  //       ),
  //     );
}
