import 'dart:ui';
import './chess_board_controller.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:chess/chess.dart' as chess;

typedef Null MoveCallback(String moveNotation);
typedef Null CheckMateCallback(String winColor);

class BoardModel extends Model {
  /// object that keeps track of the absolute position of the board
  ///
  /// Used for when a invalid game/move needs to be presented
  /// such as free movement on the lab board
  Map<String, String> positionMap = {
    "a8": "BR",
    "b8": "BN",
    "c8": "BB",
    "d8": "BQ",
    "e8": "BK",
    "f8": "BB",
    "g8": "BN",
    "h8": "BR",
    "a7": "BP",
    "b7": "BP",
    "c7": "BP",
    "d7": "BP",
    "e7": "BP",
    "f7": "BP",
    "g7": "BP",
    "h7": "BP",
    "a6": null,
    "b6": null,
    "c6": null,
    "d6": null,
    "e6": null,
    "f6": null,
    "g6": null,
    "h6": null,
    "a5": null,
    "b5": null,
    "c5": null,
    "d5": null,
    "e5": null,
    "f5": null,
    "g5": null,
    "h5": null,
    "a4": null,
    "b4": null,
    "c4": null,
    "d4": null,
    "e4": null,
    "f4": null,
    "g4": null,
    "h4": null,
    "a3": null,
    "b3": null,
    "c3": null,
    "d3": null,
    "e3": null,
    "f3": null,
    "g3": null,
    "h3": null,
    "a2": 'WP',
    "b2": 'WP',
    "c2": 'WP',
    "d2": 'WP',
    "e2": 'WP',
    "f2": 'WP',
    "g2": 'WP',
    "h2": 'WP',
    "a1": "WR",
    "b1": "WN",
    "c1": "WB",
    "d1": "WQ",
    "e1": "WK",
    "f1": "WB",
    "g1": "WN",
    "h1": "WR",
  };

  bool moveAnyPiece;

  /// The size of the board (The board is a square)
  double size;

  /// Callback for when a move is made
  MoveCallback onMove;

  /// Callback for when a player is checkmated
  CheckMateCallback onCheckMate;

  /// Callback for when the game is a draw (Example: K v K)
  VoidCallback onDraw;

  /// If the white side of the board is towards the user
  bool whiteSideTowardsUser;

  /// The controller for programmatically making moves
  ChessBoardController chessBoardController;

  /// User moves can be enabled or disabled by this property
  bool enableUserMoves;

  /// Creates a logical game
  // chess.Chess game = chess.Chess();

  /// Refreshes board
  void refreshBoard() {
    notifyListeners();
  }

  BoardModel(
    this.size,
    this.onMove,
    this.onCheckMate,
    this.onDraw,
    this.whiteSideTowardsUser,
    this.chessBoardController,
    this.enableUserMoves,
    this.moveAnyPiece,
  ) {
    // chessBoardController?.game = game;
    chessBoardController?.refreshBoard = refreshBoard;
  }
}
