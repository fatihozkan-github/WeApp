import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        SizedBox(height: 40),
        Text('QR Kodunu aşağıdaki alana girebilirsin!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        SizedBox(height: 25),
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
            onChanged: (value) {
              setState(() {
                currentText = value.toUpperCase();
                showError = false;
              });
            },
          ),
        ),
        if (showError) Text('Doğru kodu girdiğinden emin ol!', style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
        SizedBox(height: 20),
        RoundedButton(
          text: 'ONAYLA',
          onPressed: () {
            print(currentText);
            if (currentText == "6G34") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TransitionPage(qrResult: currentText)));
            } else if (currentText != "6G34") {
              setState(() => showError = true);
            } else {
              setState(() => showError = true);
            }
          },
        ),
      ],
    );
  }
}
