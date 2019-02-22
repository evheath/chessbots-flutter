//TODO: it would be better if this relied solely on a FEN instead of a chess object
import 'package:flutter/material.dart';
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
            // prevents user from picking up any piece if configured to do so
            return Container(
              child: _getImageToDisplay(size: model.size / 8, model: model),
            );
          }
          if (model.moveAnyPiece) {
            String contents = model.positionMap[squareName];
            return contents != null
                ? Draggable(
                    childWhenDragging: Container(),
                    child:
                        _getImageToDisplay(size: model.size / 8, model: model),
                    feedback: _getImageToDisplay(
                        size: (1.2 * (model.size / 8)), model: model),
                    onDragCompleted: () {},
                    data: [
                      squareName,
                      contents[1],
                      contents[0],
                    ],
                  )
                : Container();
          } else {
            return model.chessBoardController.game.get(squareName) != null
                ? Draggable(
                    childWhenDragging: Container(),
                    child:
                        _getImageToDisplay(size: model.size / 8, model: model),
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
          }
        }, onWillAccept: (willAccept) {
          return model.enableUserMoves ? true : false;
        }, onAccept: (List moveInfo) {
          // moveInfo is the incoming data of the dropped piece
          // eg [c1, B, w]
          // the square being landed on is accessed via squareName
          // c4
          if (model.moveAnyPiece) {
            String color = moveInfo[2].toString().toUpperCase();
            String piece = moveInfo[1].toString();
            String pieceCode = color + piece;

            // add new piece
            String destination = squareName.toString();
            model.positionMap[destination] = pieceCode;
            // remove old piece
            String source = moveInfo[0].toString();
            model.positionMap[source] = null;

            model.refreshBoard();
          } else {
            chess.Color moveColor = model.chessBoardController.game.turn;
            if (moveInfo[1] == "P" &&
                ((moveInfo[0][1] == "7" &&
                        squareName[1] == "8" &&
                        moveInfo[2] == chess.Color.WHITE) ||
                    (moveInfo[0][1] == "2" &&
                        squareName[1] == "1" &&
                        moveInfo[2] == chess.Color.BLACK))) {
              _promotionDialog(context).then((value) {
                model.chessBoardController.game.move({
                  "from": moveInfo[0],
                  "to": squareName,
                  "promotion": value
                });
                model.refreshBoard();
              });
            } else {
              model.chessBoardController.game
                  .move({"from": moveInfo[0], "to": squareName});
            }
            if (model.chessBoardController.game.turn != moveColor) {
              model.onMove(
                  moveInfo[1] == "P" ? squareName : moveInfo[1] + squareName);
            }
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

    // print('here is the map ${model.positionMap}');

    String piece;
    if (model.moveAnyPiece) {
      // logic for nonController game state, pieces hsould be able to move to and from anywhere
      piece = model.positionMap[squareName.toString()];
      // print('rendering $piece on $squareName');
    } else {
      // we are in a game that needs legal moves, so we are defering game state to a controller
      piece = model.chessBoardController.game
              .get(squareName)
              .color
              .toString()
              .substring(0, 1)
              .toUpperCase() +
          model.chessBoardController.game.get(squareName).type.toUpperCase();
    }

    switch (piece) {
      case "WP":
        imageToDisplay = WhitePawn(size: size);
        break;
      case "WR":
        imageToDisplay = WhiteRook(size: size);
        break;
      case "WN":
        imageToDisplay = WhiteKnight(size: size);
        break;
      case "WB":
        imageToDisplay = WhiteBishop(size: size);
        break;
      case "WQ":
        imageToDisplay = WhiteQueen(size: size);
        break;
      case "WK":
        imageToDisplay = WhiteKing(size: size);
        break;
      case "BP":
        imageToDisplay = BlackPawn(size: size);
        break;
      case "BR":
        imageToDisplay = BlackRook(size: size);
        break;
      case "BN":
        imageToDisplay = BlackKnight(size: size);
        break;
      case "BB":
        imageToDisplay = BlackBishop(size: size);
        break;
      case "BQ":
        imageToDisplay = BlackQueen(size: size);
        break;
      case "BK":
        imageToDisplay = BlackKing(size: size);
        break;
      default:
        imageToDisplay = Container();
    }

    return imageToDisplay;
  }
}
