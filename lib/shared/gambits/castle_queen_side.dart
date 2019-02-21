import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CastleQueenSide extends Gambit {
  // singleton logic so that CastleQueenSide is only created once
  static final CastleQueenSide _singleton = CastleQueenSide._internal();
  factory CastleQueenSide() => _singleton;

  CastleQueenSide._internal()
      : super(
            title: "Castle Queen Side",
            color: Colors.blue,
            description: "Move your king to safety and activate a rook!",
            //TODO find appropriate icon
            icon: Icons.queue_play_next,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString() == "O-O-O",
                orElse: () => null,
              );
              return move;
            }));
}
