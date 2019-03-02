import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PawnToE4 extends Gambit {
  // singleton logic so that PawnToE4 is only created once
  static final PawnToE4 _singleton = PawnToE4._internal();
  factory PawnToE4() => _singleton;

  PawnToE4._internal()
      : super(
            vector: WhitePawn(),
            title: "Move a pawn to e4",
            color: Colors.grey,
            description: "If a pawn can move to e4, it will!",
            altText: "Control the center!",
            icon: FontAwesomeIcons.chessPawn,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> moves = game.moves();
              // moves.shuffle();
              String move = moves.firstWhere(
                (move) => move == "e4",
                orElse: () => null,
              );
              return move;
            }));
}
