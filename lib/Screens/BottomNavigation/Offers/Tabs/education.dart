import 'package:WE/Resources/components/opportunities/sliding_cards.dart';
import 'package:flutter/material.dart';

class EducationTab extends StatefulWidget {
  @override
  _EducationTabState createState() => _EducationTabState();
}

class _EducationTabState extends State<EducationTab> {
  PageController pageController;

  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
        controller: pageController,
        children: <Widget>[
          SlidingCard(
              name: 'An Angela Yu courses on Udemy',
              date: '14.05 / 14.09',
              assetName: 'assets/Images/Offers/angelayu.jpg',
              offset: pageOffset,
              price: "100.00 WE coin"),
          SlidingCard(
              name: '3 month subscription from George Peabody online library',
              date: 'Until 31.12',
              assetName: 'assets/Images/Offers/library.jpg',
              offset: pageOffset - 1,
              price: "90.00 WE coin"),
        ],
      ),
    );
  }
}
