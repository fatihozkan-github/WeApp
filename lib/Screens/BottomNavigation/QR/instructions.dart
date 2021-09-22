import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';

var instructions = [
  "Bütün ürünler plastik atık olmalıdır.",
  "Atıklar temiz ve kuru olmalıdır.",
  "Küçük atıkları büyük atıkların içine koy.",
  "Poşetlerinizi bağlayarak at.",
  "HeroStation’ın üstünde bulunan QR kodu okut.",
  "Kapağın kapandığından emin ol."
];

var instructionTitles = [
  "Geri dönüşüme uygun",
  "Tamamen temiz",
  "QR kodu okut",
  "Kapağı kapat"
];

final List<Widget> instructionItems = instructions
    .map((item) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            color: kPrimaryColor,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(item,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ))
    .toList();
