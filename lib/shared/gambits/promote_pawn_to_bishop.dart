import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToBishop extends Gambit {
  // singleton logic so that PromotePawnToBishop is only created once
  static final PromotePawnToBishop _singleton = PromotePawnToBishop._internal();
  factory PromotePawnToBishop() => _singleton;

  PromotePawnToBishop._internal()
      : super(
            vector: WhiteBishop(),
            title: "Promote to bishop",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a bishop",
            altText: "not bad!",
            //TODO find appropriate icon
            icon: Icons.done_all,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("=B"),
                orElse: () => null,
              );
              return move;
            }));
}
