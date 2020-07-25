import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingPawn extends Gambit {
  // singleton logic so that CaptureKnightUsingPawn is only created once
  static final CaptureKnightUsingPawn _singleton =
      CaptureKnightUsingPawn._internal();
  factory CaptureKnightUsingPawn() => _singleton;

  CaptureKnightUsingPawn._internal()
      : super(
            cost: 2,
            demoFEN:
                'rnb1k2r/pppppppp/8/3Q4/2q1bRn1/3P1P2/PPP1PNPP/1NB1KB1R w Kkq - 0 1',
            title: "Pawn takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with a pawn.",
            altText: "Nothing warms my heart like worms feasting on yours.",
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
                  return pieceBeingCaptured == chess.PieceType.KNIGHT;
                },
                orElse: () => null,
              );
              return move;
            }));
}
