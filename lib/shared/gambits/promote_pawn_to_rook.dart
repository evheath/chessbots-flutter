import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToRook extends Gambit {
  // singleton logic so that PromotePawnToRook is only created once
  static final PromotePawnToRook _singleton = PromotePawnToRook._internal();
  factory PromotePawnToRook() => _singleton;

  PromotePawnToRook._internal()
      : super(
            vector: WhiteRook(),
            title: "Promote a pawn to a rook",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a rook--very nice!",
            //TODO find appropriate icon
            icon: Icons.done_all,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("=R"),
                orElse: () => null,
              );
              return move;
            }));
}
