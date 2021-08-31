import 'package:WE/Resources/components/opportunities/sliding_cards.dart';
import 'package:flutter/material.dart';

class HealthTab extends StatefulWidget {
  @override
  _HealthTabState createState() => _HealthTabState();
}

class _HealthTabState extends State<HealthTab> {
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
              name: "Gold's gym equipments %75 discount code",
              date: 'Only this weekend',
              assetName: 'assets/Images/Offers/goldgym.png',
              offset: pageOffset,
              price: "150.00 WE coin"),
          SlidingCard(
              name: '1 month subscription to Palo Alto gym',
              date: 'Until 2022',
              assetName: 'assets/Images/Offers/paloaltogym.jpg',
              offset: pageOffset - 1,
              price: "200.00 WE coin"),
        ],
      ),
    );
  }
}
