import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/gambit_list_tile.dart';
import '../shared/gambits.dart';
import '../models/gambit.dart';

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
        body: TabBarView(
          children: _buildTabPages([
            _offensiveGambits,
            _defensiveGambits,
            _promotionGambits,
            _movementGambits,
          ]),
        ),
      ),
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

  List<Widget> _buildTabPages(List<List<Gambit>> listOfLists) {
    return List.generate(listOfLists.length, (outerIndex) {
      // listOfGambits will be _offensiveGambits, _defensiveGambits etc
      List<Gambit> listOfGambits = listOfLists[outerIndex];
      return ListView(
        children: List.generate(listOfGambits.length, (innerIndex) {
          return GestureDetector(
            onTap: () {
              // TODO this is where selection logic should go
              print("tap detector fired");
            },
            child: GambitListTile(gambit: listOfGambits[innerIndex]),
          );
        }),
      );
    });
  }

  static final List<Gambit> _offensiveGambits = [
    CaptureQueen(),
    CaptureRook(),
    CaptureBishop(),
    CaptureKnight(),
    CapturePawn(),
    CaptureRandomPiece(),
  ];

  static final List<Gambit> _defensiveGambits = [
    CastleKingSide(),
    CastleQueenSide(),
  ];

  static final List<Gambit> _promotionGambits = [
    PromotePawnToQueen(),
    PromotePawnToRook(),
    PromotePawnToBishop(),
    PromotePawnToKnight(),
    PromotePawnToRandom(),
  ];

  static final List<Gambit> _movementGambits = [
    MoveRandomPawn(),
  ];
}
