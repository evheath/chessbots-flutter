import 'dart:async';

import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:chessbotsmobile/shared/enemy_not_ready.button.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
// import 'package:chessbotsmobile/shared/not_ready.button.dart';
import 'package:chessbotsmobile/shared/opponent_list_tile.dart';
import 'package:chessbotsmobile/shared/player_not_ready.button.dart';
import 'package:chessbotsmobile/shared/ready.button.dart';
import 'package:chessbotsmobile/shared/waiting.button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:rxdart/rxdart.dart';

class LobbyHostPage extends StatefulWidget {
  final DocumentReference lobbyRef;

  LobbyHostPage(this.lobbyRef);
  @override
  LobbyHostPageState createState() {
    return LobbyHostPageState();
  }
}

class LobbyHostPageState extends State<LobbyHostPage> {
  ChessBot ourBot;
  ChessBot opponentBot;
  // ValueObservable<LobbyDoc> lobbyDoc$;
  Stream<LobbyDoc> lobbyDoc$;

  LobbyHostPageState() {
    // lobbyDoc$ = Observable(widget.lobbyRef
    //     .snapshots()
    //     .map((snap) => LobbyDoc.fromFirestore(snap.data))).shareValue();

    // lobbyDoc$.first.then((lobby) {
    //   marshalChessBot(lobby.hostBot).first.then((bot) {
    //     ourBot = bot;
    //   });
    // });
  }

  @override
  void initState() {
    lobbyDoc$ = widget.lobbyRef
        .snapshots()
        .map((snap) => LobbyDoc.fromFirestore(snap.data));

    lobbyDoc$.first.then((lobbyDoc) {
      marshalChessBot(lobbyDoc.hostBot).first.then((bot) => ourBot = bot);
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
          // if (_lobbyDoc.challengerBot != null) {
          //   marshalChessBot(_lobbyDoc.challengerBot)
          //       .first
          //       .then((bot) => opponentBot = bot);
          // }
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
                  OpponentListTile(ourBot ?? ChessBot(name: "Loading")),
                  _lobbyDoc.challengerBot == null
                      ? WaitingButton()
                      : _lobbyDoc.hostReady
                          ? ReadyButton()
                          : PlayerNotReadyButton(widget.lobbyRef),
                ],
              ),
            ),
            appBar: AppBar(
              //TODO going back deletes lobby since we are host
              // leading: Builder(builder: (context) {
              //   return IconButton(
              //     icon: const Icon(FontAwesomeIcons.dice),
              //     onPressed: () => Scaffold.of(context).openDrawer(),
              //   );
              // }),
              actions: <Widget>[NerdPointActionDisplay()],
              backgroundColor: Colors.amber,
              title: Text("Lobby"),
              centerTitle: true,
            ),
          );
        });
  } // Build
}
