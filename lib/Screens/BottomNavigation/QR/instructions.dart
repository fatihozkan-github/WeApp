import 'package:flutter/material.dart';
import 'package:WE/Resources/constants.dart';

var instructions = [
  "Bütün ürünler plastik atık olmalıdır.",
  "Atıklar temiz ve kuru olmalıdır.",
  "Küçük atıkları büyük atıkların içine koy.",
  "Poşetlerini bağlayarak at.",
  // "HeroStation’ın üstünde bulunan QR kodu okut.",
  "Kapağın kapandığından emin ol.",
];

var instruction_images = [
  'assets/plastik_atik.png',
  'assets/temiz.png',
  'assets/kucuk.png',
  'assets/poset.png',
  //'',
  '',
];

var instructionTitles = [
  "Geri dönüşüme uygun",
  "Tamamen temiz",
  "QR kodu okut",
  "Kapağı kapat"
];

// final List<Widget> instructionItems = instructions
//     .map((item) => Container(
//           padding: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: kPrimaryColor),
//           child: Text(item, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white)),
//         ))
//     .toList();
