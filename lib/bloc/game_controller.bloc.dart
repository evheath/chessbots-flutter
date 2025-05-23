import 'package:chess/chess.dart' as chess;
import 'package:rxdart/rxdart.dart';
import 'dart:async';

enum PieceType { Pawn, Rook, Knight, Bishop, Queen, King }

enum PieceColor {
  White,
  Black,
}

enum GameStatus { in_checkmate, in_progress, in_draw, pending }

/// Controller for programmatically controlling the board
class GameControllerBloc {
  String initialPosition;
  bool playRandom;

  ///Used for forcing a gameover, e.g. to break a while loop
  bool _executiveOverride = false;
  GameStatus _status;
  // controllers
  StreamController<GameStatus> _statusController =
      BehaviorSubject<GameStatus>(); // no external-in atm

  // state
  // GameStatus _gameStatus;
  chess.Chess game = chess.Chess();

  /// Function from the ScopedModel to refresh board
  Function refreshBoard;

  // constructor
  GameControllerBloc({this.initialPosition, this.playRandom = false}) {
    if (initialPosition != null) {
      loadFEN(initialPosition);
    }
    if (playRandom) {
      _playRandomGame();
    }
    _status = GameStatus.pending;
    _internalInStatus.add(_status);
  }

  // internal-in
  StreamSink<GameStatus> get _internalInStatus => _statusController.sink;

  // external-out (inherently connected to internal-in via controller)
  Stream<GameStatus> get status$ => _statusController.stream;

  // public methods

  chess.Color _turn() {
    return game.turn;
  }

  chess.Color get turn => _turn();

  bool _gameOver() {
    return _status == GameStatus.in_checkmate ||
        _status == GameStatus.in_draw ||
        _executiveOverride ||
        game.game_over;
  }

  bool get gameOver => _gameOver();

  /// Makes move on the board
  void makeMove(String move) {
    if (_gameOver() || move == "" || move == null) {
      return;
    }

    _status = GameStatus.in_progress;

    if (game.move(move)) {
      refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
    }

    if (game.in_checkmate) {
      _status = GameStatus.in_checkmate;
    } else if (game.in_draw) {
      _status = GameStatus.in_draw;
    }

    // try {
    _internalInStatus.add(_status);
    // } catch (e) {
    // print('catch an error trying to update status');
    // }
  }

  /// Makes move on the board then sets the turn back to white
  void labMove(String move) {
    game.move(move);
    // prevent en passant
    game.ep_square = -1;
    if (!game.in_checkmate && !game.in_check) {
      game?.turn = chess.Color.WHITE;
    }
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
  }

  /// Makes move and promotes pawn to piece (from is a square like d4, to is also a square like e3, pieceToPromoteTo is a String like "Q".
  /// pieceToPromoteTo String will be changed to enum in a future update and this method will be deprecated in the future
  void makeMoveWithPromotion(String from, String to, String pieceToPromoteTo) {
    game?.move({"from": from, "to": to, "promotion": pieceToPromoteTo});
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
  }

  /// Resets square
  void resetBoard() {
    game?.reset();
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
    _status = GameStatus.pending;
    _internalInStatus.add(_status);
  }

  /// Clears board
  void clearBoard() {
    game?.clear();
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
  }

  /// Puts piece on a square
  void putPiece(PieceType piece, String square, PieceColor color) {
    game?.put(_getPiece(piece, color), square);
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
  }

  /// Loads a PGN
  void loadPGN(String pgn) {
    game.load_pgn(pgn);
    if (game.in_checkmate) {
      _status = GameStatus.in_checkmate;
    } else if (game.in_draw) {
      _status = GameStatus.in_draw;
    } else {
      _status = GameStatus.pending;
    }
    _internalInStatus.add(_status);
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
  }

  /// Loads a FEN
  void loadFEN(String fen) {
    game.load(fen);
    if (game.in_checkmate) {
      _status = GameStatus.in_checkmate;
    } else if (game.in_draw) {
      _status = GameStatus.in_draw;
    } else {
      _status = GameStatus.pending;
    }
    _internalInStatus.add(_status);
    refreshBoard == null ? this._throwNotAttachedException() : refreshBoard();
  }

  /// Exception when a controller is not attached to a board
  void _throwNotAttachedException() {
    // throw Exception("Controller not attached to a ChessBoard widget!");
  }

  void _playRandomGame() async {
    // try {
    while (!_gameOver()) {
      List<dynamic> moves = game.moves();
      moves.shuffle();
      var move = moves[0];
      await Future.delayed(Duration(milliseconds: 500));
      makeMove(move.toString());
    }
    // } catch (e) {
    //   // print("caught an error in playRandomGame");
    //   // trying to continue a game after tear down results in errors we do not care about
    // }
  }

  /// Gets respective piece
  chess.Piece _getPiece(PieceType piece, PieceColor color) {
    chess.Color _getColor(PieceColor color) {
      return color == PieceColor.White ? chess.Color.WHITE : chess.Color.BLACK;
    }

    switch (piece) {
      case PieceType.Bishop:
        return chess.Piece(chess.PieceType.BISHOP, _getColor(color));
      case PieceType.Queen:
        return chess.Piece(chess.PieceType.QUEEN, _getColor(color));
      case PieceType.King:
        return chess.Piece(chess.PieceType.KING, _getColor(color));
      case PieceType.Knight:
        return chess.Piece(chess.PieceType.KNIGHT, _getColor(color));
      case PieceType.Pawn:
        return chess.Piece(chess.PieceType.PAWN, _getColor(color));
      case PieceType.Rook:
        return chess.Piece(chess.PieceType.ROOK, _getColor(color));
    }

    return chess.Piece(chess.PieceType.PAWN, chess.Color.WHITE);
  }

  // tear down
  void dispose() {
    _executiveOverride = true;
    _statusController.close();
  }
}
