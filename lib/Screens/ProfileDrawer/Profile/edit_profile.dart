// ignore_for_file: omit_local_variable_types, prefer_single_quotes, unused_field, prefer_final_fields

import 'dart:async';
import 'package:WE/Resources/components/progress_bar.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/components/rounded_input_field.dart';
import 'package:WE/Resources/components/we_spin_kit.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/bracelet_page.dart';
import 'package:WE/Services/service_user.dart';
import 'package:WE/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _username, _city, _address, _superhero, _company;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  UserModel currentUser = UserModel();
  int _currentProgress = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<UserService>(context, listen: false).currentUser;
    if (!(nullCheck(currentUser.avatar))) _currentProgress++;
    if (!(nullCheck(currentUser.name))) _currentProgress++;
    if (!(nullCheck(currentUser.city))) _currentProgress++;
    if (!(nullCheck(currentUser.superhero))) _currentProgress++;
    if (!(nullCheck(currentUser.address))) _currentProgress++;
    if (!(nullCheck(currentUser.company))) _currentProgress++;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    currentUser = Provider.of<UserService>(context, listen: false).currentUser;
    return currentUser.userID != null
        ? ScaffoldMessenger(
            key: _scaffoldKey,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(backgroundColor: kPrimaryColor, title: Text('Profilini Düzenle'), centerTitle: true),
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
                      initialValue: currentUser.name,
                    ),
                    RoundedInputField(
                      hintText: "Favori süper kahraman",
                      icon: Icons.local_fire_department_outlined,
                      onChanged: (value) => _superhero = value.trim(),
                      initialValue: currentUser.superhero,
                    ),
                    RoundedInputField(
                      hintText: "Şehir",
                      icon: Icons.location_city_outlined,
                      onChanged: (value) => _city = value.trim(),
                      initialValue: currentUser.city,
                      validator: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Adres",
                      icon: Icons.location_on_rounded,
                      onChanged: (value) => _address = value.trim(),
                      initialValue: currentUser.address,
                      validator: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Şirket",
                      icon: Icons.work_rounded,
                      onChanged: (value) => _company = value.trim(),
                      initialValue: currentUser.company,
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
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BraceletPage())),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Container(width: 20, child: Image.asset("assets/Icons/bracelet.png", color: kPrimaryColor)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Bileklik Sayfasına Gitmek için Tıklayınız",
                                textAlign: TextAlign.center,
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
                          _adjustProgressBar();
                        }
                      },
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          )
        : WESpinKit();
  }

  Widget _getImageContainer(width) {
    TextStyle _hintTextStyle = TextStyle(fontSize: width / 25, color: Colors.grey, decoration: TextDecoration.none);
    return _isLoading
        ? Column(
            children: [
              Container(height: 150, width: 150, child: WESpinKit()),
              SizedBox(height: 10),
              Text("İşlemini Gerçekleştiriyoruz!", textAlign: TextAlign.center, style: _hintTextStyle),
            ],
          )
        : GestureDetector(
            onTap: () => uploadImage().catchError((e) => _snackBar('Bir hata oluştu!')),
            child: Column(
              children: [
                currentUser.avatar != null
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(currentUser.avatar)),
                        ),
                      )
                    : Icon(Icons.account_circle_rounded, size: 150, color: Colors.grey),
                SizedBox(height: 10),
                Text("Profil fotoğrafını değiştirmek için avatara dokun.", textAlign: TextAlign.center, style: _hintTextStyle),
              ],
            ),
          );
  }

  /// • Adjusts progress bar and updates user.
  void _adjustProgressBar() async {
    setState(() {});
    if (_username != null && _username != currentUser.name) {
      setState(() {
        if (_currentProgress < 7 && currentUser.name.trim() == '' && currentUser.name == null) _currentProgress++;
      });
      await Provider.of<UserService>(context, listen: false)
          .updateName(_username)
          .then((value) => _scaffoldKey.currentState.showSnackBar(_snackBar(value)));
    }
    setState(() {});
    if (_superhero != null && _superhero != currentUser.superhero) {
      setState(() {
        if (_currentProgress < 7 && currentUser.superhero.trim() == '' && currentUser.superhero == null) _currentProgress++;
      });
      await Provider.of<UserService>(context, listen: false)
          .updateSuperHero(_superhero)
          .then((value) => _scaffoldKey.currentState.showSnackBar(_snackBar(value)));
    }
    setState(() {});
    if (!nullCheck(_city) || _city != currentUser.city) {
      if (!nullCheck(_city) && nullCheck(currentUser.city))
        _currentProgress++;
      else if (nullCheck(_city) && !nullCheck(currentUser.city))
        _currentProgress--;
      else if (_city == currentUser.city) _currentProgress;

      await Provider.of<UserService>(context, listen: false)
          .updateCity(_city)
          .then((value) => _scaffoldKey.currentState.showSnackBar(_snackBar(value)));
    }
    setState(() {});
    if (!nullCheck(_address) || _address != currentUser.address) {
      if (!nullCheck(_address) && nullCheck(currentUser.address))
        _currentProgress++;
      else if (nullCheck(_address) && !nullCheck(currentUser.address))
        _currentProgress--;
      else if (_address == currentUser.address) _currentProgress;
      await Provider.of<UserService>(context, listen: false)
          .updateAddress(_address)
          .then((value) => _scaffoldKey.currentState.showSnackBar(_snackBar(value)));
    }
    setState(() {});
    if (!nullCheck(_company) || _company != currentUser.company) {
      if (!nullCheck(_company) && nullCheck(currentUser.company))
        _currentProgress++;
      else if (nullCheck(_company) && !nullCheck(currentUser.company))
        _currentProgress--;
      else if (_company == currentUser.company) _currentProgress;
      await Provider.of<UserService>(context, listen: false)
          .updateCompany(_company)
          .then((value) => _scaffoldKey.currentState.showSnackBar(_snackBar(value)));
    }
    setState(() {});
  }

  SnackBar _snackBar(value) => SnackBar(
        content: Text(value.toString().isEmpty || value == null ? 'İşlem Başarılı.' : 'İşlem Başarılı: $value'),
        backgroundColor: kPrimaryColor,
        elevation: 10,
        duration: Duration(milliseconds: 2000),
      );

  bool nullCheck(String value) {
    if (value == null || value?.trim() == '') {
      return true;
    } else if (value != null || value?.trim() != '') {
      return false;
    } else
      return null;
  }

  Future uploadImage() async {
    setState(() => _isLoading = true);
    String newImage = await Provider.of<UserService>(context, listen: false).updateImage();
    currentUser.avatar = newImage;
    Timer(Duration(seconds: 2), () => setState(() => _isLoading = false));
  }
}
