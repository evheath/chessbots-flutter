import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingBishop extends Gambit {
  // singleton logic so that CaptureQueenUsingBishop is only created once
  static final CaptureQueenUsingBishop _singleton =
      CaptureQueenUsingBishop._internal();
  factory CaptureQueenUsingBishop() => _singleton;

  CaptureQueenUsingBishop._internal()
      : super(
            cost: 4,
            demoFEN:
                '1nb1kbn1/pppppp1p/2r3r1/8/4B3/3q1p2/PPPPPPPP/RNBQK1NR w KQ - 0 1',
            title: "Capture queen with bishop",
            color: Colors.red,
            description: "Capture an enemy queen with a bishop.",
            altText: "God save the queen.",
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
                  return pieceBeingCaptured == chess.PieceType.QUEEN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
