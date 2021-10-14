import 'dart:developer';
import 'dart:io';
import 'package:WE/Resources/components/rounded_button.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/QR/code_page.dart';
import 'package:WE/Screens/BottomNavigation/QR/transition_page.dart';
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
  final GlobalKey qrKey = GlobalKey();
  final GlobalKey bottomKey = GlobalKey();

  Future checkPermissions({bool init}) async {
    permissionStatus = await Permission.camera.status;
    print(permissionStatus);
    await Permission.camera.request();
    if (await Permission.camera.isPermanentlyDenied) {
      await openAppSettings().then((value) async {
        if (await Permission.camera.isGranted) {
          setState(() {});
        }
      });
    }
    if (!init) {
      setState(() {});
    }
  }

  @override
  void initState() {
    checkPermissions(init: true);
    super.initState();
  }

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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('QR Okutma')),
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
                    RoundedButton(
                      useCustomChild: true,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      borderRadius: BorderRadius.circular(5),
                      constraints: BoxConstraints(maxWidth: 90.0, minHeight: 50.0),
                      customChild: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.password_rounded, color: Colors.white),
                            Text(
                              'KOD GİR',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: width / 35, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => CodePage(),
                        barrierColor: Colors.orange.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      ),
                    ),
                    RoundedButton(
                      useCustomChild: true,
                      borderRadius: BorderRadius.circular(5),
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      constraints: BoxConstraints(maxWidth: 90.0, minHeight: 50.0),
                      customChild: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return snapshot.data.toString() != null
                                      ? Icon(Icons.lightbulb, color: Colors.white)
                                      : Icon(Icons.lightbulb_outline, color: Colors.white);
                                },
                              ),
                              // Text(
                              //   '',
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(color: Colors.white, fontSize: width / 35, fontWeight: FontWeight.bold),
                              // ),
                            ],
                          )),
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                    ),
                    RoundedButton(
                      useCustomChild: true,
                      borderRadius: BorderRadius.circular(5),
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      constraints: BoxConstraints(maxWidth: 90.0, minHeight: 50.0),
                      customChild: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Transform(
                                    transform: Matrix4.rotationZ(180),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.autorenew_rounded, color: Colors.white),
                                  );
                                } else {
                                  return Text('X');
                                }
                              },
                            ),
                            // Text(
                            //   '',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(color: Colors.white, fontSize: width / 35, fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                    ),
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
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    if (!permissionStatus.isGranted) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: [
          SizedBox(height: 50),
          Text(
            'QR kod taraması için kamera izninize ihtiyacımız var.',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          RoundedButton(text: 'Kontrol Et', onPressed: () async => checkPermissions(init: false)),
        ],
      );
    } else {
      return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: kPrimaryColor, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      print('QR CODE: ${result.code}');
      // if (result.code == "6G34") {
      if (result.code == "3566") {
        controller.stopCamera();
        Navigator.push(context, MaterialPageRoute(builder: (context) => TransitionPage(qrResult: result.code)));
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}

///
// Container(
//   margin: EdgeInsets.all(8),
//   child: ElevatedButton(
//       style: ElevatedButton.styleFrom(primary: kPrimaryColor),
//       onPressed: () async {
//         await controller?.toggleFlash();
//         setState(() {});
//       },
//       child: FutureBuilder(
//         future: controller?.getFlashStatus(),
//         builder: (context, snapshot) {
//           return snapshot.data.toString() != null ? Icon(Icons.lightbulb) : Icon(Icons.lightbulb_outline);
//         },
//       )),
// ),
// Container(
//   margin: EdgeInsets.all(8),
//   child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: kPrimaryColor,
//       ),
//       onPressed: () async {
//         await controller?.flipCamera();
//         setState(() {});
//       },
//       child: FutureBuilder(
//         future: controller?.getCameraInfo(),
//         builder: (context, snapshot) {
//           if (snapshot.data != null) {
//             return Transform(
//               transform: Matrix4.rotationZ(180),
//               alignment: Alignment.center,
//               child: Icon(Icons.autorenew_rounded),
//             );
//           } else {
//             return Text('X');
//           }
//         },
//       )),
// ),
