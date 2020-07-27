import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveKing extends Gambit {
  // singleton logic so that MoveRandomKing is only created once
  static final MoveKing _singleton = MoveKing._internal();
  factory MoveKing() => _singleton;

  MoveKing._internal()
      : super(
            cost: 1,
            demoFEN: '4k3/8/8/1q6/7b/pR4Q1/K7/8 w - - 0 1',
            vector: WhiteKing(),
            title: "Move King",
            color: Colors.grey,
            description: "Make a random king move--including captures.",
            altText: "I go where I please",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<chess.Move> kingMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.KING)
                  .toList()
                    ..shuffle();

              chess.Move move =
                  kingMoves.firstWhere((kingMove) => true, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
