import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CastleQueenSide extends Gambit {
  // singleton logic so that CastleQueenSide is only created once
  static final CastleQueenSide _singleton = CastleQueenSide._internal();
  factory CastleQueenSide() => _singleton;

  CastleQueenSide._internal()
      : super(
            vector: WhiteRook(),
            title: "Castle Queen Side",
            color: Colors.blue,
            description: "Move your king to safety and activate a rook!",
            altText: "Proper defense will win the day",
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
