import 'package:flutter/material.dart';

class SelectGambitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text("Select a gambit"),
            bottom: TabBar(
              tabs: _tabs,
            ),
          ),
          body: TabBarView(children: _tabPages)),
    );
  }

  final List<Widget> _tabs = [
    Tab(
      icon: Icon(
        Icons.directions_car,
        color: Colors.red,
      ),
    ),
    Tab(
      icon: Icon(Icons.directions_transit),
    ),
    Tab(
      icon: Icon(Icons.directions_bike),
    ),
  ];

  final List<Widget> _tabPages = [
    Center(
      child: Icon(Icons.directions_car),
    ),
    Center(
      child: Icon(Icons.directions_transit),
    ),
    Center(
      child: Icon(Icons.directions_bike),
    ),
  ];
}
