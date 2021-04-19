import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final TabController tabController;

  CustomBottomNavBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
          color: Colors.black),
      child: TabBar(
        automaticIndicatorColorAdjustment: true,
        indicatorColor: Colors.white70,
        unselectedLabelColor: Colors.white24,
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
