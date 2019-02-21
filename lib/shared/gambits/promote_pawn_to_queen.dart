import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToQueen extends Gambit {
  // singleton logic so that PromotePawnToQueen is only created once
  static final PromotePawnToQueen _singleton = PromotePawnToQueen._internal();
  factory PromotePawnToQueen() => _singleton;

  PromotePawnToQueen._internal()
      : super(
            vector: WhiteQueen(),
            title: "Promote a pawn to a queen",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a queen--the most valuable piece!",
            //TODO find appropriate icon
            icon: Icons.done_all,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("=Q"),
                orElse: () => null,
              );
              return move;
            }));
}
