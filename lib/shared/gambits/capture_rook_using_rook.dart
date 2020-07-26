import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingRook extends Gambit {
  // singleton logic so that CaptureRookUsingRook is only created once
  static final CaptureRookUsingRook _singleton =
      CaptureRookUsingRook._internal();
  factory CaptureRookUsingRook() => _singleton;

  CaptureRookUsingRook._internal()
      : super(
            cost: 2,
            demoFEN: '4k3/2qpppp1/8/8/pbR1r1Rr/2n5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Rook",
            color: Colors.red,
            description: "Capture an enemy rook with your own.",
            altText: "I said I don't care, now load it into the trebuchet.",
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
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
