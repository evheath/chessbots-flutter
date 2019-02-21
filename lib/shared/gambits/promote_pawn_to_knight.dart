import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class PromotePawnToKnight extends Gambit {
  // singleton logic so that PromotePawnToKnight is only created once
  static final PromotePawnToKnight _singleton = PromotePawnToKnight._internal();
  factory PromotePawnToKnight() => _singleton;

  PromotePawnToKnight._internal()
      : super(
            title: "Promote a pawn to a knight",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a knight--better than nothing!",
            //TODO find appropriate icon
            icon: Icons.done_all,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("=N"),
                orElse: () => null,
              );
              return move;
            }));
}
