import 'dart:async';
import 'dart:math';
import 'package:chessbotsmobile/bloc/base.bloc.dart';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/bloc/lobby.bloc.dart';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:chessbotsmobile/pages/multiplayer_match.page.dart';
import 'package:chessbotsmobile/shared/enemy_not_ready.button.dart';
import 'package:chessbotsmobile/shared/nerd_point_action_display.dart';
import 'package:chessbotsmobile/shared/opponent_list_tile.dart';
import 'package:chessbotsmobile/shared/player_not_ready.button.dart';
import 'package:chessbotsmobile/shared/ready.button.dart';
import 'package:chessbotsmobile/shared/waiting.button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LobbyPage extends StatelessWidget {
  final DocumentReference lobbyRef;

  LobbyPage(this.lobbyRef);

  @override
  Widget build(BuildContext context) {
    LobbyBloc _lobbyBloc = LobbyBloc(lobbyRef);
    return BlocProvider<LobbyBloc>(
      bloc: _lobbyBloc,
      child: StreamBuilder<LobbyDoc>(
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
              // checking if game is ready to start
              if (_lobbyDoc.challengerReady && _lobbyDoc.hostReady) {
                jumpIntoMatch(context, playerIsHost);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              //otherwise display the lobby page
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
                  leading: IconButton(
                    icon: Icon(FontAwesomeIcons.doorOpen),
                    tooltip: "Leave lobby",
                    onPressed: () {
                      playerIsHost
                          ? _lobbyBloc.lobbyEvent.add(DeleteLobby())
                          : _lobbyBloc.lobbyEvent.add(RemoveChallenger());
                      Navigator.pop(context);
                    },
                  ),
                  actions: <Widget>[NerdPointActionDisplay()],
                  backgroundColor: Colors.amber,
                  title: Text("Lobby"),
                  centerTitle: true,
                ),
              );
            },
          );
        },
      ),
    );
  } // Build

  Future<void> jumpIntoMatch(BuildContext context, bool playerIsHost) async {
    LobbyBloc _lobbyBloc = BlocProvider.of<LobbyBloc>(context);
    LobbyDoc _lobbyDoc = await _lobbyBloc.lobby$.first;
    ChessBot _challengerBot = await _lobbyBloc.challengerBot$.first;
    ChessBot _hostBot = await _lobbyBloc.hostBot$.first;

    if (playerIsHost) {
      // creating the match document is the host's responsibility

      // quick sanity-check to make sure there hasn't already been a match created
      if (_lobbyDoc.matchRef != null) {
        return;
      }

      DocumentReference matchRef =
          Firestore.instance.collection('matches').document();
      final bool hostIsWhite = Random().nextInt(2) == 1;

      await matchRef.setData({
        "whiteUID": hostIsWhite ? _hostBot.uid : _challengerBot.uid,
        "blackUID": !hostIsWhite ? _hostBot.uid : _challengerBot.uid,
        "whiteBot": hostIsWhite ? _hostBot.botRef : _challengerBot.botRef,
        "blackBot": !hostIsWhite ? _hostBot.botRef : _challengerBot.botRef,
        "fen": 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
      });
      await lobbyRef.updateData({
        "matchRef": matchRef,
      });
      FirestoreBloc().userEvent.add(JoinedMatch(matchRef));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiplayerMatchPage(
                matchRef: matchRef,
              ),
        ),
      );
    } else {
      // player is the challenger and the lobby is ready
      // however the match may not yet be created
      if (_lobbyDoc.matchRef != null) {
        FirestoreBloc().userEvent.add(JoinedMatch(_lobbyDoc.matchRef));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MultiplayerMatchPage(
                  matchRef: _lobbyDoc.matchRef,
                ),
          ),
        );
      }
    }
  }
}
