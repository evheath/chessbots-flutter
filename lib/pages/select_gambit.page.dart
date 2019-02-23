import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectGambitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
      icon: Icon(FontAwesomeIcons.bomb, color: Colors.red),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.shieldAlt, color: Colors.blue),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.medal, color: Colors.yellow),
    ),
    Tab(
      icon: Icon(FontAwesomeIcons.shoePrints, color: Colors.white),
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
    Center(
      child: Icon(Icons.directions_bike),
    ),
  ];
}
