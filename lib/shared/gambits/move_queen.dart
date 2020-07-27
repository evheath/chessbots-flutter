import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveQueen extends Gambit {
  // singleton logic so that MoveRandomQueen is only created once
  static final MoveQueen _singleton = MoveQueen._internal();
  factory MoveQueen() => _singleton;

  MoveQueen._internal()
      : super(
            cost: 1,
            demoFEN: '4k3/8/8/1q6/7b/pR4Q1/8/3K4 w - - 0 1',
            vector: WhiteQueen(),
            title: "Move Queen",
            color: Colors.grey,
            description: "Make a random queen move--including captures.",
            altText: "I go where I please",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> queenMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.QUEEN)
                  .toList()
                    ..shuffle();

              chess.Move move = queenMoves.firstWhere((queenMove) => true,
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
