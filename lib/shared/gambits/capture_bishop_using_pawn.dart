import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingPawn extends Gambit {
  // singleton logic so that CaptureBishopUsingPawn is only created once
  static final CaptureBishopUsingPawn _singleton =
      CaptureBishopUsingPawn._internal();
  factory CaptureBishopUsingPawn() => _singleton;

  CaptureBishopUsingPawn._internal()
      : super(
            cost: 2,
            demoFEN:
                'rnb1k2r/pppppppp/8/3Q4/2q1bRn1/3P1P2/PPP1PNPP/1NB1KB1R w Kkq - 0 1',
            title: "Pawn takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a pawn.",
            altText: "You've been doing WHAT with my tithes?",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithPawn = game
                  .moves()
                  .where((move) =>
                      move.toString()[0] !=
                          move.toString()[0].toUpperCase() && // its a pawn move
                      move.toString().contains('x')) // it is a capture
                  .toList();
              capturesWithPawn.shuffle();
              String move = capturesWithPawn.firstWhere(
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
