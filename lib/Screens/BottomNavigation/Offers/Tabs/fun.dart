import 'package:WE/Resources/components/opportunities/sliding_cards.dart';
import 'package:flutter/material.dart';

class FunTab extends StatefulWidget {
  @override
  _FunTabState createState() => _FunTabState();
}

class _FunTabState extends State<FunTab> {
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
              name: 'Steam %20 Discount code',
              date: '24.05 / 31.05',
              assetName: 'assets/Images/Offers/steam.png',
              offset: pageOffset,
              price: "180.00 WE coin"),
          SlidingCard(
              name: '2 for 1 Ticket Deals at Cinemaximum',
              date: 'Every Saturdays',
              assetName: 'assets/Images/Offers/cinemaximum.jpg',
              offset: pageOffset - 1,
              price: "60.00 WE coin"),
        ],
      ),
    );
  }
}
