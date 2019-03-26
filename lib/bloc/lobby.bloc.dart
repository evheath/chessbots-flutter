import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/models/lobby.doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';

class LobbyBloc extends BlocBase {
  /// the document reference this bloc revolves around
  final DocumentReference lobbyRef;

  // state
  LobbyDoc _lobbyDoc;
  bool _playerIsHost;
  ChessBot _hostBot;
  ChessBot _challengerBot;

  /// external-in/internal-out controller
  StreamController<LobbyEvent> _lobbyEventController = StreamController();

  /// external-in (alias)
  StreamSink<LobbyEvent> get lobbyEvent => _lobbyEventController.sink;

  /// internal-in/external-out controller
  StreamController<LobbyDoc> _lobbyDocController = BehaviorSubject<LobbyDoc>();
  StreamController<bool> _playerIsHostController = BehaviorSubject<bool>();
  StreamController<ChessBot> _hostBotController = BehaviorSubject<ChessBot>();
  StreamController<ChessBot> _challengerBotController =
      BehaviorSubject<ChessBot>();

  /// internal-in (alias)
  StreamSink<LobbyDoc> get _internalInLobbyDoc => _lobbyDocController.sink;
  StreamSink<bool> get _internalInPlayerIsHost => _playerIsHostController.sink;
  StreamSink<ChessBot> get _internalInHostBot => _hostBotController.sink;
  StreamSink<ChessBot> get _internalInChallengerBot =>
      _challengerBotController.sink;

  /// external-out (alias)
  Stream<LobbyDoc> get lobby$ => _lobbyDocController.stream;
  Stream<bool> get playerIsHost$ => _playerIsHostController.stream;
  Stream<ChessBot> get hostBot$ => _hostBotController.stream;
  Stream<ChessBot> get challengerBot$ => _challengerBotController.stream;

  // constructor
  LobbyBloc(this.lobbyRef) {
    _lobbyEventController.stream.listen(_handleLobbyEvent);

    lobbyRef
        .snapshots()
        .map((snap) => LobbyDoc.fromSnapshot(snap))
        .listen((snap) {
      // add lobbyDoc to lobby$
      _lobbyDoc = snap;
      _internalInLobbyDoc.add(_lobbyDoc);

      // determine if player is host
      FirestoreBloc().user$.first.then((playerAsFbUser) {
        _playerIsHost = playerAsFbUser?.uid == _lobbyDoc.uid ? true : false;
        _internalInPlayerIsHost.add(_playerIsHost);
      });

      // get the _hostBot (should only need to happen once)
      if (_hostBot == null) {
        marshalChessBot(_lobbyDoc.hostBot).first.then((bot) {
          _hostBot = bot;
          _internalInHostBot.add(_hostBot);
        });
      }

      // get the challenger bot (if need be)
      if (_challengerBot == null && _lobbyDoc.challengerBot != null) {
        marshalChessBot(_lobbyDoc.challengerBot).first.then((bot) {
          _challengerBot = bot;
          _internalInChallengerBot.add(_challengerBot);
        });
      }

      // remove the challenger bot (if challenger left)
      if (_challengerBot != null && _lobbyDoc.challengerBot == null) {
        _challengerBot = null;
        _internalInChallengerBot.add(_challengerBot);
      }
    });
  }
  void _handleLobbyEvent(LobbyEvent event) async {
    switch (event.runtimeType) {
      case ToggleReady:
        if (_playerIsHost == null) {
          // the lobby dock has not loaded, so do nothing
          return;
        } else {
          String _field = _playerIsHost ? "hostReady" : "challengerReady";
          bool _currentStatus =
              _playerIsHost ? _lobbyDoc.hostReady : _lobbyDoc.challengerReady;
          await lobbyRef.updateData({_field: !_currentStatus});
        }
        break;
      case RemoveChallenger:
        await lobbyRef.updateData({
          "challengerBot": null,
          "challengerReady": false,
          "hostReady": false,
        });
        break;
      case DeleteLobby:
        await lobbyRef.delete();
        break;
      default:
    }
  }

  void dispose() {
    _lobbyEventController.close();
    _lobbyDocController.close();
    _playerIsHostController.close();
    _hostBotController.close();
    _challengerBotController.close();
  }
}

abstract class LobbyEvent {}

class ToggleReady extends LobbyEvent {}

class RemoveChallenger extends LobbyEvent {}

class DeleteLobby extends LobbyEvent {}
