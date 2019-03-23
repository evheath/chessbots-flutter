import 'dart:async';
import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/bloc/multiplayer_match.bloc.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
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
                      //TODO is there a better way to put in indicator in a tile/status?
                      return CircularProgressIndicator();
                    }
                    return Status(snapshot.data);
                  },
                ),
                //chessboard
                StreamBuilder<String>(
                    stream: _multiplayerMatchBloc.fen$,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String _currentFen = snapshot.data;
                        _matchBoardController.loadFEN(_currentFen);
                      }
                      _handleMove();
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
                      //TODO is there a better way to put in indicator in a tile/status?
                      return CircularProgressIndicator();
                    }
                    return Status(snapshot.data);
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

  Future<void> _handleMove() async {
    if (_matchBoardController.gameOver) {
      _multiplayerMatchBloc.event.add(GameOver());
    } else {
      bool playerIsWhite = await _multiplayerMatchBloc.playerIsWhite$.first;
      chess.Color _onusToMove = _matchBoardController.turn;
      chess.Color _playerColor =
          playerIsWhite ? chess.Color.WHITE : chess.Color.BLACK;
      if (_onusToMove == _playerColor) {
        ChessBot _bot = playerIsWhite
            ? await _multiplayerMatchBloc.whiteBot$.first
            : await _multiplayerMatchBloc.blackBot$.first;
        await Future.delayed(Duration(seconds: 1));
        String move = _bot.waterfallGambits(_matchBoardController.game);
        _matchBoardController.makeMove(move);
        _multiplayerMatchBloc.event.add(MoveMade(_matchBoardController.game));
      }
    }
  }

  @override
  void dispose() {
    _matchBoardController.dispose();
    super.dispose();
  }
}
