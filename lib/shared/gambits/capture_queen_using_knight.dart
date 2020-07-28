import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingKnight extends Gambit {
  // singleton logic so that CaptureQueenUsingKnight is only created once
  static final CaptureQueenUsingKnight _singleton =
      CaptureQueenUsingKnight._internal();
  factory CaptureQueenUsingKnight() => _singleton;

  CaptureQueenUsingKnight._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN:
                'rn2k3/ppp1ppp1/8/8/8/b1q2b1n/PPprpPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with a knight.",
            altText: "You're no queen of mine.",
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
                  return pieceBeingCaptured == chess.PieceType.QUEEN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
