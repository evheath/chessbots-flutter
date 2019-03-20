import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:chessbotsmobile/shared/enemy_not_ready.button.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/opponent_list_tile.dart';
import 'package:chessbotsmobile/shared/player_not_ready.button.dart';
import 'package:chessbotsmobile/shared/ready.button.dart';
import 'package:chessbotsmobile/shared/waiting.button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';

class LobbyPage extends StatefulWidget {
  final DocumentReference lobbyRef;

  LobbyPage(this.lobbyRef);
  @override
  LobbyPageState createState() {
    return LobbyPageState();
  }
}

class LobbyPageState extends State<LobbyPage> {
  ChessBot hostBot;
  ChessBot opponentBot;
  Stream<LobbyDoc> lobbyDoc$;
  bool playerIsHost = false;

  LobbyPageState();

  @override
  void initState() {
    // marshalling a realtime document
    lobbyDoc$ =
        widget.lobbyRef.snapshots().map((snap) => LobbyDoc.fromSnapshot(snap))
          ..first.then((lobbyDoc) {
            // things that only need to be done once
            // (not every time the lobby doc changes)
            FirestoreBloc().user.first.then((playerAsFbUser) {
              playerIsHost = playerAsFbUser?.uid == lobbyDoc.uid ? true : false;
            });
            marshalChessBot(lobbyDoc.hostBot)
                .first
                .then((bot) => hostBot = bot);
          });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LobbyDoc>(
        stream: lobbyDoc$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          LobbyDoc _lobbyDoc = snapshot.data;
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _lobbyDoc.challengerBot == null
                      ? WaitingButton()
                      : EnemyNotReadyButton(),
                  _lobbyDoc.challengerBot == null
                      ? Container()
                      : StreamBuilder<ChessBot>(
                          stream: marshalChessBot(_lobbyDoc.challengerBot),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return OpponentListTile(
                                  ChessBot(name: "Loading"));
                            }
                            ChessBot _opponentBot = snapshot.data;
                            return OpponentListTile(_opponentBot);
                          }),
                  OpponentListTile(hostBot ?? ChessBot(name: "Loading")),
                  _lobbyDoc.challengerBot == null
                      ? WaitingButton()
                      : _lobbyDoc.hostReady
                          ? ReadyButton()
                          : PlayerNotReadyButton(widget.lobbyRef),
                ],
              ),
            ),
            appBar: AppBar(
              //TODO going back should delete lobby if you are host
              // or scrub yourself from the lobby if you are the challenger
              actions: <Widget>[NerdPointActionDisplay()],
              backgroundColor: Colors.amber,
              title: Text("Lobby"),
              centerTitle: true,
            ),
          );
        });
  } // Build
}
