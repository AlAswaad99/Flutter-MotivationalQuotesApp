import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final TabController tabController;

  CustomBottomNavBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
        color: const Color.fromRGBO(11, 11, 11, 1),
      ),
      child: TabBar(
        automaticIndicatorColorAdjustment: true,
        indicatorColor: Colors.white70,
        unselectedLabelColor: Colors.white24,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorSize: TabBarIndicatorSize.tab,
        controller: tabController,
        tabs: [
          Tab(
            icon: Icon(
              Icons.favorite,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.format_quote,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(Icons.list),
          ),
        ],
      ),
    );
  }
}
