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
import 'dart:math';

class MatchPage extends StatefulWidget {
  final ChessBot playerBot;
  final ChessBot opponentBot;

  MatchPage({@required this.playerBot, @required this.opponentBot});
  @override
  MatchPageState createState() {
    return MatchPageState();
  }
}

class MatchPageState extends State<MatchPage> {
  final bool playerIsWhite = Random().nextInt(2) == 1;
  GameControllerBloc _matchBoardController = GameControllerBloc();

  MatchPageState() {
    // listening to game status
    _matchBoardController.status.listen((status) {
      if (status == GameStatus.in_checkmate) {
        // if game is over and it is that player's turn, they have lost
        chess.Color playersColor =
            playerIsWhite ? chess.Color.WHITE : chess.Color.BLACK;
        _matchBoardController.turn == playersColor
            ? _handleDefeat()
            : _handleVictory();
      } else if (status == GameStatus.in_draw) {
        _handleDraw();
      } else {}
    });

    _playMatch();
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
            Status(widget.opponentBot),
            ChessBoard(
              size: MediaQuery.of(context).size.width - 20,
              enableUserMoves: false,
              chessBoardController: _matchBoardController,
              onMove: (move) {},
              onDraw: () {},
              whiteSideTowardsUser: playerIsWhite,
            ),
            Status(widget.playerBot),
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
    );
  } // Build

  void _playMatch() async {
    chess.Chess game = _matchBoardController.game;

    while (!_matchBoardController.gameOver) {
      await Future.delayed(Duration(seconds: 1));
      String move;
      if (_matchBoardController.turn == chess.Color.WHITE) {
        move = playerIsWhite
            ? widget.playerBot.waterfallGambits(game)
            : widget.opponentBot.waterfallGambits(game);
      } else {
        move = !playerIsWhite
            ? widget.playerBot.waterfallGambits(game)
            : widget.opponentBot.waterfallGambits(game);
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
        int reward = widget.opponentBot.bounty;
        _firestoreBloc.userEvent.add(AwardNerdPointsEvent(reward));
        String plural = reward > 1 ? 's' : '';
        return AlertDialog(
          title: Text("You win!"),
          content: Text("Enjoy $reward nerd point$plural"),
          actions: <Widget>[
            _editGambitsButton(),
            _playAgainButton(),
            _closeButton(),
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
            _editGambitsButton(),
            _playAgainButton(),
            _closeButton(),
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
            _editGambitsButton(),
            _playAgainButton(),
            _closeButton(),
          ],
        );
      },
    );
  }

  FlatButton _editGambitsButton() {
    return FlatButton(
      child: Text("Edit gambits"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssemblePage(widget.playerBot.botRef),
          ),
        );
      },
    );
  }

  FlatButton _playAgainButton() {
    return FlatButton(
      child: Text("Again"),
      onPressed: () {
        Navigator.of(context).pop();
        // setState
        _matchBoardController.loadFEN(
            "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");
        //TODO this should repush the route, thus causing the coin flip to occur

        _playMatch();
      },
    );
  }

  FlatButton _closeButton() {
    return FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    _matchBoardController.dispose();
    super.dispose();
  }
}
