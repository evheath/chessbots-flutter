import '../bloc/base.bloc.dart';
import '../bloc/chess_bot.bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/gambit_list_tile.dart';
import '../shared/gambits.dart';
import '../models/gambit.dart';

class SelectGambitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChessBot _chessBot = BlocProvider.of<ChessBot>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("Select a gambit"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: _tabs,
          ),
        ),
        body: StreamBuilder(
            initialData: [MoveRandomPiece()], // need for error prevention
            stream: _chessBot.gambits,
            builder: (context, snapshot) {
              List<Gambit> _currentGambits = snapshot.data;
              return TabBarView(
                // tab pages
                children: List.generate(_listOfLists.length, (outerIndex) {
                  // listOfGambits will be _offensiveGambits, _defensiveGambits etc
                  List<Gambit> listOfGambits = _listOfLists[outerIndex];
                  return ListView(
                    // gambit tiles
                    children: List.generate(listOfGambits.length, (innerIndex) {
                      Gambit _gambit = listOfGambits[innerIndex];
                      bool shouldBeDisabled =
                          _currentGambits.contains(_gambit) ? true : false;
                      return GestureDetector(
                        onTap: shouldBeDisabled
                            ? null
                            : () => Navigator.pop(context, _gambit),
                        child: GambitListTile(
                          gambit: _gambit,
                          disabled: shouldBeDisabled,
                        ),
                      );
                    }),
                  );
                }),
              );
            }),
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

  static final List<Gambit> _offensiveGambits = [
    CaptureQueen(),
    CaptureRook(),
    CaptureBishop(),
    CaptureKnight(),
    CapturePawn(),
    CaptureRandomPiece(),
    CheckOpponent(),
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

  static final List<List<Gambit>> _listOfLists = [
    _offensiveGambits,
    _defensiveGambits,
    _promotionGambits,
    _movementGambits,
  ];
}
