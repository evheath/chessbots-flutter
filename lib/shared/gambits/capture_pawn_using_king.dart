import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingKing extends Gambit {
  // singleton logic so that CapturePawnUsingKing is only created once
  static final CapturePawnUsingKing _singleton =
      CapturePawnUsingKing._internal();
  factory CapturePawnUsingKing() => _singleton;

  CapturePawnUsingKing._internal()
      : super(
            cost: 0,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn)
            ],
            demoFEN:
                'rnbqkb1r/ppppp2p/8/3n1p2/4Kp2/4P1N1/PPPP1PPP/RNBQ1B1R w kq - 0 1',
            title: "King takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with the king.",
            altText: "Are my subjects this ravenous?",
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
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
