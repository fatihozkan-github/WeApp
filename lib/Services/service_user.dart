import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class UserService extends ChangeNotifier {
  DocumentReference sightingRef = FirebaseFirestore.instance.collection("users").doc();
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');
  String imageUrl;

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
        // setState(() {
        imageUrl = downloadUrl;
        // });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
    notifyListeners();
  }
}
