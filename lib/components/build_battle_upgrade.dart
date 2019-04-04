import 'package:flutter/material.dart';

class BuildBattleUpgrade extends StatefulWidget {
  @override
  _BuildBattleUpgradeState createState() => _BuildBattleUpgradeState();
}

class _BuildBattleUpgradeState extends State<BuildBattleUpgrade>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
    _animationController.forward(); // fire once
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BuildBattleUpgradeAnimation(
      controller: _animationController,
    );
  }
}

class BuildBattleUpgradeAnimation extends StatelessWidget {
  BuildBattleUpgradeAnimation({Key key, this.controller})
      : _build = Tween<double>(
          begin: 1000.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.333,
              curve: Curves.bounceIn,
            ),
          ),
        ),
        _battle = Tween<double>(
          begin: 1000.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.333,
              0.666,
              curve: Curves.bounceIn,
            ),
          ),
        ),
        _upgrade = Tween<double>(
          begin: 1000.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.666,
              1.0,
              curve: Curves.bounceIn,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> _battle;
  final Animation<double> _build;
  final Animation<double> _upgrade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, widget) {
                return Transform.translate(
                  offset: Offset(_build.value, 0),
                  child: Text(
                    "Build",
                    style: TextStyle(fontFamily: 'Shojumaru'),
                  ),
                );
              }),
        ),
        AnimatedBuilder(
            animation: controller,
            builder: (context, widget) {
              return Transform.translate(
                offset: Offset(_battle.value, 0),
                child: Text(
                  "Battle",
                  style: TextStyle(fontFamily: 'Shojumaru'),
                ),
              );
            }),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, widget) {
                return Transform.translate(
                  offset: Offset(_upgrade.value, 0),
                  child: Text(
                    "Upgrade",
                    style: TextStyle(fontFamily: 'Shojumaru'),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
