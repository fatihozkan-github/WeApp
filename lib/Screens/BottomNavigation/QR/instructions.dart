import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';

var instructions = [
  "Ürünler plastik ve geri dönüşüme uygun olmalıdır.",
  "Ürünlerin içi sıvı vs. açısından tamamen boş olmalıdır.",
  "Cihazınızdan HeroStation üzerindeki QR kodunu okuyun.",
  "Hey\! yeni kahramanlara hazır olması için HeroStation'daki kapağın kapandığından emin olun."
];

var instructionTitles = [
  "Geri dönüşüme uygun",
  "Tamamen temiz",
  "QR kodu okut",
  "Kapağı kapat"
];

final List<Widget> instructionItems = instructions
    .map((item) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            color: Colors.grey,
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(item,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [kPrimaryColor, kPrimaryColorOld],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Center(
                            child: Text(
                              instructionTitles[instructions.indexOf(item)],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ))
    .toList();
