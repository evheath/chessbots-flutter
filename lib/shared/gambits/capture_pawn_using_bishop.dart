import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingBishop extends Gambit {
  // singleton logic so that CapturePawnUsingBishop is only created once
  static final CapturePawnUsingBishop _singleton =
      CapturePawnUsingBishop._internal();
  factory CapturePawnUsingBishop() => _singleton;

  CapturePawnUsingBishop._internal()
      : super(
            cost: 1,
            demoFEN:
                'r1b1kbnr/ppppppp1/1q6/8/3B4/2n1p3/PPPPPPPP/RNBQK1NR w KQkq - 0 1',
            title: "Capture pawn with bishop",
            color: Colors.red,
            description: "Capture an enemy pawn with a bishop.",
            altText:
                "Evangelize them? As if these savages weren't dangerous enough already",
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
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
