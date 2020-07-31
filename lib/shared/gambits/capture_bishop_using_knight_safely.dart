import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingKnightSafely extends Gambit {
  // singleton logic so that CaptureBishopUsingKnightSafely is only created once
  static final CaptureBishopUsingKnightSafely _singleton =
      CaptureBishopUsingKnightSafely._internal();
  factory CaptureBishopUsingKnightSafely() => _singleton;

  CaptureBishopUsingKnightSafely._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r3k2r/ppppppp1/8/8/8/b1q1nb1n/PPpPPPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Bishop, safely",
            color: Colors.red,
            description:
                "Capture an enemy bishop with a knight--only if there is no threat of recapture",
            altText: "You should have stayed in the Confessional, father",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
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
