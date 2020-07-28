import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingQueen extends Gambit {
  // singleton logic so that CapturePawnUsingQueen is only created once
  static final CapturePawnUsingQueen _singleton =
      CapturePawnUsingQueen._internal();
  factory CapturePawnUsingQueen() => _singleton;

  CapturePawnUsingQueen._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn)
            ],
            demoFEN:
                'rn2k2r/ppppppp1/8/8/8/bQq2b1n/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with a queen.",
            altText: "Do I even need to bury this one?",
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
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
