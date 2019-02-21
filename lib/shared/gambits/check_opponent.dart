import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponent extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponent _singleton = CheckOpponent._internal();
  factory CheckOpponent() => _singleton;

  CheckOpponent._internal()
      : super(
            title: "Check Opponent",
            color: Colors.red,
            description: "Attack your opponent's king!",
            //TODO find appropriate icon
            icon: Icons.remove_circle_outline,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("+"),
                orElse: () => null,
              );
              return move;
            }));
}
