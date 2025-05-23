import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/bloc/multiplayer_match.bloc.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:chessbotsmobile/shared/loading_list_tile.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';

class MultiplayerMatchPage extends StatefulWidget {
  final DocumentReference matchRef;

  MultiplayerMatchPage({
    @required this.matchRef,
  });
  @override
  MultiplayerMatchPageState createState() {
    return MultiplayerMatchPageState();
  }
}

class MultiplayerMatchPageState extends State<MultiplayerMatchPage> {
  GameControllerBloc _matchBoardController = GameControllerBloc();
  MultiplayerMatchBloc _multiplayerMatchBloc;

  MultiplayerMatchPageState();

  @override
  void initState() {
    _multiplayerMatchBloc = MultiplayerMatchBloc(widget.matchRef);
    _multiplayerMatchBloc.outcome$.listen((outcome) {
      switch (outcome) {
        case GameOutcome.victory:
          _handleVictory();
          break;
        case GameOutcome.defeat:
          _handleDefeat();
          break;
        case GameOutcome.draw:
          _handleDraw();
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _multiplayerMatchBloc.playerIsWhite$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        bool playerIsWhite = snapshot.data;
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                //opponent tile
                StreamBuilder<ChessBot>(
                  stream: playerIsWhite
                      ? _multiplayerMatchBloc.blackBot$
                      : _multiplayerMatchBloc.whiteBot$,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingListTile();
                    }
                    return Status(snapshot.data, white: !playerIsWhite);
                  },
                ),
                //chessboard
                StreamBuilder<String>(
                    stream: _multiplayerMatchBloc.fen$,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _matchBoardController.loadFEN(snapshot.data);
                      }
                      return ChessBoard(
                        size: MediaQuery.of(context).size.width - 20,
                        enableUserMoves: false,
                        chessBoardController: _matchBoardController,
                        onMove: (move) {},
                        onDraw: () {},
                        whiteSideTowardsUser: playerIsWhite,
                      );
                    }),
                // player tile
                StreamBuilder<ChessBot>(
                  stream: !playerIsWhite
                      ? _multiplayerMatchBloc.blackBot$
                      : _multiplayerMatchBloc.whiteBot$,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingListTile();
                    }
                    return Status(snapshot.data, white: playerIsWhite);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            actions: <Widget>[NerdPointActionDisplay()],
            backgroundColor: Colors.blueGrey,
            title: Text("Multiplayer"),
            centerTitle: true,
          ),
        );
      },
    );
  } // Build

  @override
  void dispose() {
    _matchBoardController.dispose();
    _multiplayerMatchBloc.dispose();
    super.dispose();
  }

  void _handleVictory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int reward = _multiplayerMatchBloc.opponentBot.bounty;
        String plural = reward > 1 ? 's' : '';
        return AlertDialog(
          title: Text("You win!"),
          content: Text("Enjoy $reward nerd point$plural"),
          actions: <Widget>[
            // _editGambitsButton(),
            // _playAgainButton(),
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
        return AlertDialog(
          title: Text("Draw!"),
          content: Text("Have a pity point"),
          actions: <Widget>[
            // _editGambitsButton(),
            // _playAgainButton(),
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
            // _editGambitsButton(),
            // _playAgainButton(),
            _closeButton(),
          ],
        );
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
}
