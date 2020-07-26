import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingRook extends Gambit {
  // singleton logic so that CaptureRandomUsingRook is only created once
  static final CaptureRandomUsingRook _singleton =
      CaptureRandomUsingRook._internal();
  factory CaptureRandomUsingRook() => _singleton;

  CaptureRandomUsingRook._internal()
      : super(
            cost: 2,
            demoFEN:
                'r3k3/2qppp1p/8/8/p1R1b1Rr/2n5/PPPPPPPP/1NBQKBN1 w q - 0 1',
            title: "Rook takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with a rook.",
            altText: "Draw! Loose!",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithRook = game
                  .moves()
                  .where((move) =>
                      move.toString().contains('R') &&
                      move.toString().contains('x'))
                  .toList();
              capturesWithRook.shuffle();
              String move = capturesWithRook.firstWhere(
                (capture) => true,
                orElse: () => null,
              );
              return move;
            }));
}
