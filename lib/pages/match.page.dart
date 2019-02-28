import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
// import '../shared/status_list_tile.dart';
import '../shared/status.dart';
// import '../shared/gambits.dart';
import 'package:chess/chess.dart' as chess;
// import '../bloc/base.bloc.dart';
import '../bloc/chess_bot.bloc.dart';
// import '../models/gambit.dart';

//TODO: navigating away from a game in progress needs better tear down
// not sure where this needs to happen
class MatchPage extends StatefulWidget {
  final ChessBot whiteBot;
  final ChessBot blackBot;

  MatchPage({@required this.whiteBot, @required this.blackBot});
  @override
  MatchPageState createState() {
    return MatchPageState();
  }
}

class MatchPageState extends State<MatchPage> {
  ChessBoardController _matchBoardController = ChessBoardController();
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Status(widget.blackBot),
            ChessBoard(
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: false,
              chessBoardController: _matchBoardController,
              onMove: (move) {},
              onCheckMate: (derp) {
                //TODO onCheckMate does not fire
                print("onCheckMate uwu");
              },
              onDraw: () {
                print("onDraw uwu");
              },
            ),
            Status(widget.whiteBot),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            Icon(FontAwesomeIcons.dice),
            SizedBox(width: 10.0),
            Text("Match"),
          ],
        ),
      ),
      drawer: LeftDrawer(),
      floatingActionButton: _gameStarted
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                _beginMatch();
              },
              tooltip: 'Begin',
              child: Icon(Icons.play_arrow),
            ),
    );
  } // Build

  void _beginMatch() async {
    setState(() {
      _gameStarted = true;
    });
    chess.Chess game = _matchBoardController.game;
    while (!_matchBoardController.game.in_checkmate) {
      await Future.delayed(Duration(seconds: 1));
      String move;
      if (_matchBoardController.game.turn == chess.Color.WHITE) {
        //white's move
        move = widget.whiteBot.waterfallGambits(game);
      } else {
        // black's move
        move = widget.blackBot.waterfallGambits(game);
      }
      _matchBoardController.makeMove(move);
    }
  }
}
