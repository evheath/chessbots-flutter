import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingKnightSafely extends Gambit {
  // singleton logic
  static final CaptureRandomUsingKnightSafely _singleton =
      CaptureRandomUsingKnightSafely._internal();
  factory CaptureRandomUsingKnightSafely() => _singleton;

  CaptureRandomUsingKnightSafely._internal()
      : super(
            cost: 7,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1nb1k3/prppppPp/P4P2/3Q4/2q1rRn1/3P1P2/2P1PNP1/1NB1KB1R w K - 0 1',
            title: "Knight takes Random, safely",
            color: Colors.red,
            description:
                "Capture any enemy piece with a knight--only if there is no threat of recapture",
            altText: "This is why I joined the cavalry.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
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
