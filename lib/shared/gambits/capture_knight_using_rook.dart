import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingRook extends Gambit {
  // singleton logic so that CaptureKnightUsingRook is only created once
  static final CaptureKnightUsingRook _singleton =
      CaptureKnightUsingRook._internal();
  factory CaptureKnightUsingRook() => _singleton;

  CaptureKnightUsingRook._internal()
      : super(
            cost: 1,
            demoFEN: '4k3/2qpppp1/8/8/pbR1r2r/nRn5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with a rook.",
            altText: "Ready the oil!",
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
                  return pieceBeingCaptured == chess.PieceType.KNIGHT;
                },
                orElse: () => null,
              );
              return move;
            }));
}
