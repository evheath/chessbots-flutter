import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingKing extends Gambit {
  // singleton logic so that CaptureRookUsingKing is only created once
  static final CaptureRookUsingKing _singleton =
      CaptureRookUsingKing._internal();
  factory CaptureRookUsingKing() => _singleton;

  CaptureRookUsingKing._internal()
      : super(
            cost: 2,
            demoFEN: 'rnb1kbn1/pppp1ppp/8/8/8/2q5/PPPPpr2/RNBQK1N1 w Qq - 0 1',
            title: "King takes Rook",
            color: Colors.red,
            description: "Capture an enemy rook with the king.",
            altText: "I've seen more castles fall than men grow old.",
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
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
