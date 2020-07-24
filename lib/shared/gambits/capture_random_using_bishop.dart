import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRandomUsingBishop extends Gambit {
  // singleton logic so that CaptureRandomUsingBishop is only created once
  static final CaptureRandomUsingBishop _singleton =
      CaptureRandomUsingBishop._internal();
  factory CaptureRandomUsingBishop() => _singleton;

  CaptureRandomUsingBishop._internal()
      : super(
            cost: 1,
            demoFEN:
                'rnbqk2r/p1pp1ppp/1p3n2/4p3/4P3/bP3N2/PBPP1PPP/RN1QKB1R w KQkq - 0 1',
            vector: BlackBishop(),
            title: "Capture using bishop",
            color: Colors.red,
            description: "Take a random piece using one of your bishops.",
            altText: "Deus Vult.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains('Bx'),
                orElse: () => null,
              );
              return move;
            }));
}
