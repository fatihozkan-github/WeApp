// ignore_for_file: omit_local_variable_types

import 'package:WE/API/API_user_service.dart';
import 'package:WE/models/model_friend.dart';
import 'package:WE/models/model_user.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final APIUserService _apiUserService = APIUserService();
  UserModel currentUser = UserModel();

  Future gotUser({UserModel loggedInUser}) async {
    currentUser = loggedInUser;
    notifyListeners();
  }

  Future getFriends() async {
    currentUser.friends = await _apiUserService.fetchFriends(userID: currentUser.userID);
    notifyListeners();
  }

  /// TODO
  Future addFriend({FriendModel friend}) async {
    await _apiUserService.addFriend(friend: friend);
    notifyListeners();
  }

  Future<String> updateImage() async {
    String newImage = await _apiUserService.updateImage(defaultValue: currentUser.avatar);
    if (newImage != null) currentUser.avatar = newImage;
    notifyListeners();
    return newImage;
  }

  Future<String> updateName(String newName) async {
    String name = await _apiUserService.updateUserName(userID: currentUser.userID, newName: newName);
    currentUser.name = name;
    notifyListeners();
    return name;
  }

  Future<String> updateCity(String newCity) async {
    String city = await _apiUserService.updateCity(userID: currentUser.userID, newCity: newCity);
    currentUser.city = city;
    notifyListeners();
    return city;
  }

  Future<String> updateSuperHero(String newSuperHero) async {
    String superHero = await _apiUserService.updateSuperHero(userID: currentUser.userID, newSuperHero: newSuperHero);
    currentUser.superhero = superHero;
    notifyListeners();
    return superHero;
  }

  Future<String> updateAddress(String newAddress) async {
    String address = await _apiUserService.updateAddress(userID: currentUser.userID, newAddress: newAddress);
    currentUser.address = address;
    notifyListeners();
    return address;
  }

  Future<String> updateCompany(String newCompany) async {
    String company = await _apiUserService.updateCompany(userID: currentUser.userID, newCompany: newCompany);
    currentUser.company = company;
    notifyListeners();
    return company;
  }

  /// • Test function for current user.
  void currentUserInfo() {
    print('userID    : ${currentUser.userID}');
    print('name      : ${currentUser.name}');
    print('city      : ${currentUser.city}');
    print('email     : ${currentUser.email}');
    print('superhero : ${currentUser.superhero}');
    print('avatar    : ${currentUser.avatar}');
    print('level     : ${currentUser.level}');
    print('exp       : ${currentUser.exp}');
    print('badges    : ${currentUser.badges}');
    print('recycled  : ${currentUser.recycled}');
    print('friends   : ${currentUser.friends}');
    print('For info  : See UserService');
  }
}

/// • We are waiting for return of the API service in order to avoid wrong state updates.
///
/// • If we simply use, for example, newName and say [currentUser.name = newName], state will be updated but nothing
/// will change at database in case of an error on API services.
