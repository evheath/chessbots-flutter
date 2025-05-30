import 'package:chessbotsmobile/bloc/game_controller.bloc.dart';
import 'package:chessbotsmobile/shared/chess_board/board_model.dart';
import 'package:chessbotsmobile/shared/chess_board/board_rank.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

var whiteSquareList = [
  [
    "a8",
    "b8",
    "c8",
    "d8",
    "e8",
    "f8",
    "g8",
    "h8",
  ],
  [
    "a7",
    "b7",
    "c7",
    "d7",
    "e7",
    "f7",
    "g7",
    "h7",
  ],
  [
    "a6",
    "b6",
    "c6",
    "d6",
    "e6",
    "f6",
    "g6",
    "h6",
  ],
  [
    "a5",
    "b5",
    "c5",
    "d5",
    "e5",
    "f5",
    "g5",
    "h5",
  ],
  [
    "a4",
    "b4",
    "c4",
    "d4",
    "e4",
    "f4",
    "g4",
    "h4",
  ],
  [
    "a3",
    "b3",
    "c3",
    "d3",
    "e3",
    "f3",
    "g3",
    "h3",
  ],
  [
    "a2",
    "b2",
    "c2",
    "d2",
    "e2",
    "f2",
    "g2",
    "h2",
  ],
  [
    "a1",
    "b1",
    "c1",
    "d1",
    "e1",
    "f1",
    "g1",
    "h1",
  ],
];

/// Enum which stores board types
enum BoardType {
  brown,
  darkBrown,
  orange,
  green,
}

/// The Chessboard Widget
class ChessBoard extends StatefulWidget {
  /// allows the player to move any piece at any time
  ///
  /// e.g. move black pieces during white's turn
  final bool moveAnyPiece;

  /// Size of chessboard
  final double size;

  /// Callback for when move is made
  ///
  /// Required as not providing one will cause null errors
  final MoveCallback onMove;

  /// Callback for when a player is checkmated
  final CheckMateCallback onCheckMate;

  /// Callback for when the game is a draw
  final VoidCallback onDraw;

  /// A boolean which notes if white board side is towards users
  final bool whiteSideTowardsUser;

  /// A controller to programmatically control the chess board
  final GameControllerBloc chessBoardController;

  /// A boolean which checks if the user should be allowed to make moves
  final bool enableUserMoves;

  /// The color type of the board
  final BoardType boardType;

  ChessBoard({
    this.size = 200.0,
    this.whiteSideTowardsUser = true,
    @required this.onMove,
    this.onCheckMate,
    @required this.onDraw,
    this.chessBoardController,
    this.enableUserMoves = true,
    this.boardType = BoardType.brown,
    this.moveAnyPiece = false,
  });

  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: BoardModel(
        widget.size,
        widget.onMove,
        widget.onCheckMate ?? (String derp) {},
        widget.onDraw,
        widget.whiteSideTowardsUser,
        widget.chessBoardController,
        widget.enableUserMoves,
        widget.moveAnyPiece,
      ),
      child: Container(
        height: widget.size,
        width: widget.size,
        child: Stack(
          children: <Widget>[
            Container(
              height: widget.size,
              width: widget.size,
              child: _getBoardImage(),
            ),
            //Overlaying draggables/ dragTargets onto the squares
            Center(
              child: Container(
                height: widget.size,
                width: widget.size,
                child: buildChessBoard(),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Builds the board
  Widget buildChessBoard() {
    return Column(
      children: widget.whiteSideTowardsUser
          ? whiteSquareList.map((row) {
              return ChessBoardRank(
                children: row,
              );
            }).toList()
          : whiteSquareList.reversed.map((row) {
              return ChessBoardRank(
                children: row.reversed.toList(),
              );
            }).toList(),
    );
  }

  /// Returns the board image
  Image _getBoardImage() {
    switch (widget.boardType) {
      case BoardType.brown:
        return Image.asset(
          "images/brown_board.png",
          // package: 'flutter_chess_board',
          fit: BoxFit.cover,
        );
      case BoardType.darkBrown:
        return Image.asset(
          "images/dark_brown_board.png",
          // package: 'flutter_chess_board',
          fit: BoxFit.cover,
        );
      case BoardType.green:
        return Image.asset(
          "images/green_board.png",
          // package: 'flutter_chess_board',
          fit: BoxFit.cover,
        );
      case BoardType.orange:
        return Image.asset(
          "images/orange_board.png",
          // package: 'flutter_chess_board',
          fit: BoxFit.cover,
        );
      default:
        return null;
    }
  }
}
