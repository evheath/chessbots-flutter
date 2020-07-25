import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingPawn extends Gambit {
  // singleton logic so that CapturePawnUsingPawn is only created once
  static final CapturePawnUsingPawn _singleton =
      CapturePawnUsingPawn._internal();
  factory CapturePawnUsingPawn() => _singleton;

  CapturePawnUsingPawn._internal()
      : super(
            cost: 1,
            demoFEN:
                'rnb1k2r/ppppppPp/P4P2/3Q4/2q1bRn1/3P1P2/2P1PNP1/1NB1KB1R w Kkq - 0 1',
            title: "Pawn takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with your own.",
            altText: "I knew yous was a spy.",
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
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
