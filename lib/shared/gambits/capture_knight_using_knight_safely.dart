import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingKnightSafely extends Gambit {
  // singleton logic so that CaptureKnightUsingKnightSafely is only created once
  static final CaptureKnightUsingKnightSafely _singleton =
      CaptureKnightUsingKnightSafely._internal();
  factory CaptureKnightUsingKnightSafely() => _singleton;

  CaptureKnightUsingKnightSafely._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r3k3/pp1pppp1/8/2p5/8/n1q2b1n/PPpPPPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Knight, safely",
            color: Colors.red,
            description:
                "Capture an enemy knight with one of your own--only if there is no threat of recapture",
            altText: "Could they not afford real soldiers?",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.KNIGHT &&
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
