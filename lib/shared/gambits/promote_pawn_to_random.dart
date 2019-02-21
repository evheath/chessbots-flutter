import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToRandom extends Gambit {
  // singleton logic so that PromotePawnToRandom is only created once
  static final PromotePawnToRandom _singleton = PromotePawnToRandom._internal();
  factory PromotePawnToRandom() => _singleton;

  PromotePawnToRandom._internal()
      : super(
            vector: BlackKing(), // TODO questionmark vector
            title: "Promote a pawn to a random piece",
            color: Colors.yellow,
            description:
                "If a pawn reaches the back rank, it can promote to a knight, bishop, rook or queen!",
            //TODO find appropriate icon
            icon: Icons.done_all,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("="),
                orElse: () => null,
              );
              return move;
            }));
}
