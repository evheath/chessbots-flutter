import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveRookSafely extends Gambit {
  // singleton logic so that MoveRandomRook is only created once
  static final MoveRookSafely _singleton = MoveRookSafely._internal();
  factory MoveRookSafely() => _singleton;

  MoveRookSafely._internal()
      : super(
            cost: 4,
            demoFEN: '8/5k2/5n1r/1q6/4p2b/pR4Q1/8/3K1b1r w - - 0 1',
            vector: WhiteRook(),
            title: "Move Rook, safely",
            color: Colors.grey,
            description:
                "Move a rook to an undefended square--this can include captures.",
            altText: "Dig in boys.",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> rookMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.ROOK)
                  .toList()
                    ..shuffle();

              chess.Move move = rookMoves.firstWhere(
                  (rookMove) => Gambit.safeMove(rookMove, game),
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
