import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveKnightSafely extends Gambit {
  // singleton logic so that MoveRandomKnight is only created once
  static final MoveKnightSafely _singleton = MoveKnightSafely._internal();
  factory MoveKnightSafely() => _singleton;

  MoveKnightSafely._internal()
      : super(
            cost: 3,
            demoFEN: '8/2N2k2/7r/1q6/4p2b/p3N1Q1/8/3K1b2 w - - 0 1',
            vector: WhiteKnight(),
            title: "Move Knight, safely",
            color: Colors.grey,
            description:
                "Move a knight to an undefended square--this can include captures.",
            altText: "The Lord will deliver the righteous.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> knightMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.KNIGHT)
                  .toList()
                    ..shuffle();

              chess.Move move = knightMoves.firstWhere(
                  (knightMove) => Gambit.safeMove(knightMove, game),
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
