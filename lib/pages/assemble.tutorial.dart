import '../shared/gambit_list_tile.dart';
import '../shared/gambits.dart';
import 'package:flutter/material.dart';

class AssembleTutorial extends StatefulWidget {
  @override
  _AssembleTutorialState createState() => _AssembleTutorialState();
}

class _AssembleTutorialState extends State<AssembleTutorial>
    with TickerProviderStateMixin {
  TabController _tutorialTabController;
  AnimationController _animationController;

  @override
  void initState() {
    _tutorialTabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    // _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _tutorialTabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO tabs:
    // - click on empty to fill
    // - top and bottom cannot be changed
    // - help icon takes you to demo
    // drag and drop to reorder
    // _tabs needs to be in build to access animation controller
    List<Widget> _tabs = [
      //tab 1
      Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SwipingAnimation(controller: _animationController),
          Text("Swipe to dismiss a gambit!"),
        ],
      ),
      //tab2
      Icon(Icons.home),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("How to assemble gambits"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
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
}

class SwipingAnimation extends StatelessWidget {
  SwipingAnimation({Key key, this.controller})
      : translation = Tween<double>(
          begin: 0.0,
          end: 500.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.ease),
        ),
        super(key: key) {
    controller.repeat();
  }

  final AnimationController controller;
  final Animation<double> translation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Transform.translate(
            offset: Offset(translation.value, 0),
            child: GambitListTile(gambit: CheckOpponent()),
          );
        });
  }
}
