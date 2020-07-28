import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingKing extends Gambit {
  // singleton logic so that CaptureKnightUsingKing is only created once
  static final CaptureKnightUsingKing _singleton =
      CaptureKnightUsingKing._internal();
  factory CaptureKnightUsingKing() => _singleton;

  CaptureKnightUsingKing._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN: '4k3/8/8/8/5n2/4Kb2/3r4/8 w - - 0 1',
            title: "King takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with the king.",
            altText: "No songs for you.",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithKing = game
                  .moves()
                  .where((move) => move.toString().contains('Kx'))
                  .toList();
              capturesWithKing.shuffle();
              String move = capturesWithKing.firstWhere(
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
