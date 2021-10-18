import 'dart:developer';
import 'dart:io';

import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/code_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/qr_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/activate_bracelet.dart';
import 'package:WE/Screens/ProfileDrawer/Profile/edit_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  QRViewController controller;
  PermissionStatus permissionStatus;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int count = 0;
  final databaseReferenceTest = FirebaseDatabase.instance.reference();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  Future checkPermissions({bool init}) async {
    await Permission.camera.request();
    permissionStatus = await Permission.camera.status;
    print(permissionStatus);
    if (await Permission.camera.isPermanentlyDenied) {
      await openAppSettings().then((value) async {
        if (await Permission.camera.isGranted) {
          setState(() {});
        }
      });
    }
    if (!init) {
      count += 1;
      setState(() {});
    }
    setState(() {});
  }

  @override
  void initState() {
    checkPermissions(init: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('QR Okutma', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: BackButton(
          onPressed: () async {
            await databaseReference.child('/3566/SIGN_UP').set(false);
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          if (permissionStatus.isGranted)
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8),
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: kPrimaryColor),
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return snapshot.data.toString() != null
                                  ? Icon(Icons.lightbulb)
                                  : Icon(Icons.lightbulb_outline);
                            },
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                          ),
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Transform(
                                  transform: Matrix4.rotationZ(180),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.autorenew_rounded),
                                );
                              } else {
                                return Text('X');
                              }
                            },
                          )),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    print(permissionStatus);
    if (!permissionStatus.isGranted) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'QR kod taraması için \nkamera izninize ihtiyacımız var.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () async => checkPermissions(init: false),
                  child: Text(
                    'Kontrol Et',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            if (count > 4)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    height: 2,
                  ),
                  Text(' yada '),
                  Container(
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    height: 2,
                  ),
                ],
              ),
            if (count > 4)
              Column(
                children: [
                  Text(
                    'QR kodu okuyamıyorsan \n4 haneli kodu girerek devam edebilirsin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CodePage();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Kodu Gir',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    } else {
      return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: kPrimaryColor,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    var bool = false;
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      print('QR CODE: ${result.code}');
      // if (result.code == "6G34") {
      if (result.code == "3566") {
        await databaseReferenceTest.once().then((DataSnapshot snapshot) async {
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
            await databaseReferenceTest.child('/3566/IS_USING').set(true);
            await controller.stopCamera();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TransitionPage(
                    qrResult: result.code,
                  );
                },
              ),
            );
          }
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'QR kodu okutmak için lütfen uygulama ayarlarından Kamera Erişimine izin verin.')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
