// ignore_for_file: omit_local_variable_types, prefer_single_quotes

import 'dart:io';
import 'package:WE/Resources/components/we_text_field.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/bottom_navigation.dart';
import 'package:WE/Services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
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
  String _newUsername, _newEmail, _newPassword, _newAddress, _newSuperhero, _newCity;
  String imageUrl;
  DocumentReference sightingRef = FirebaseFirestore.instance.collection("users").doc();
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');

  uploadImage() async {
    print('ch1');
    final _storage = FirebaseStorage.instance;
    File image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
      print(image);
      print('ch2');
      print(File(image.path));
      var file = File(image.path);

      if (image != null) {
        var snapshot = await _storage.ref().child('profilePhotos/${basename(image.path)}').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        await brewCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
          'avatar': downloadUrl,
        });
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        SizedBox(height: 30),
        WeTextFormField(),
        SizedBox(height: 30),
        WeTextFormField(),
        SizedBox(height: 30),
        WeTextFormField(),
      ],
    );
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

  _getBody(data, context, size) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => uploadImage(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: imageUrl != null
                          ? Container(
                              height: 220,
                              width: 440,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(data["avatar"]))),
                            )
                          : Icon(Icons.account_circle_rounded, size: 150, color: Colors.grey),
                    ),
                    Container(
                      child: Center(
                          child:
                              Text("Profil fotoğrafını değiştirmek için avatara dokun.", style: TextStyle(color: Colors.grey))),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                  title: Text('Kullancı adı:', style: TextStyle(color: Colors.grey, fontSize: 20)),
                  subtitle: TextField(
                    onSubmitted: (value1) {
                      setState(() {
                        _newUsername = value1.trim();
                        brewCollection.doc(currentUid).update({
                          "name": _newUsername,
                        });
                      });
                    },
                    style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                      hintText: data["name"],
                    ),
                  )),
              ListTile(
                  title: Text('Şehir:', style: TextStyle(color: Colors.grey, fontSize: 20)),
                  subtitle: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        _newCity = value.trim();
                        brewCollection.doc(currentUid).update({
                          "city": _newCity,
                        });
                      });
                    },
                    style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                      hintText: data["city"],
                    ),
                  )),
              ListTile(
                title: Text('Favori süper kahraman', style: TextStyle(color: Colors.grey, fontSize: 20)),
                subtitle: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      _newSuperhero = value.trim();
                      brewCollection.doc(currentUid).update({"superhero": _newSuperhero});
                    });
                  },
                  style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                    hintText: data["superhero"],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    setState(() => Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation())));
                  },
                  child: Container(
                    color: kPrimaryColor,
                    height: size.height * 0.05,
                    width: size.width * 0.9,
                    child: Center(child: Text("Onayla", style: TextStyle(color: Colors.black, fontSize: 16))),
                  ))
            ],
          ),
        ),
      );
}
