import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingKnight extends Gambit {
  // singleton logic so that CaptureKnightUsingKnight is only created once
  static final CaptureKnightUsingKnight _singleton =
      CaptureKnightUsingKnight._internal();
  factory CaptureKnightUsingKnight() => _singleton;

  CaptureKnightUsingKnight._internal()
      : super(
            cost: 1,
            demoFEN:
                'rn2k3/ppp1ppp1/8/8/8/b1q2b1n/PPprpPPP/RNBQKBNR w KQq - 0 1',
            title: "Capture knight with knight",
            color: Colors.red,
            description: "Capture an enemy knight with a knight.",
            altText: "Chivarly may be dead, but now it has company",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithKnight = game
                  .moves()
                  .where((move) => move.toString().contains('Nx'))
                  .toList();
              capturesWithKnight.shuffle();
              String move = capturesWithKnight.firstWhere(
                (capture) {
                  String landingSquare = Gambit.landingSquareOfMove(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare)?.type;
                  return pieceBeingCaptured == chess.PieceType.KNIGHT;
                },
                orElse: () => null,
              );
              return move;
            }));
}
