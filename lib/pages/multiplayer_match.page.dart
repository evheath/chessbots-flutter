// import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
// import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/bloc/multiplayer_match.bloc.dart';
// import 'package:chessbotsmobile/pages/assemble.page.dart';
import 'package:chessbotsmobile/shared/chess_board.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:chess/chess.dart' as chess;
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

  MultiplayerMatchPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MultiplayerMatchBloc _multiplayerMatchBloc =
        MultiplayerMatchBloc(widget.matchRef);
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
            child: Column(
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
                ChessBoard(
                  size: MediaQuery.of(context).size.width - 20,
                  enableUserMoves: false,
                  chessBoardController: _matchBoardController,
                  onMove: (move) {},
                  onDraw: () {},
                  whiteSideTowardsUser: playerIsWhite,
                ),
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

  @override
  void dispose() {
    _matchBoardController.dispose();
    super.dispose();
  }
}
