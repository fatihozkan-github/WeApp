import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class APIUserService extends ChangeNotifier {
  /// TODO: Not safe enough!
  final CollectionReference _brewCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserName({String userID, String newName}) async {
    await _brewCollection.doc(userID).update({'name': newName});
    return newName;
  }

  Future updateCity({String userID, String newCity}) async {
    await _brewCollection.doc(userID).update({'city': newCity});
    return newCity;
  }

  Future updateSuperHero({String userID, String newSuperHero}) async {
    await _brewCollection.doc(userID).update({'superhero': newSuperHero});
    return newSuperHero;
  }

  Future updateAddress({String userID, String newAddress}) async {
    await _brewCollection.doc(userID).update({'address': newAddress});
    return newAddress;
  }

  Future updateCompany({String userID, String newCompany}) async {
    await _brewCollection.doc(userID).update({'company': newCompany});
    return newCompany;
  }

  Future<String> updateImage({String defaultValue}) async {
    final _storage = FirebaseStorage.instance;
    File image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus == PermissionStatus.granted) {
      try {
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (image.path != null && image != null) {
          var snapshot = await _storage.ref().child('profilePhotos/${image.path}').putFile(image);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          await _brewCollection.doc(FirebaseAuth.instance.currentUser.uid).update({'avatar': downloadUrl});
          return downloadUrl;
        } else {
          print('No Path Received');
          return defaultValue;
        }
      } catch (e) {
        print('ERROR LOG: $e');
        return defaultValue;
      }
    } else {
      print('Grant Permissions and try again');
      return defaultValue;
    }
  }
}
