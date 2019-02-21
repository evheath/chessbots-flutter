import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRook extends Gambit {
  // singleton logic so that CaptureRook is only created once
  static final CaptureRook _singleton = CaptureRook._internal();
  factory CaptureRook() => _singleton;

  CaptureRook._internal()
      : super(
            title: "Capture rook",
            color: Colors.red,
            description: "Take one of opponent's rooks.",
            //TODO find appropriate icon
            icon: Icons.save,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              String move = captures.firstWhere(
                (capture) {
                  String landingSquare = Gambit.squareOf(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare).type;
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
