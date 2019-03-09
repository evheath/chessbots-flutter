import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveRandomPiece extends Gambit {
  // singleton logic so that MakeRandomMove is only created once
  static final MoveRandomPiece _singleton = MoveRandomPiece._internal();
  factory MoveRandomPiece() => _singleton;

  MoveRandomPiece._internal()
      : super(
            cost: 0,
            demoFEN:
                'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 1',
            vector: BlackKing(),
            title: "Move a random piece",
            color: Colors.grey,
            description: "Randomly selects a legal move.",
            altText: "Hope for the best, plan for the worst",
            icon: FontAwesomeIcons.question,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves[0];
              return move;
            }));
}
