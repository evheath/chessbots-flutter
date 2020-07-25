import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingPawn extends Gambit {
  // singleton logic so that CaptureRandomUsingPawn is only created once
  static final CaptureRandomUsingPawn _singleton =
      CaptureRandomUsingPawn._internal();
  factory CaptureRandomUsingPawn() => _singleton;

  CaptureRandomUsingPawn._internal()
      : super(
            cost: 3,
            demoFEN:
                '1nb1k3/prppppPp/P4P2/3Q4/2q1rRn1/3P1P2/2P1PNP1/1NB1KB1R w K - 0 1',
            title: "Pawn takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with a pawn.",
            altText: "Think of the spoils!",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithPawn = game
                  .moves()
                  .where((move) =>
                      move.toString()[0] !=
                          move.toString()[0].toUpperCase() && // its a pawn move
                      move.toString().contains('x')) // it is a capture
                  .toList();
              capturesWithPawn.shuffle();
              String move = capturesWithPawn.firstWhere(
                (capture) => true, // any will do
                orElse: () => null,
              );
              return move;
            }));
}
