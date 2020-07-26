import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingRook extends Gambit {
  // singleton logic so that CapturePawnUsingRook is only created once
  static final CapturePawnUsingRook _singleton =
      CapturePawnUsingRook._internal();
  factory CapturePawnUsingRook() => _singleton;

  CapturePawnUsingRook._internal()
      : super(
            cost: 1,
            demoFEN:
                'r3k3/2qppp1p/8/8/p1R1b1Rr/2n5/PPPPPPPP/1NBQKBN1 w q - 0 1',
            title: "Rook takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with a rook.",
            altText: "Brace the door!",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithRook = game
                  .moves()
                  .where((move) =>
                      move.toString().contains('R') &&
                      move.toString().contains('x'))
                  .toList();
              capturesWithRook.shuffle();
              String move = capturesWithRook.firstWhere(
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
