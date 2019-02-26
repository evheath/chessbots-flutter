import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/status_list_tile.dart';
import '../shared/gambits.dart';

import '../bloc/base.bloc.dart';
import '../bloc/gambits.bloc.dart';
import '../models/gambit.dart';

class MatchPage extends StatefulWidget {
  final GambitsBloc whiteBot;
  final GambitsBloc blackBot;

  MatchPage({@required this.whiteBot, @required this.blackBot});
  @override
  MatchPageState createState() {
    return MatchPageState();
  }
}

class MatchPageState extends State<MatchPage> {
  ChessBoardController _matchBoardController = ChessBoardController();
  Gambit _lastGambitUsed = EmptyGambit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GambitsBloc _gambitsBloc = BlocProvider.of<GambitsBloc>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ChessBoard(
              moveAnyPiece: true,
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: true,
              chessBoardController: _matchBoardController,
              onMove: (move) {},
              onCheckMate: (derp) {},
              onDraw: () {},
            ),
            StatusListTile(gambit: _lastGambitUsed),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(FontAwesomeIcons.dice),
            SizedBox(width: 10.0),
            Text("Match"),
          ],
        ),
      ),
      drawer: LeftDrawer(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              if (!_matchBoardController.game.in_checkmate) {
                setState(() {
                  _lastGambitUsed =
                      _gambitsBloc.gambitToBeUsed(_matchBoardController.game);
                });
                var move = _lastGambitUsed.findMove(_matchBoardController.game);
                _matchBoardController.labMove(move);
              }
            },
            tooltip: 'Test gambits',
            child: Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: () {
              _matchBoardController.resetBoard();
              setState(() {});
            },
            tooltip: 'Reset',
            child: Icon(Icons.repeat),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  } // Build

}
