import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import '../shared/chess_board.dart';
import '../shared/left.drawer.dart';
import '../shared/status.dart';
import 'package:chess/chess.dart' as chess;
import '../bloc/chess_bot.bloc.dart';

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

  MatchPageState() {
    // listening to game status
    _matchBoardController.status.listen((status) {
      if (status == GameStatus.in_checkmate) {
        // if game is over and it is white's turn, that means black won
        _matchBoardController.game.turn == chess.Color.WHITE
            ? _handleDefeat()
            : _handleVictory();
        //TODO eventually we should never touch the controllers game
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
    while (!_matchBoardController.game.in_checkmate &&
        !_matchBoardController.game.in_draw) {
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

  void _handleVictory() {
    // TODO: nerd points get rewarded here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("You win!"),
          content: new Text("Well played! Enjoy some nerd points"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            // new FlatButton(
            //   child: new Text("Play Again"),
            //   onPressed: () {},
            // ),
            new FlatButton(
              child: new Text("Amazing"),
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
          title: new Text("You lose!"),
          content: new Text("You get nothing. Good day sir."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            // new FlatButton(
            //   child: new Text("Play Again"),
            //   onPressed: () {},
            // ),
            new FlatButton(
              child: new Text("Acknowledge defeat"),
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
        return AlertDialog(
          title: new Text("Draw game!"),
          content: new Text("Wow what a great use of everybody's time."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            // new FlatButton(
            //   child: new Text("Play Again"),
            //   onPressed: () {},
            // ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
