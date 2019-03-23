import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/models/match.doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';
import 'package:chess/chess.dart' as chess;

class MultiplayerMatchBloc extends BlocBase {
  /// the document reference this bloc revolves around
  final DocumentReference matchRef;

  // state
  bool _playerIsWhite;
  ChessBot _whiteBot;
  ChessBot _blackBot;
  String _fen;

  /// external-in/internal-out controller
  ///
  StreamController<MultiplayerMatchEvent> _eventController = StreamController();

  /// external-in (alias)
  StreamSink<MultiplayerMatchEvent> get event => _eventController.sink;

  /// internal-in/external-out controller
  StreamController<bool> _playerIsWhiteController = BehaviorSubject<bool>();
  StreamController<ChessBot> _whiteBotController = BehaviorSubject<ChessBot>();
  StreamController<ChessBot> _blackBotController = BehaviorSubject<ChessBot>();
  StreamController<String> _fenController = BehaviorSubject<String>();

  /// internal-in (alias)
  StreamSink<bool> get _internalInPlayerIsWhite =>
      _playerIsWhiteController.sink;
  StreamSink<ChessBot> get _internalInWhiteBot => _whiteBotController.sink;
  StreamSink<ChessBot> get _internalInBlackBot => _blackBotController.sink;
  StreamSink<String> get _internalInFen => _fenController.sink;

  /// external-out (alias)
  Stream<bool> get playerIsWhite$ => _playerIsWhiteController.stream;
  Stream<ChessBot> get whiteBot$ => _whiteBotController.stream;
  Stream<ChessBot> get blackBot$ => _blackBotController.stream;
  Stream<String> get fen$ => _fenController.stream;

  // constructor
  MultiplayerMatchBloc(this.matchRef) {
    _eventController.stream.listen(_handleEvent);
    // things that only need to happen once
    matchRef.get().then((snap) {
      MatchDoc _matchDoc = MatchDoc.fromSnapshot(snap);
      // determine if player is white
      FirestoreBloc().user.first.then((playerAsFbUser) {
        _playerIsWhite =
            playerAsFbUser.uid == _matchDoc.whiteUID ? true : false;
        _internalInPlayerIsWhite.add(_playerIsWhite);
      });

      // get white bot
      marshalChessBot(_matchDoc.whiteBot).first.then((bot) {
        _whiteBot = bot;
        _internalInWhiteBot.add(_whiteBot);
      });
      // get black bot
      marshalChessBot(_matchDoc.blackBot).first.then((bot) {
        _blackBot = bot;
        _internalInBlackBot.add(_blackBot);
      });
    });

    // things that need to happen on every update
    matchRef
        .snapshots()
        .map((snap) => MatchDoc.fromSnapshot(snap))
        .listen((_matchDoc) {
      _fen = _matchDoc.fen;
      _internalInFen.add(_fen);
    });
  }
  void _handleEvent(MultiplayerMatchEvent event) async {
    if (event is MoveMade) {
      //TODO last used gambit?
      String _newFen = event.game.fen;
      matchRef.updateData({
        "fen": _newFen,
      });
    } else if (event is GameOver) {
      //TODO handle game over logic?
      FirestoreBloc().userEvent.add(FinishedMatch());
    }
  }

  void dispose() {
    _playerIsWhiteController.close();
    _whiteBotController.close();
    _blackBotController.close();
    _fenController.close();
    _eventController.close();
  }
}

abstract class MultiplayerMatchEvent {}

class MoveMade extends MultiplayerMatchEvent {
  chess.Chess game;
  MoveMade(this.game);
}

class GameOver extends MultiplayerMatchEvent {}
