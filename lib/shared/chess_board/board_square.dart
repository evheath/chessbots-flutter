import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './board_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:chess/chess.dart' as chess;

/// A single square on the chessboard
class BoardSquare extends StatelessWidget {
  /// The square name (a2, d3, e4, etc.)
  final squareName;

  BoardSquare({this.squareName});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BoardModel>(builder: (context, _, model) {
      return Expanded(
        flex: 1,
        child: DragTarget(builder: (context, accepted, rejected) {
          if (model.enableUserMoves == false) {
            // prevents user from picking up any piece
            return Container(
              child: _getImageToDisplay(size: model.size / 8, model: model),
            );
          }
          return model.chessBoardController.game.get(squareName) != null
              ? Draggable(
                  childWhenDragging: Container(),
                  child: _getImageToDisplay(size: model.size / 8, model: model),
                  feedback: _getImageToDisplay(
                      size: (1.2 * (model.size / 8)), model: model),
                  onDragCompleted: () {},
                  data: [
                    squareName,
                    model.chessBoardController.game
                        .get(squareName)
                        .type
                        .toUpperCase(),
                    model.chessBoardController.game.get(squareName).color,
                  ],
                )
              : Container();
        }, onWillAccept: (willAccept) {
          return model.enableUserMoves ? true : false;
        }, onAccept: (List moveInfo) {
          // moveInfo is the incoming data of the dropped piece
          // eg [c1, B, w]
          // the square being landed on is accessed via squareName
          // c4

          chess.Color moveColor = model.chessBoardController.turn;
          String source = moveInfo[0].toString();
          chess.Piece piece = model.chessBoardController.game.get(source);
          if (model.moveAnyPiece) {
            // we aren't playing a game, so we can simply PUT the pieces
            // instead of moving and promotion etc
            chess.Piece pieceBeingLandedOn =
                model.chessBoardController.game.get(squareName);
            if (pieceBeingLandedOn?.type == chess.PieceType.KING) {
              // dont let a king disappear from the board
              return;
            }

            model.chessBoardController.game.put(piece, squareName);
            model.chessBoardController.game.remove(source);
            // normally we do not want to reference a child of an object
            // but this time, we don't want to create a setter method
            model.chessBoardController.game.turn = chess.Color.WHITE;
            model.refreshBoard();
          } else {
            // we are playing a legal game and require move checking
            if (moveInfo[1] == "P" &&
                ((source[1] == "7" &&
                        squareName[1] == "8" &&
                        moveInfo[2] == chess.Color.WHITE) ||
                    (source[1] == "2" &&
                        squareName[1] == "1" &&
                        moveInfo[2] == chess.Color.BLACK))) {
              // we are promoting
              _promotionDialog(context).then((value) {
                model.chessBoardController.game.move(
                    {"from": source, "to": squareName, "promotion": value});
                model.refreshBoard();
              });
            } else {
              // we are just doing a regular move
              model.chessBoardController.game
                  .move({"from": source, "to": squareName});
            }
            if (model.chessBoardController.turn != moveColor) {
              model.onMove(
                  moveInfo[1] == "P" ? squareName : moveInfo[1] + squareName);
            }
            // checkmate logic here does not make much sense
            // as it is the controller that should know about a game over
            // since it does not always require user input
            // if (model.chessBoardController.game.in_checkmate) {
            //   String color = model.chessBoardController.turn.toString();
            //   model.onCheckMate(color);
            // }
            model.refreshBoard();
          }
        }),
      );
    });
  }

  /// Show dialog when pawn reaches last square
  Future<String> _promotionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Choose promotion'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: WhiteQueen(),
                onTap: () {
                  Navigator.of(context).pop("q");
                },
              ),
              InkWell(
                child: WhiteRook(),
                onTap: () {
                  Navigator.of(context).pop("r");
                },
              ),
              InkWell(
                child: WhiteBishop(),
                onTap: () {
                  Navigator.of(context).pop("b");
                },
              ),
              InkWell(
                child: WhiteKnight(),
                onTap: () {
                  Navigator.of(context).pop("n");
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      return value;
    });
  }

  /// Get image to display on square
  Widget _getImageToDisplay({double size, BoardModel model}) {
    Widget imageToDisplay = Container();

    chess.Piece piece = model.chessBoardController.game.get(squareName);

    if (piece != null) {
      switch (piece.type) {
        case chess.PieceType.PAWN:
          imageToDisplay = piece.color == chess.Color.WHITE
              ? Icon(FontAwesomeIcons.chessPawn, color: Colors.white)
              : Icon(FontAwesomeIcons.chessPawn, color: Colors.black);
          break;
        case chess.PieceType.ROOK:
          imageToDisplay = piece.color == chess.Color.WHITE
              ? Icon(FontAwesomeIcons.chessRook, color: Colors.white)
              : Icon(FontAwesomeIcons.chessRook, color: Colors.black);
          break;
        case chess.PieceType.KNIGHT:
          imageToDisplay = piece.color == chess.Color.WHITE
              ? Icon(FontAwesomeIcons.chessKnight, color: Colors.white)
              : Icon(FontAwesomeIcons.chessKnight, color: Colors.black);
          break;
        case chess.PieceType.BISHOP:
          imageToDisplay = piece.color == chess.Color.WHITE
              ? Icon(FontAwesomeIcons.chessBishop, color: Colors.white)
              : Icon(FontAwesomeIcons.chessBishop, color: Colors.black);
          break;
        case chess.PieceType.QUEEN:
          imageToDisplay = piece.color == chess.Color.WHITE
              ? Icon(FontAwesomeIcons.chessQueen, color: Colors.white)
              : Icon(FontAwesomeIcons.chessQueen, color: Colors.black);
          break;
        case chess.PieceType.KING:
          imageToDisplay = piece.color == chess.Color.WHITE
              ? Icon(FontAwesomeIcons.chessKing, color: Colors.white)
              : Icon(FontAwesomeIcons.chessKing, color: Colors.black);
          break;
      }
    }

    return imageToDisplay;
  }
}
