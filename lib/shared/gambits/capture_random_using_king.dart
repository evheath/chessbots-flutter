import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingKing extends Gambit {
  // singleton logic so that CaptureRandomUsingKing is only created once
  static final CaptureRandomUsingKing _singleton =
      CaptureRandomUsingKing._internal();
  factory CaptureRandomUsingKing() => _singleton;

  CaptureRandomUsingKing._internal()
      : super(
            cost: 2,
            demoFEN: '4k3/8/8/8/5n2/4Kb2/5p2/8 w - - 0 1',
            title: "King takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with the King.",
            altText: "Quite telling how your king doesn't face me himself.",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithKing = game
                  .moves()
                  .where((move) => move.toString().contains('Kx'))
                  .toList();
              capturesWithKing.shuffle();
              String move = capturesWithKing.firstWhere(
                (capture) => true,
                orElse: () => null,
              );
              return move;
            }));
}
