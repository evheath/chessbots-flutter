import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingKnightSafely extends Gambit {
  // singleton logic so that CaptureQueenUsingKnightSafely is only created once
  static final CaptureQueenUsingKnightSafely _singleton =
      CaptureQueenUsingKnightSafely._internal();
  factory CaptureQueenUsingKnightSafely() => _singleton;

  CaptureQueenUsingKnightSafely._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r3k2r/ppppppp1/8/8/8/b1q1nb1n/PPpPPPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Queen, safely",
            color: Colors.red,
            description:
                "Capture an enemy queen with a knight--only if there is no threat of recapture",
            altText:
                "Give no quarter, the queen is reported to be hiding among the commoners.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
                      move.piece == chess.PieceType.KNIGHT)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
