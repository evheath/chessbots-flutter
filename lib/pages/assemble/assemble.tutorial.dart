import 'package:flutter/material.dart';

class AssembleTutorial extends StatefulWidget {
  @override
  _AssembleTutorialState createState() => _AssembleTutorialState();
}

class _AssembleTutorialState extends State<AssembleTutorial>
    with SingleTickerProviderStateMixin {
  TabController _tutorialTabController;

  @override
  void initState() {
    _tutorialTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Assemble your chess bot!"),
      content: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tutorialTabController,
              children: _tabs,
            ),
          ),
          TabPageSelector(
            controller: _tutorialTabController,
            selectedColor: Colors.grey,
          ),
          RaisedButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  //TODO tabs:
  // - swipe to dismiss
  // - click on empty to fill
  // - top and bottom cannot be changed
  // - help icon takes you to demo
  // drag and drop to reorder
  List<Widget> _tabs = [Icon(Icons.queue_music), Icon(Icons.home)];
}
