import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/models/chess_bot.dart';
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
  String _pgn;

  // dependency
  GameControllerBloc _gameController = GameControllerBloc();

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
  StreamController<String> _pgnController = BehaviorSubject<String>();

  /// internal-in (alias)
  StreamSink<bool> get _internalInPlayerIsWhite =>
      _playerIsWhiteController.sink;
  StreamSink<ChessBot> get _internalInWhiteBot => _whiteBotController.sink;
  StreamSink<ChessBot> get _internalInBlackBot => _blackBotController.sink;
  StreamSink<String> get _internalInFen => _fenController.sink;
  StreamSink<String> get _internalInPgn => _pgnController.sink;

  /// external-out (alias)
  Stream<bool> get playerIsWhite$ => _playerIsWhiteController.stream;
  Stream<ChessBot> get whiteBot$ => _whiteBotController.stream;
  Stream<ChessBot> get blackBot$ => _blackBotController.stream;
  Stream<String> get fen$ => _fenController.stream;
  Stream<String> get pgn$ => _pgnController.stream;

  // constructor
  MultiplayerMatchBloc(this.matchRef) {
    _eventController.stream.listen(_handleEvent);
    // things that only need to happen once
    matchRef.get().then((snap) {
      // determine if player is white
      FirestoreBloc().user.first.then((playerAsFbUser) {
        _playerIsWhite =
            playerAsFbUser.uid == snap.data["whiteUID"] ? true : false;
        _internalInPlayerIsWhite.add(_playerIsWhite);
      });

      // get white bot
      marshalChessBot(snap.data["whiteBot"]).first.then((bot) {
        _whiteBot = bot;
        _internalInWhiteBot.add(_whiteBot);
      });
      // get black bot
      marshalChessBot(snap.data["blackBot"]).first.then((bot) {
        _blackBot = bot;
        _internalInBlackBot.add(_blackBot);
      });
    });

    // things that need to happen on every update
    matchRef.snapshots().listen((snap) async {
      _fen = snap.data["fen"] ??
          "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
      _internalInFen.add(_fen);
      _pgn = snap.data["pgn"] ?? "";
      _internalInPgn.add(_pgn);

      // handle (potential) move
      _gameController.loadFEN(_fen);
      if (_gameController.gameOver) {
        event.add(GameOver());
      } else {
        bool playerIsWhite = await playerIsWhite$.first;
        chess.Color _onusToMove = _gameController.turn;
        chess.Color _playerColor =
            playerIsWhite ? chess.Color.WHITE : chess.Color.BLACK;
        if (_onusToMove == _playerColor) {
          ChessBot _playerBot =
              playerIsWhite ? await whiteBot$.first : await blackBot$.first;
          await Future.delayed(Duration(seconds: 1));
          String move = _playerBot.waterfallGambits(_gameController.game);
          _gameController.makeMove(move);
          event.add(MoveMade(_gameController.game, move));
        } else {
          // not our turn to move, but we can still see which gambit the opponent will use
          ChessBot _opponentBot =
              !playerIsWhite ? await whiteBot$.first : await blackBot$.first;
          await Future.delayed(Duration(milliseconds: 1500));
          _opponentBot.waterfallGambits(_gameController.game);
        }
      }
    });
  }

  void _handleEvent(MultiplayerMatchEvent event) async {
    if (event is MoveMade) {
      await matchRef.updateData({
        "fen": event.game.fen,
        "pgn": "$_pgn ${event.move}",
      });
    } else if (event is GameOver) {
      FirestoreBloc().userEvent.add(FinishedMatch());
    }
  }

  void dispose() {
    _playerIsWhiteController.close();
    _whiteBotController.close();
    _blackBotController.close();
    _fenController.close();
    _pgnController.close();
    _eventController.close();
    _gameController.dispose();
  }
}

abstract class MultiplayerMatchEvent {}

class MoveMade extends MultiplayerMatchEvent {
  chess.Chess game;
  String move;
  MoveMade(this.game, this.move);
}

class GameOver extends MultiplayerMatchEvent {}
