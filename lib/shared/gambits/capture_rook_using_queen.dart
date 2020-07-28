import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingQueen extends Gambit {
  // singleton logic so that CaptureRookUsingQueen is only created once
  static final CaptureRookUsingQueen _singleton =
      CaptureRookUsingQueen._internal();
  factory CaptureRookUsingQueen() => _singleton;

  CaptureRookUsingQueen._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook)
            ],
            demoFEN:
                '1nb1kbn1/p1pppp1p/1p6/r7/1r2B3/Q2q1p2/PPPPPPPP/RNB1K1NR w KQ - 0 1',
            title: "Queen takes Rook",
            color: Colors.red,
            description: "Capture an enemy rook with a queen.",
            altText: "Not as big as I prefer.",
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
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
