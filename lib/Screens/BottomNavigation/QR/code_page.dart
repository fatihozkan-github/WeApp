import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/edit_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodePage extends StatefulWidget {
  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String currentText = '';
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('QR Okutma', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          SizedBox(height: 20),
          Text('Kodunu aşağıdaki alana girebilirsin!',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 6),
            child: PinCodeTextField(
              length: 4,
              appContext: context,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 60,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveColor: Colors.white,
                selectedFillColor: Colors.grey[100],
                selectedColor: Colors.orange,
                inactiveFillColor: Colors.grey[300],
              ),
              textCapitalization: TextCapitalization.characters,
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              // errorAnimationController: errorController,
              // controller: textEditingController,
              // onCompleted: (v) {
              //   print("Completed");
              // },
              onChanged: (value) {
                setState(() {
                  currentText = value.toUpperCase();
                  showError = false;
                });
              },
              // beforeTextPaste: (text) {
              //   print("Allowing to paste $text");
              //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
              //   return true;
              // },
            ),
          ),
          if (showError)
            Text('Doğru kodu girdiğinden emin ol!',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
          SizedBox(height: 20),
          RoundedButton(
            text: 'ONAYLA',
            onPressed: () async {
              print(currentText);
              if (currentText == "3566") {
                final databaseReferenceTest =
                    FirebaseDatabase.instance.reference();
                await databaseReferenceTest
                    .once()
                    .then((DataSnapshot snapshot) async {
                  var data = snapshot.value["3566"]["IS_USING"];
                  if (data == true) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MacheUsing();
                        },
                      ),
                    );
                  } else {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransitionPage(
                          qrResult: currentText,
                        ),
                      ),
                    );
                  }
                });
              } else if (currentText != "3566") {
                setState(() => showError = true);
              } else {
                setState(() => showError = true);
              }
            },
          ),
        ],
      ),
    );
  }
}
