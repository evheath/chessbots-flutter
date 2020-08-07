import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingKnightSafely extends Gambit {
  // singleton logic so that CaptureRookUsingKnightSafely is only created once
  static final CaptureRookUsingKnightSafely _singleton =
      CaptureRookUsingKnightSafely._internal();
  factory CaptureRookUsingKnightSafely() => _singleton;

  CaptureRookUsingKnightSafely._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1n2k3/1ppp1pp1/2n1pb2/p7/8/r1q3Pr/PPpPPP1P/RNBQKBNR w KQ - 0 1',
            title: "Knight takes Rook, safely",
            color: Colors.red,
            description:
                "Capture an enemy rook with a knight--only if there is no threat of recapture",
            altText: "Even the saboteurs are to be put to the sword.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.ROOK &&
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
