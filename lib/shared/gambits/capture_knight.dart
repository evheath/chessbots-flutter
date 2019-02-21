import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnight extends Gambit {
  // singleton logic so that CaptureKnight is only created once
  static final CaptureKnight _singleton = CaptureKnight._internal();
  factory CaptureKnight() => _singleton;

  CaptureKnight._internal()
      : super(
            title: "Capture knight",
            color: Colors.red,
            description: "Take one of opponent's knights. Heyo!",
            //TODO find appropriate icon
            icon: Icons.sentiment_very_satisfied,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              print("available captures are $captures");
              String move = captures.firstWhere(
                (capture) {
                  String landingSquare = Gambit.squareOf(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare).type;
                  return pieceBeingCaptured == chess.PieceType.KNIGHT;
                },
                orElse: () => null,
              );
              return move;
            }));
}
