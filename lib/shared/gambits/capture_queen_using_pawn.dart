import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingPawn extends Gambit {
  // singleton logic so that CaptureQueenUsingPawn is only created once
  static final CaptureQueenUsingPawn _singleton =
      CaptureQueenUsingPawn._internal();
  factory CaptureQueenUsingPawn() => _singleton;

  CaptureQueenUsingPawn._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN:
                'rnb1k2r/ppppppPp/P4P2/3Q4/2q1bRn1/3P1P2/2P1PNP1/1NB1KB1R w Kkq - 0 1',
            title: "Pawn takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with a pawn.",
            altText: "Which pile of bones belonged to the queen?",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
                      move.piece == chess.PieceType.PAWN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
