import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class MoveRandomPawn extends Gambit {
  // singleton logic so that MoveRandomPawn is only created once
  static final MoveRandomPawn _singleton = MoveRandomPawn._internal();
  factory MoveRandomPawn() => _singleton;

  MoveRandomPawn._internal()
      : super(
            title: "Move a random pawn",
            color: Colors.grey,
            description: "Moves a pawn a random.",
            //TODO find appropriate icon
            icon: Icons.repeat,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) =>
                    move.toString()[0] != move.toString()[0].toUpperCase(),
                orElse: () => null,
              );
              return move;
            }));
}
