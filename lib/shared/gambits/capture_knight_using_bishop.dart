import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingBishop extends Gambit {
  // singleton logic so that CaptureKnightUsingBishop is only created once
  static final CaptureKnightUsingBishop _singleton =
      CaptureKnightUsingBishop._internal();
  factory CaptureKnightUsingBishop() => _singleton;

  CaptureKnightUsingBishop._internal()
      : super(
            cost: 1,
            demoFEN:
                'rn2k2r/pQpppppp/b2bq2n/8/2B2BN1/8/PPPPPPPP/RN2K2R w KQkq - 0 1',
            title: "Bishop takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with a bishop.",
            altText: "A heretic can be tolerated. Heresy cannot.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithBishop = game
                  .moves()
                  .where((move) => move.toString().contains('Bx'))
                  .toList();
              capturesWithBishop.shuffle();
              String move = capturesWithBishop.firstWhere(
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
