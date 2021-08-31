import 'package:WE/Resources/components/opportunities/sliding_cards.dart';
import 'package:flutter/material.dart';

class ShoppingTab extends StatefulWidget {
  @override
  _ShoppingTabState createState() => _ShoppingTabState();
}

class _ShoppingTabState extends State<ShoppingTab> {
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
              name: 'Amazon %25 OFF',
              date: '31.05 / 30.06',
              assetName: 'assets/Images/Offers/amazon.jpg',
              offset: pageOffset,
              price: "200.00 WE coin"),
          SlidingCard(
              name: 'Get your Tesla with WE Coin',
              date: '1.05.2021 / --',
              assetName: 'assets/Images/Offers/tesla.jpg',
              offset: pageOffset - 1,
              price: "25.000 WE coin"),
          SlidingCard(
              name: 'Buy 1, get 1 for free',
              date: '31.05 / 30.06',
              assetName: 'assets/Images/Offers/ebay.jpg',
              offset: pageOffset - 2,
              price: "250.00 WE coin"),
          SlidingCard(
              name: 'At least 15% discount at eBay',
              date: '31.05 / 30.06',
              assetName: 'assets/Images/Offers/wallmart.jpg',
              offset: pageOffset - 3,
              price: "100.00 WE coin"),
        ],
      ),
    );
  }
}
