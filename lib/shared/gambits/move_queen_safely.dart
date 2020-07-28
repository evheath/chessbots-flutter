import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveQueenSafely extends Gambit {
  // singleton logic so that MoveRandomQueen is only created once
  static final MoveQueenSafely _singleton = MoveQueenSafely._internal();
  factory MoveQueenSafely() => _singleton;

  MoveQueenSafely._internal()
      : super(
          cost: 6,
          demoFEN: '8/5k2/5n1r/1q1n4/1p2p2b/pR4Q1/8/3K1b1r w - - 0 1',
          vector: WhiteQueen(),
          title: "Move Queen, safely",
          color: Colors.grey,
          description:
              "Move your queen to an undefended square--this can include captures.",
          altText: "I go where I please, but obviously not just anywhere",
          icon: FontAwesomeIcons.chessQueen,
          findMove: ((chess.Chess game) {
            List<chess.Move> queenMoves = game
                .generate_moves()
                .where((oneMove) => oneMove.piece == chess.PieceType.QUEEN)
                .toList()
                  ..shuffle();

            chess.Move move = queenMoves.firstWhere(
                (queenMove) => Gambit.safeMove(queenMove, game),
                orElse: () => null);

            return move == null ? null : game.move_to_san(move);
          }),
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.arrowRight),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
        );
}
