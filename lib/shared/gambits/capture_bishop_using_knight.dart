import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingKnight extends Gambit {
  // singleton logic so that CaptureBishopUsingKnight is only created once
  static final CaptureBishopUsingKnight _singleton =
      CaptureBishopUsingKnight._internal();
  factory CaptureBishopUsingKnight() => _singleton;

  CaptureBishopUsingKnight._internal()
      : super(
            cost: 2,
            demoFEN:
                'rn2k3/ppppppp1/8/8/8/b1q2b1n/PPprPPPP/RNBQKBNR w KQq - 0 1',
            title: "Capture bishop with knight",
            color: Colors.red,
            description: "Capture an enemy bishop with a knight.",
            altText: "Who will hear my confession now?",
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
                  return pieceBeingCaptured == chess.PieceType.BISHOP;
                },
                orElse: () => null,
              );
              return move;
            }));
}
