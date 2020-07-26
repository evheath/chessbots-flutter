import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingQueen extends Gambit {
  // singleton logic so that CaptureKnightUsingQueen is only created once
  static final CaptureKnightUsingQueen _singleton =
      CaptureKnightUsingQueen._internal();
  factory CaptureKnightUsingQueen() => _singleton;

  CaptureKnightUsingQueen._internal()
      : super(
            cost: 2,
            demoFEN:
                'r3k2r/ppppppp1/8/1n1n4/8/bQq2b2/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Knight",
            color: Colors.red,
            description: "Capture an enemy Knight with a queen.",
            altText: "I was worried I drank the poison.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithQueen = game
                  .moves()
                  .where((move) => move.toString().contains('Qx'))
                  .toList();
              capturesWithQueen.shuffle();
              String move = capturesWithQueen.firstWhere(
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
