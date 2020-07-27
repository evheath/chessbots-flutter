import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveRook extends Gambit {
  // singleton logic so that MoveRandomRook is only created once
  static final MoveRook _singleton = MoveRook._internal();
  factory MoveRook() => _singleton;

  MoveRook._internal()
      : super(
            cost: 1,
            demoFEN: '4k3/8/8/1q5R/7b/pR6/8/3K4 w - - 0 1',
            vector: WhiteRook(),
            title: "Move Rook",
            color: Colors.grey,
            description: "Make a random rook move--including captures.",
            altText: "Our orders are to setup where?",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> rookMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.ROOK)
                  .toList()
                    ..shuffle();

              chess.Move move =
                  rookMoves.firstWhere((rookMove) => true, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
