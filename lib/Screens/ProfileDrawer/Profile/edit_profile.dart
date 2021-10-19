// ignore_for_file: omit_local_variable_types, prefer_single_quotes

import 'dart:io';

import 'package:WE/Resources/components/progress_bar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/unFocuser.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import 'activate_bracelet.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

/// TODO
class _EditProfileState extends State<EditProfile> {
  String _username, _city, _address, _superhero, _company, _referral, _bracelet, _avatar;
  // _email, _password,
  String imageUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DocumentReference sightingRef = FirebaseFirestore.instance.collection("users").doc();
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');
  var firebaseUser = FirebaseAuth.instance.currentUser;
  String currentUid = FirebaseAuth.instance.currentUser.uid;
  DocumentSnapshot snapshot;
  int _currentProgress = 0;
  Map<String, dynamic> data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    snapshot = await brewCollection.doc(firebaseUser.uid).get();
    data = snapshot.data();
    print(snapshot.data());
    _currentProgress = 0;
    if (data["name"] != null && data["name"].toString().isNotEmpty) {
      _currentProgress++;
      _username = data['name'];
    }
    if (data["city"] != null && data["city"].toString().isNotEmpty) {
      _currentProgress++;
      _city = data['city'];
    }
    if (data["superhero"] != null && data["superhero"].toString().isNotEmpty) {
      _currentProgress++;
      _superhero = data['superhero'];
    }
    if (data["address"] != null && data["address"].toString().isNotEmpty) {
      _currentProgress++;
      _address = data['address'];
    }
    if (data["company"] != null && data["company"].toString().isNotEmpty) {
      _currentProgress++;
      _company = data['company'];
    }
    if (data["avatar"] != null && data["avatar"].toString().isNotEmpty) {
      _currentProgress++;
      _avatar = data['avatar'];
    }
    if (data["rfId"] != null && data["rfId"].toString().isNotEmpty) {
      _currentProgress++;
    }
    setState(() {});
  }

  /// • Adjusts progress bar and updates user.
  void _adjustProgressBar() async {
    /// TODO: Update user.
    if (_username != null && _username != data["name"]) {
      print('ch1');
      setState(() {
        if (_currentProgress < 7 && data["name"].toString().isEmpty) _currentProgress++;
        if (_currentProgress < 7 && data["name"].toString().isNotEmpty && _username.isEmpty) _currentProgress--;
      });
      await brewCollection.doc(currentUid).update({
        "name": _username,
      });
    }

    if (_city != null && _city != data["city"]) {
      print('ch2');
      setState(() {
        if (_currentProgress < 7 && data["city"].toString().isEmpty) _currentProgress++;
        if (_currentProgress < 7 && data["city"].toString().isNotEmpty && _city.isEmpty) _currentProgress--;
      });
      await brewCollection.doc(currentUid).update({
        "city": _city,
      });
    }

    if (_superhero != null && _superhero != data["superhero"]) {
      print('ch3');
      setState(() {
        if (_currentProgress < 7 && data["superhero"].toString().isEmpty) _currentProgress++;
        if (_currentProgress < 7 && data["superhero"].toString().isNotEmpty && _superhero.isEmpty) _currentProgress--;
      });
      await brewCollection.doc(currentUid).update({
        "superhero": _superhero,
      });
    }

    if (_address != null && _address != data["address"]) {
      print('ch4');
      setState(() {
        if (_currentProgress < 7 && data["address"].toString().isEmpty) _currentProgress++;
        if (_currentProgress < 7 && data["address"].toString().isNotEmpty && _address.isEmpty) _currentProgress--;
      });
      await brewCollection.doc(currentUid).update({
        "address": _address,
      });
    }

    if (_company != null && _company != data["company"]) {
      print('ch5');
      setState(() {
        if (_currentProgress < 7 && data["company"].toString().isEmpty) _currentProgress++;
        if (_currentProgress < 7 && data["company"].toString().isNotEmpty && _company.isEmpty) _currentProgress--;
      });
      await brewCollection.doc(currentUid).update({
        "company": _company,
      });
    }

    // if (_avatar != null && _avatar != data["avatar"]) {
    //   print('ch6');
    //   setState(() {
    //     if (_currentProgress < 7 && data["avatar"].toString().isEmpty) _currentProgress++;
    //     if (_currentProgress < 7 && data["avatar"].toString().isNotEmpty && _avatar.isEmpty) _currentProgress--;
    //   });
    //   await brewCollection.doc(currentUid).update({
    //     "avatar": _avatar,
    //   });
    // }
    getData();
  }

  Future uploadImage() async {
    print('ch1');
    var image;
    try {
      final _storage = FirebaseStorage.instance;
      await Permission.photos.request();
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        var snapshot = await _storage.ref().child('profilePhotos/${basename(image.path)}').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        await brewCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
          'avatar': downloadUrl,
        });
        setState(() {
          _avatar = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final width = MediaQuery.of(context).size.width;
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // var firebaseUser = FirebaseAuth.instance.currentUser;
    return snapshot != null
        ? UnFocuser(
            child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(backgroundColor: kPrimaryColor, title: Text('Profilini Düzenle'), centerTitle: true),
              body: Center(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      /// TODO: Fix initial values.
                      SizedBox(height: 18),
                      GestureDetector(
                        onTap: () async => await uploadImage(),
                        child: Column(
                          children: [
                            /// TODO: Null path error!
                            (_avatar != null && _avatar != '')
                                ? Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(fit: BoxFit.contain, image: NetworkImage(_avatar))),
                                  )
                                : Icon(Icons.account_circle_rounded, size: 150, color: Colors.grey),
                            Text(
                              "Profil fotoğrafını değiştirmek için avatara dokun.",
                              style: TextStyle(fontSize: width / 40, color: Colors.grey, decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                      ),
                      ProgressBar(currentValue: _currentProgress),
                      SizedBox(height: 20),

                      RoundedInputField(
                        hintText: "Kullanıcı Adı",
                        initialValue: _username,
                        onChanged: (value) => setState(() => _username = value.trim()),
                      ),
                      RoundedInputField(
                        hintText: "Şehir",
                        initialValue: _city,
                        icon: Icons.location_city_outlined,
                        onChanged: (value) => _city = value.trim(),
                      ),
                      RoundedInputField(
                        hintText: "Adres",
                        initialValue: _address,
                        icon: Icons.location_city_outlined,
                        onChanged: (value) => _address = value.trim(),
                      ),
                      RoundedInputField(
                        hintText: "Şirket",
                        initialValue: _company,
                        icon: Icons.local_fire_department_outlined,
                        onChanged: (value) => _company = value.trim(),
                      ),
                      RoundedInputField(
                        hintText: "Favori süper kahraman",
                        initialValue: _superhero,
                        icon: Icons.local_fire_department_outlined,
                        onChanged: (value) => _superhero = value.trim(),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                          future: users.doc(firebaseUser.uid).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Hata oluştu :(");
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              Map<String, dynamic> data = snapshot.data.data();
                              return Material(
                                color: Colors.white24,
                                child: Column(
                                  children: [
                                    data['rfId'] != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              color: kPrimaryColor,
                                              child: ListTile(
                                                title: Center(
                                                  child: Wrap(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                          right: 8.0,
                                                        ),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Bileklik Etkin',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : TextButton(
                                            onPressed: () async {
                                              final databaseReferenceTest = FirebaseDatabase.instance.reference();
                                              await databaseReferenceTest.once().then((DataSnapshot snapshot) {
                                                var data = snapshot.value["3566"]["IS_USING"];
                                                if (data == true) {
                                                  setState(() async {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return MacheUsing();
                                                        },
                                                      ),
                                                    );
                                                    setState(() {});
                                                  });
                                                } else {
                                                  setState(() async {
                                                    await databaseReferenceTest.child('/3566/IS_USING').set(true);
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return ActivateBracelet();
                                                        },
                                                      ),
                                                    );
                                                    setState(() {});
                                                  });
                                                }
                                              });
                                            },
                                            child: Container(
                                              color: kPrimaryColor,
                                              child: ListTile(
                                                title: Center(
                                                  child: Text(
                                                    'Bilekliği Etkinleştir',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
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
                      RoundedButton(
                        text: "KAYDET",
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await _adjustProgressBar();
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: WESpinKit(),
          );
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

class MacheUsing extends StatelessWidget {
  const MacheUsing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset('assets/77295-not-available.json', height: 300),
          Center(
            child: Column(
              children: [
                Text(
                  'HeroStation şu anda dolu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Lütfen daha sonra tekrar dene.',
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
                    },
                    child: Text('Geri dön'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
