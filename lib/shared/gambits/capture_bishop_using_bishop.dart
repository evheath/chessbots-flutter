import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingBishop extends Gambit {
  // singleton logic so that CaptureBishopUsingBishop is only created once
  static final CaptureBishopUsingBishop _singleton =
      CaptureBishopUsingBishop._internal();
  factory CaptureBishopUsingBishop() => _singleton;

  CaptureBishopUsingBishop._internal()
      : super(
            cost: 1,
            demoFEN:
                'rn2k2r/pQpppppp/b2bq2n/8/2B2BN1/8/PPPPPPPP/RN2K2R w KQkq - 0 1',
            title: "Capture bishop with bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with your own.",
            altText: "Converted...into a dead man",
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
                  return pieceBeingCaptured == chess.PieceType.BISHOP;
                },
                orElse: () => null,
              );
              return move;
            }));
}
