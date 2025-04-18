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
  String _fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
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
  StreamController<GameOutcome> _outcomeController =
      BehaviorSubject<GameOutcome>();

  /// internal-in (alias)
  StreamSink<bool> get _internalInPlayerIsWhite =>
      _playerIsWhiteController.sink;
  StreamSink<ChessBot> get _internalInWhiteBot => _whiteBotController.sink;
  StreamSink<ChessBot> get _internalInBlackBot => _blackBotController.sink;
  StreamSink<String> get _internalInFen => _fenController.sink;
  StreamSink<String> get _internalInPgn => _pgnController.sink;
  StreamSink<GameOutcome> get _internalInOutcome => _outcomeController.sink;

  /// external-out (alias)
  Stream<bool> get playerIsWhite$ => _playerIsWhiteController.stream;
  Stream<ChessBot> get whiteBot$ => _whiteBotController.stream;
  Stream<ChessBot> get blackBot$ => _blackBotController.stream;
  Stream<String> get fen$ => _fenController.stream;
  Stream<String> get pgn$ => _pgnController.stream;
  Stream<GameOutcome> get outcome$ => _outcomeController.stream;

  // constructor
  MultiplayerMatchBloc(this.matchRef) {
    _eventController.stream.listen(_handleEvent);
    // things that only need to happen once
    matchRef.get().then((snap) {
      // determine if player is white
      FirestoreBloc().user$.first.then((playerAsFbUser) {
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
      _pgn = snap.data["pgn"] ?? "";
      _internalInPgn.add(_pgn);

      String _fenFromSnap = snap.data["fen"] ??
          "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
      _internalInFen.add(_fenFromSnap);
      _gameController.loadFEN(_fenFromSnap);

      bool playerIsWhite = await playerIsWhite$.first;
      chess.Color _playerColor =
          playerIsWhite ? chess.Color.WHITE : chess.Color.BLACK;
      chess.Color _onusToMove = _gameController.turn;

      if (_gameController.gameOver) {
        event.add(GameOver());
      } else if (_onusToMove == _playerColor) {
        // the opponent made a move and it is the players turn

        // we need reload using the old fen to see which gambit the opponent used
        _gameController.loadFEN(_fen);
        ChessBot _opponentBot =
            !playerIsWhite ? await whiteBot$.first : await blackBot$.first;
        _opponentBot.waterfallGambits(_gameController.game);

        // now we can load the new fen and make our move
        _gameController.loadFEN(_fenFromSnap);
        ChessBot _playerBot =
            playerIsWhite ? await whiteBot$.first : await blackBot$.first;
        await Future.delayed(Duration(seconds: 1));
        String move = _playerBot.waterfallGambits(_gameController.game);
        _gameController.makeMove(move);
        _fen = _gameController.game.fen;
        event.add(MoveMade(_gameController.game, move));
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
      // remove current match from user
      FirestoreBloc().userEvent.add(FinishedMatch());

      GameStatus status = await _gameController.status$.first;
      if (status == GameStatus.in_checkmate) {
        // determine if we won or lost
        chess.Color playersColor =
            _playerIsWhite ? chess.Color.WHITE : chess.Color.BLACK;
        chess.Color losersColor = _gameController.turn;
        if (playersColor == losersColor) {
          // player lost
          _internalInOutcome.add(GameOutcome.defeat);

          //trigger the checkmate gambit for the opponent (for the UI)
          bool playerIsWhite = await playerIsWhite$.first;
          ChessBot _opponentBot =
              !playerIsWhite ? await whiteBot$.first : await blackBot$.first;
          _gameController.loadFEN(_fen);
          _opponentBot.waterfallGambits(_gameController.game);
        } else {
          // player won
          _internalInOutcome.add(GameOutcome.victory);
          int reward = opponentBot.bounty;
          FirestoreBloc().userEvent.add(AwardNerdPointsEvent(reward));
        }
      } else if (status == GameStatus.in_draw) {
        // pity point for drawing
        _internalInOutcome.add(GameOutcome.draw);
        FirestoreBloc().userEvent.add(AwardNerdPointsEvent(1));
      } else {}
    }
  }

  void dispose() {
    _outcomeController.close();
    _playerIsWhiteController.close();
    _whiteBotController.close();
    _blackBotController.close();
    _fenController.close();
    _pgnController.close();
    _eventController.close();
    _gameController.dispose();
  }

  ChessBot get opponentBot {
    return _playerIsWhite ? _blackBot : _whiteBot;
  }
}

abstract class MultiplayerMatchEvent {}

class MoveMade extends MultiplayerMatchEvent {
  chess.Chess game;
  String move;
  MoveMade(this.game, this.move);
}

class GameOver extends MultiplayerMatchEvent {}

enum GameOutcome { victory, defeat, draw }
