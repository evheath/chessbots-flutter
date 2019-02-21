import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomPiece extends Gambit {
  // singleton logic so that CaptureRandomPiece is only created once
  static final CaptureRandomPiece _singleton = CaptureRandomPiece._internal();
  factory CaptureRandomPiece() => _singleton;

  CaptureRandomPiece._internal()
      : super(
            title: "Capture a random piece",
            color: Colors.red,
            description: "Captures a piece at random.",
            //TODO find appropriate icon
            icon: Icons.backspace,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              var move =
                  moves.singleWhere((move) => move.toString().contains('x'));
              return move.toString();
            }));
}
