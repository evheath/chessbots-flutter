import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingKnight extends Gambit {
  // singleton logic so that CapturePawnUsingKnight is only created once
  static final CapturePawnUsingKnight _singleton =
      CapturePawnUsingKnight._internal();
  factory CapturePawnUsingKnight() => _singleton;

  CapturePawnUsingKnight._internal()
      : super(
            cost: 1,
            demoFEN:
                'rn2k3/ppp1ppp1/8/8/8/b1q2b1n/PPprpPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with a knight.",
            altText: "Consider it mercy",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithKnight = game
                  .moves()
                  .where((move) =>
                      move.toString().contains('N') &&
                      move.toString().contains('x'))
                  .toList();
              capturesWithKnight.shuffle();
              String move = capturesWithKnight.firstWhere(
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
