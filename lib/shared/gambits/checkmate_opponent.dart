import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckmateOpponent extends Gambit {
  // singleton logic so that CheckmateOpponent is only created once
  static final CheckmateOpponent _singleton = CheckmateOpponent._internal();
  factory CheckmateOpponent() => _singleton;

  CheckmateOpponent._internal()
      : super(
            title: "Checkmate Opponent",
            color: Colors.blue,
            description:
                "Win the game by ensuring the capture of the opponent's King",
            //TODO find appropriate icon
            icon: Icons.done_all,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("#"),
                orElse: () => null,
              );
              return move;
            }));
}
