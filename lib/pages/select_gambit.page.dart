import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/gambit_list_tile.dart';
import '../shared/gambits.dart';

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
    ListView(
      // offense
      children: <Widget>[
        GambitListTile(gambit: CaptureQueen()),
        GambitListTile(gambit: CaptureRook()),
        GambitListTile(gambit: CaptureBishop()),
        GambitListTile(gambit: CaptureKnight()),
        GambitListTile(gambit: CapturePawn()),
        GambitListTile(gambit: CaptureRandomPiece()),
      ],
    ),
    ListView(
      // defense
      children: <Widget>[
        GambitListTile(gambit: CastleKingSide()),
        GambitListTile(gambit: CastleQueenSide()),
      ],
    ),
    ListView(
      // promotion
      children: <Widget>[
        GambitListTile(gambit: PromotePawnToQueen()),
        GambitListTile(gambit: PromotePawnToRook()),
        GambitListTile(gambit: PromotePawnToBishop()),
        GambitListTile(gambit: PromotePawnToKnight()),
        GambitListTile(gambit: PromotePawnToRandom()),
      ],
    ),
    ListView(
      // move
      children: <Widget>[
        GambitListTile(gambit: MoveRandomPawn()),
      ],
    ),
  ];
}
