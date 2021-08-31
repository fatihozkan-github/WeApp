import 'package:WE/Resources/components/opportunities/tabs.dart';
import 'package:WE/Resources/constants.dart';
import 'package:WE/Screens/BottomNavigation/Offers/Tabs/education.dart';
import 'package:WE/Screens/BottomNavigation/Offers/Tabs/fun.dart';
import 'package:WE/Screens/BottomNavigation/Offers/Tabs/health.dart';
import 'package:WE/Screens/BottomNavigation/Offers/Tabs/shopping.dart';
import 'package:flutter/material.dart';

class Offer extends StatelessWidget {
  final bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Opportunities",
          style: TextStyle(fontSize: 30, fontFamily: "Panthera"),
        ),
      ),
      body: Stack(
        children: [
          Container(
              child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 18.0, right: 4),
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      color: Colors.white,
                      height: 52,
                      child: TabBar(
                        tabs: [
                          MyTab(
                            text: 'Shopping',
                            isSelected: true,
                          ),
                          MyTab(
                            text: 'Fun',
                            isSelected: true,
                          ),
                          MyTab(
                            text: 'Health',
                            isSelected: true,
                          ),
                          MyTab(
                            text: 'Education',
                            isSelected: true,
                          ),
                        ],
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        indicatorColor: kPrimaryColor,
                        indicatorWeight: 6,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: isSelected ? Color(0xFFFF5A1D) : Colors.white,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      children: [
                        ShoppingTab(),
                        FunTab(),
                        HealthTab(),
                        EducationTab(),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
