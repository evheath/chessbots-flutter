import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class MakeRandomMove extends Gambit {
  // singleton logic so that MakeRandomMove is only created once
  static final MakeRandomMove _singleton = MakeRandomMove._internal();
  factory MakeRandomMove() => _singleton;

  MakeRandomMove._internal()
      : super(
            title: "Move a random piece",
            color: Colors.grey,
            description: "Randomly selects a legal move.",
            //TODO find appropriate icon
            icon: Icons.add_circle_outline,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              var move = moves[0];
              return move.toString();
            }));
}
