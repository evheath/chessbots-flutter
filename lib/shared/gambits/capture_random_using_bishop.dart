import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

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
            title: "Capture any with bishop",
            color: Colors.red,
            description: "Take a random piece using one of your bishops.",
            altText: "Repent.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithBishop = game
                  .moves()
                  .where((move) => move.toString().contains('Bx'))
                  .toList();
              capturesWithBishop.shuffle();
              String move = capturesWithBishop.firstWhere(
                (capture) => true, // any capture with bishop will do
                orElse: () => null,
              );
              return move;
            }));
}
