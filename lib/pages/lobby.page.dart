import 'package:chessbotsmobile/bloc/lobby.bloc.dart';
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

class LobbyPage extends StatelessWidget {
  final DocumentReference lobbyRef;

  LobbyPage(this.lobbyRef);

  @override
  Widget build(BuildContext context) {
    LobbyBloc _lobbyBloc = LobbyBloc(lobbyRef);
    return StreamBuilder<LobbyDoc>(
        stream: _lobbyBloc.lobby$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          LobbyDoc _lobbyDoc = snapshot.data;
          return StreamBuilder<bool>(
              stream: _lobbyBloc.playerIsHost$,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                bool playerIsHost = snapshot.data;

                return Scaffold(
                  body: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Top ready/waiting status indicator (for opponent)
                        StreamBuilder<ChessBot>(
                          stream: _lobbyBloc.challengerBot$,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return WaitingButton();
                            } else if (playerIsHost &&
                                _lobbyDoc.challengerReady) {
                              return ReadyButton();
                            } else if (!playerIsHost && _lobbyDoc.hostReady) {
                              return ReadyButton();
                            } else {
                              return EnemyNotReadyButton();
                            }
                          },
                        ),
                        // ListTile containing opponent chess bot
                        playerIsHost
                            ? StreamBuilder<ChessBot>(
                                stream: _lobbyBloc.challengerBot$,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    // don't show anything if we are host and there is no challenger
                                    return Container();
                                  } else {
                                    ChessBot _challengerBot = snapshot.data;
                                    return OpponentListTile(_challengerBot);
                                  }
                                },
                              )
                            : StreamBuilder<ChessBot>(
                                stream: _lobbyBloc.hostBot$,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    // show loading since there should be a host, probably just not done marshalling
                                    return ListTile(
                                        title: CircularProgressIndicator());
                                  } else {
                                    ChessBot _hostBot = snapshot.data;
                                    return OpponentListTile(_hostBot);
                                  }
                                },
                              ),
                        // ListTile containing player's chess bot
                        playerIsHost
                            ? StreamBuilder<ChessBot>(
                                stream: _lobbyBloc.hostBot$,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    // show loading since there should be a host, probably just not done marshalling
                                    return ListTile(
                                        title: CircularProgressIndicator());
                                  } else {
                                    ChessBot _hostBot = snapshot.data;
                                    return OpponentListTile(_hostBot);
                                  }
                                },
                              )
                            : StreamBuilder<ChessBot>(
                                stream: _lobbyBloc.challengerBot$,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    // show loading since we are the challenger, probably just not done marshalling
                                    return ListTile(
                                        title: CircularProgressIndicator());
                                  } else {
                                    ChessBot _challengerBot = snapshot.data;
                                    return OpponentListTile(_challengerBot);
                                  }
                                },
                              ),
                        // Bottom ready/waiting status indicator (for player)
                        // WaitingButton(),
                        StreamBuilder<ChessBot>(
                          stream: _lobbyBloc.challengerBot$,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return WaitingButton();
                            } else if (playerIsHost && _lobbyDoc.hostReady) {
                              return ReadyButton(
                                  onPressed: () =>
                                      _lobbyBloc.lobbyEvent.add(ToggleReady()));
                            } else if (!playerIsHost &&
                                _lobbyDoc.challengerReady) {
                              return ReadyButton(
                                  onPressed: () =>
                                      _lobbyBloc.lobbyEvent.add(ToggleReady()));
                            } else {
                              return PlayerNotReadyButton(
                                  onPressed: () =>
                                      _lobbyBloc.lobbyEvent.add(ToggleReady()));
                            }
                          },
                        ),
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
        });
  } // Build
}
