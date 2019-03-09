import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CastleKingSide extends Gambit {
  // singleton logic so that CastleKingSide is only created once
  static final CastleKingSide _singleton = CastleKingSide._internal();
  factory CastleKingSide() => _singleton;

  CastleKingSide._internal()
      : super(
            cost: 2,
            demoFEN:
                "r1bqkb1r/pppp1ppp/2n2n2/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 1",
            vector: WhiteRook(),
            title: "Castle King Side",
            color: Colors.blue,
            description: "Move your king to safety while activating a rook!",
            altText: "Get me outta here!",
            icon: FontAwesomeIcons.chess,
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
