import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRandomPiece extends Gambit {
  // singleton logic so that CaptureRandomPiece is only created once
  static final CaptureRandomPiece _singleton = CaptureRandomPiece._internal();
  factory CaptureRandomPiece() => _singleton;

  CaptureRandomPiece._internal()
      : super(
            vector: BlackKing(), // TODO find a question mark vector
            title: "Capture a random piece",
            color: Colors.red,
            description: "Captures a piece at random.",
            altText: "We'll take it!",
            //TODO find appropriate icon
            icon: Icons.backspace,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains('x'),
                orElse: () => null,
              );
              return move;
            }));
}
