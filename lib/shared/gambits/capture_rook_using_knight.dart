import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingKnight extends Gambit {
  // singleton logic so that CaptureRookUsingKnight is only created once
  static final CaptureRookUsingKnight _singleton =
      CaptureRookUsingKnight._internal();
  factory CaptureRookUsingKnight() => _singleton;

  CaptureRookUsingKnight._internal()
      : super(
            cost: 3,
            demoFEN:
                'rn2k3/ppppppp1/8/8/8/b1q2b1n/PPprPPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Rook",
            color: Colors.red,
            description: "Capture an enemy Rook with a knight.",
            altText: "Fixed fortifications are monuments to stupidity.",
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
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
