import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingQueen extends Gambit {
  // singleton logic so that CaptureQueenUsingQueen is only created once
  static final CaptureQueenUsingQueen _singleton =
      CaptureQueenUsingQueen._internal();
  factory CaptureQueenUsingQueen() => _singleton;

  CaptureQueenUsingQueen._internal()
      : super(
            cost: 4,
            demoFEN:
                '1nb1kbn1/pppppp1p/2r3r1/8/4B3/Q2q1p2/PPPPPPPP/RNB1K1NR w KQ - 0 1',
            title: "Queen takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with your own.",
            altText: "I grew tired of waiting for your husband to do it.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithQueen = game
                  .moves()
                  .where((move) =>
                      move.toString().contains('Q') &&
                      move.toString().contains('x'))
                  .toList();
              capturesWithQueen.shuffle();
              String move = capturesWithQueen.firstWhere(
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
