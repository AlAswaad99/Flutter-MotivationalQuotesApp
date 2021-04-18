import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final TabController tabController;

  CustomBottomNavBar({this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: TabBar(
        indicatorColor: Colors.white70,
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
            icon: Icon(
              Icons.info,
            ),
          ),
        ],
      ),
    );
  }
}
