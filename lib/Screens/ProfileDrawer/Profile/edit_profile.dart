// ignore_for_file: omit_local_variable_types, prefer_single_quotes, unused_field, prefer_final_fields

import 'dart:io';
import 'package:WE/Resources/components/progress_bar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/unFocuser.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/activate_bracelet.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _username, _city, _address, _superhero, _company, _referral, _bracelet, imageUrl;
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');
  DocumentReference sightingRef = FirebaseFirestore.instance.collection("users").doc();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot;
  int _currentProgress = 0;
  Map<String, dynamic> data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    snapshot = await users.doc(firebaseUser.uid).get();
    setState(() => data = snapshot.data());
    print(snapshot.data());
    _currentProgress = 0;
    if (data["name"] != null && data["name"].toString().isNotEmpty) _currentProgress++;
    if (data["city"] != null && data["city"].toString().isNotEmpty) _currentProgress++;
    if (data["superhero"] != null && data["superhero"].toString().isNotEmpty) _currentProgress++;
    if (data["address"] != null && data["address"].toString().isNotEmpty) _currentProgress++;
    if (data["company"] != null && data["company"].toString().isNotEmpty) _currentProgress++;
    if (data["avatar"] != null && data["avatar"].toString().isNotEmpty) _currentProgress++;
  }

  Future uploadImage() async {
    final _storage = FirebaseStorage.instance;
    var image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    print(permissionStatus);
    if (permissionStatus == PermissionStatus.granted) {
      try {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
        File file = File(image.path);

        if (image != null) {
          var snapshot = await _storage.ref().child('profilePhotos/${basename(image.path)}').putFile(file);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          await brewCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
            'avatar': downloadUrl,
          });
          setState(() {
            imageUrl = downloadUrl;
            // if (data["avatar"] == null) {
            //   _currentProgress++;
            // }
          });
        } else {
          print('No Path Received');
        }
      } catch (e) {
        print('ERROR LOG: $e');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return snapshot != null
        ? UnFocuser(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text('Profilini Düzenle')),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    SizedBox(height: 30),
                    _getImageContainer(width),
                    SizedBox(height: 20),
                    ProgressBar(currentValue: _currentProgress),
                    SizedBox(height: 20),
                    RoundedInputField(
                      hintText: "Kullanıcı Adı",
                      onChanged: (value) => _username = value.trim(),
                      initialValue: data["name"],
                    ),
                    RoundedInputField(
                      hintText: "Şehir",
                      icon: Icons.location_city_outlined,
                      onChanged: (value) => _city = value.trim(),
                      initialValue: data["city"],
                    ),
                    RoundedInputField(
                      hintText: "Favori süper kahraman",
                      icon: Icons.local_fire_department_outlined,
                      onChanged: (value) => _superhero = value.trim(),
                      initialValue: data["superhero"],
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
                    Container(
                      height: 60.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivateBracelet())),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Container(width: 20, child: Image.asset("assets/Icons/bracelet.png", color: kPrimaryColor)),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "Bileklik Tanımlamak İçin Tıklayınız",
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(
                      text: "KAYDET",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await _adjustProgressBar();
                        }
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        : WESpinKit();
  }

  _getImageContainer(width) => GestureDetector(
        onTap: () => uploadImage().whenComplete(() async {
          _currentProgress = 0;
          getData();
          setState(() {
            print('uploaded');
          });
        }),
        child: Column(
          children: [
            data["avatar"] != null
                ? Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"])),
                    ),
                  )
                : Icon(Icons.account_circle_rounded, size: 150, color: Colors.grey),
            // SizedBox(height: 10),
            // if (data["avatar"] != null)
            //   GestureDetector(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Fotoğrafımı kaldır.',
            //           style: TextStyle(fontSize: width / 25, color: Colors.grey, decoration: TextDecoration.none),
            //         ),
            //         Icon(Icons.remove_circle_rounded, color: Colors.red),
            //       ],
            //     ),
            //     onTap: () async {
            //       setState(() {
            //         _currentProgress--;
            //       });
            //       await brewCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
            //         'avatar': null,
            //       });
            //     },
            //   ),
            SizedBox(height: 10),
            Text(
              "Profil fotoğrafını değiştirmek için avatara dokun.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: width / 25, color: Colors.grey, decoration: TextDecoration.none),
            ),
          ],
        ),
      );

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
    getData();
  }

  // Future<bool> _onWillPop() {
  //   Navigator.of(context).pop();
  //   Navigator.of(context).setState(() {});
  //   // return false;
  // }
}

///
// await brewCollection.doc(currentUid).update({
//                       //   "name": _username,
//                       //   "city": _city,
//                       //   // "adress": _address,
//                       //   // "company": _company,
//                       //   "superhero": _superhero,
//                       // });
//                       ///
//                       // setState(() => Navigator.pop(context));

/// OLD
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
/// Old
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
