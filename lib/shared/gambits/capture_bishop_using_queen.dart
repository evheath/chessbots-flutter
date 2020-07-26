import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingQueen extends Gambit {
  // singleton logic so that CaptureBishopUsingQueen is only created once
  static final CaptureBishopUsingQueen _singleton =
      CaptureBishopUsingQueen._internal();
  factory CaptureBishopUsingQueen() => _singleton;

  CaptureBishopUsingQueen._internal()
      : super(
            cost: 2,
            demoFEN:
                'rn2k2r/ppppppp1/8/8/8/bQq2b1n/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a queen.",
            altText: "There's no stopping a rumor, only changing it.",
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
                  return pieceBeingCaptured == chess.PieceType.BISHOP;
                },
                orElse: () => null,
              );
              return move;
            }));
}
