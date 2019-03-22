import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';

class MultiplayerMatchBloc extends BlocBase {
  /// the document reference this bloc revolves around
  final DocumentReference matchRef;

  // state
  bool _playerIsWhite;
  ChessBot _whiteBot;
  ChessBot _blackBot;

  /// external-in/internal-out controller

  /// external-in (alias)

  /// internal-in/external-out controller
  StreamController<bool> _playerIsWhiteController = BehaviorSubject<bool>();
  StreamController<ChessBot> _whiteBotController = BehaviorSubject<ChessBot>();
  StreamController<ChessBot> _blackBotController = BehaviorSubject<ChessBot>();

  /// internal-in (alias)
  StreamSink<bool> get _internalInPlayerIsWhite =>
      _playerIsWhiteController.sink;
  StreamSink<ChessBot> get _internalInWhiteBot => _whiteBotController.sink;
  StreamSink<ChessBot> get _internalInBlackBot => _blackBotController.sink;

  /// external-out (alias)
  Stream<bool> get playerIsWhite$ => _playerIsWhiteController.stream;
  Stream<ChessBot> get whiteBot$ => _whiteBotController.stream;
  Stream<ChessBot> get blackBot$ => _blackBotController.stream;

  // constructor
  MultiplayerMatchBloc(this.matchRef) {
    // things that only need to happen once
    matchRef.get().then((snap) {
      Map<String, dynamic> _snapData = snap.data;
      // determine if player is white
      FirestoreBloc().user.first.then((playerAsFbUser) {
        _playerIsWhite =
            playerAsFbUser.uid == _snapData["whiteUID"] ? true : false;
        _internalInPlayerIsWhite.add(_playerIsWhite);
      });

      // get white bot
      marshalChessBot(_snapData["whiteBot"]).first.then((bot) {
        _whiteBot = bot;
        _internalInWhiteBot.add(_whiteBot);
      });
      // get black bot
      marshalChessBot(_snapData["blackBot"]).first.then((bot) {
        _blackBot = bot;
        _internalInBlackBot.add(_blackBot);
      });
    });

    // things that need to happen on every update
    // matchRef.snapshots().map((snap) => snap.data).listen((_snapData) {});
  }
  void dispose() {
    _playerIsWhiteController.close();
    _whiteBotController.close();
    _blackBotController.close();
  }
}
