import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/status.dart';
import 'package:chess/chess.dart' as chess;
import '../bloc/chess_bot.bloc.dart';
import '../bloc/game_controller.bloc.dart';

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
  bool _gameStarted = false;

  MatchPageState() {
    //TODO can this be moved to _beginMatch()?
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
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreBloc _firestoreBloc =
        BlocProvider.of<FirestoreBloc>(context);
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
        actions: <Widget>[NerdPointActionDisplay()],
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
        _firestoreBloc.userEvent.add(AwardNerdPointsEvent(10));
        return AlertDialog(
          title: Text("You win!"),
          content: Text("Well played! Enjoy 10 nerd points"),
          actions: <Widget>[
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
          content: Text("Better luck next time. Have a pity point"),
          actions: <Widget>[
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
