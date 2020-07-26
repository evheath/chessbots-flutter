import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingKing extends Gambit {
  // singleton logic so that CaptureBishopUsingKing is only created once
  static final CaptureBishopUsingKing _singleton =
      CaptureBishopUsingKing._internal();
  factory CaptureBishopUsingKing() => _singleton;

  CaptureBishopUsingKing._internal()
      : super(
            cost: 1,
            demoFEN: '4k3/8/8/8/3q4/4Kb2/8/8 w - - 0 1',
            title: "King takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a king.",
            altText: "I'm afraid I'm only as good as MY God",
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
                  return pieceBeingCaptured == chess.PieceType.BISHOP;
                },
                orElse: () => null,
              );
              return move;
            }));
}
