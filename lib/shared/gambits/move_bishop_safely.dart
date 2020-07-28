import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveBishopSafely extends Gambit {
  // singleton logic so that MoveRandomBishop is only created once
  static final MoveBishopSafely _singleton = MoveBishopSafely._internal();
  factory MoveBishopSafely() => _singleton;

  MoveBishopSafely._internal()
      : super(
            cost: 3,
            demoFEN: '8/5k2/7r/1q6/4p2b/p3B1Q1/6B1/3K1b2 w - - 0 1',
            vector: WhiteBishop(),
            title: "Move Bishop, safely",
            color: Colors.grey,
            description:
                "Move a bishop to an undefended square--this can include captures.",
            altText: "The Lord will deliver the righteous.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> bishopMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();

              chess.Move move = bishopMoves.firstWhere(
                  (bishopMove) => Gambit.safeMove(bishopMove, game),
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
