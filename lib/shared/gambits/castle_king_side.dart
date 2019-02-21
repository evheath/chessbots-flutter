import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CastleKingSide extends Gambit {
  // singleton logic so that CastleKingSide is only created once
  static final CastleKingSide _singleton = CastleKingSide._internal();
  factory CastleKingSide() => _singleton;

  CastleKingSide._internal()
      : super(
            vector: WhiteRook(),
            title: "Castle King Side",
            color: Colors.blue,
            description: "Moves your king to safety and activates a rook!",
            //TODO find appropriate icon
            icon: Icons.blur_circular,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString() == "O-O",
                orElse: () => null,
              );
              return move;
            }));
}
