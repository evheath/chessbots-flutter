import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRandomPiece extends Gambit {
  // singleton logic so that CaptureRandomPiece is only created once
  static final CaptureRandomPiece _singleton = CaptureRandomPiece._internal();
  factory CaptureRandomPiece() => _singleton;

  CaptureRandomPiece._internal()
      : super(
            cost: 5,
            demoFEN: "3k1n2/8/8/q4R1b/1B6/8/5p2/1K6 w - - 0 1",
            vector: BlackKing(),
            title: "Random takes Random",
            color: Colors.red,
            description: "Capture any piece using any piece.",
            altText: "Hell is empty and all the devils are here.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains('x'),
                orElse: () => null,
              );
              return move;
            }));
}
