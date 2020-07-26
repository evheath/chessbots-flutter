import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingQueen extends Gambit {
  // singleton logic so that CaptureRandomUsingQueen is only created once
  static final CaptureRandomUsingQueen _singleton =
      CaptureRandomUsingQueen._internal();
  factory CaptureRandomUsingQueen() => _singleton;

  CaptureRandomUsingQueen._internal()
      : super(
            cost: 1,
            demoFEN:
                'r3k2r/ppppppp1/7n/1n6/8/bQq2b2/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with a queen.",
            altText: "My power doesn't seem so abstract now does it?",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithQueen = game
                  .moves()
                  .where((move) => move.toString().contains('Qx'))
                  .toList();
              capturesWithQueen.shuffle();
              String move = capturesWithQueen.firstWhere(
                (capture) => true,
                orElse: () => null,
              );
              return move;
            }));
}
