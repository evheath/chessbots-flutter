import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/pages/assemble.page.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:chessbotsmobile/shared/left.drawer.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/status.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:chess/chess.dart' as chess;
import 'package:chessbotsmobile/models/chess_bot.dart';

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
  GameControllerBloc _matchBoardController = GameControllerBloc();
  // bool _gameStarted = false;

  MatchPageState() {
    // listening to game status
    _matchBoardController.status.listen((status) {
      if (status == GameStatus.in_checkmate) {
        // if game is over and it is white's turn, that means black won
        _matchBoardController.turn == chess.Color.WHITE
            ? _handleDefeat()
            : _handleVictory();
      } else if (status == GameStatus.in_draw) {
        _handleDraw();
      } else {}
    });

    _beginMatch();
  }

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
              onDraw: () {},
            ),
            Status(widget.whiteBot),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(FontAwesomeIcons.dice),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: <Widget>[NerdPointActionDisplay()],
        backgroundColor: Colors.blueGrey,
        title: Text("Match"),
        centerTitle: true,
      ),
      drawer: LeftDrawer(),
      // floatingActionButton: _gameStarted
      //     ? Container()
      //     : FloatingActionButton(
      //         onPressed: () {
      //           _beginMatch();
      //         },
      //         tooltip: 'Begin',
      //         child: Icon(Icons.play_arrow),
      //       ),
    );
  } // Build

  void _beginMatch() async {
    // setState(() {
    //   _gameStarted = true;
    // });
    chess.Chess game = _matchBoardController.game;

    while (!_matchBoardController.gameOver) {
      await Future.delayed(Duration(seconds: 1));
      String move;
      if (_matchBoardController.turn == chess.Color.WHITE) {
        //white's move
        move = widget.whiteBot.waterfallGambits(game);
      } else {
        // black's move
        move = widget.blackBot.waterfallGambits(game);
      }
      _matchBoardController.makeMove(move);
    }
  }

  void _handleVictory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final FirestoreBloc _firestoreBloc =
            BlocProvider.of<FirestoreBloc>(context);
        int reward = widget.blackBot.bounty;
        _firestoreBloc.userEvent.add(AwardNerdPointsEvent(reward));
        String plural = reward > 1 ? 's' : '';
        return AlertDialog(
          title: Text("You win!"),
          content: Text("Enjoy $reward nerd point$plural"),
          actions: <Widget>[
            FlatButton(
              child: Text("Edit gambits"),
              onPressed: () {
                // Navigator.of(context).pop(); // close dialog
                // setState
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //TODO eventually we need to know if the player was black
                    builder: (context) => AssemblePage(widget.whiteBot.botRef),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("Again"),
              onPressed: () {
                Navigator.of(context).pop();
                // setState
                _matchBoardController.loadFEN(
                    "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
                _beginMatch();
              },
            ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDefeat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You lose!"),
          content: Text("You get nothing. Good day sir."),
          actions: [
            FlatButton(
              child: Text("Edit gambits"),
              onPressed: () {
                // Navigator.of(context).pop(); // close dialog
                // setState
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //TODO eventually we need to know if the player was black
                    builder: (context) => AssemblePage(widget.whiteBot.botRef),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("Again"),
              onPressed: () {
                Navigator.of(context).pop();
                // setState
                _matchBoardController.loadFEN(
                    "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
                _beginMatch();
              },
            ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDraw() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final FirestoreBloc _firestoreBloc =
            BlocProvider.of<FirestoreBloc>(context);
        _firestoreBloc.userEvent.add(AwardNerdPointsEvent(1));
        return AlertDialog(
          title: Text("Draw!"),
          content: Text("Have a pity point"),
          actions: <Widget>[
            FlatButton(
              child: Text("Edit gambits"),
              onPressed: () {
                // Navigator.of(context).pop(); // close dialog
                // setState
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //TODO eventually we need to know if the player was black
                    builder: (context) => AssemblePage(widget.whiteBot.botRef),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text("Again"),
              onPressed: () {
                Navigator.of(context).pop();
                // setState
                _matchBoardController.loadFEN(
                    "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
                _beginMatch();
              },
            ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _matchBoardController.dispose();
    super.dispose();
  }
}
