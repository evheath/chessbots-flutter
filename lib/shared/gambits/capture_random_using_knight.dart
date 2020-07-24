import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingKnight extends Gambit {
  // singleton logic so that CaptureRandomUsingKnight is only created once
  static final CaptureRandomUsingKnight _singleton =
      CaptureRandomUsingKnight._internal();
  factory CaptureRandomUsingKnight() => _singleton;

  CaptureRandomUsingKnight._internal()
      : super(
            cost: 1,
            demoFEN:
                'rnbqk2r/p1pp1ppp/1p3n2/4p3/4P3/bP3N2/PBPP1PPP/RN1QKB1R w KQkq - 0 1',
            title: "Capture any with knight",
            color: Colors.red,
            description: "Take a random piece using one of your knights.",
            altText: "Deus Vult.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithKnight = game
                  .moves()
                  .where((move) => move.toString().contains('Nx'))
                  .toList();
              capturesWithKnight.shuffle();
              String move = capturesWithKnight.firstWhere(
                (capture) => true, // any capture with Knight will do
                orElse: () => null,
              );
              return move;
            }));
}
