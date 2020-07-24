import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingBishop extends Gambit {
  // singleton logic so that CaptureRookUsingBishop is only created once
  static final CaptureRookUsingBishop _singleton =
      CaptureRookUsingBishop._internal();
  factory CaptureRookUsingBishop() => _singleton;

  CaptureRookUsingBishop._internal()
      : super(
            cost: 3,
            demoFEN:
                '1nb1kbn1/pppppp1p/2r3r1/8/4B3/3q1p2/PPPPPPPP/RNBQK1NR w KQ - 0 1',
            title: "Capture rook with bishop",
            color: Colors.red,
            description: "Capture an enemy rook with a bishop.",
            altText: "The word of God can penetrate any stone.",
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
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
